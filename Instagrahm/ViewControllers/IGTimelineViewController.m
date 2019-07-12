//
//  IGTimelineViewController.m
//  Instagrahm
//
//  Created by amandahar on 7/8/19.
//  Copyright © 2019 amandahar. All rights reserved.
//

#import "IGTimelineViewController.h"
#import "Parse/Parse.h"
#import "AppDelegate.h"
#import "IGLoginViewController.h"
#import "IGPost.h"
#import "IGHomeTimelineTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "IGPostDetailsViewController.h"
#import "IGInfiniteScrollActivityView.h"

@interface IGTimelineViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *instaFeedTableView;
@property (strong, nonatomic) NSMutableArray *posts;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (strong, nonatomic) InfiniteScrollActivityView *loadingMoreView;
@property (assign, nonatomic) BOOL isMoreDataLoadingOnScroll;


@end

@implementation IGTimelineViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchPosts];
    self.instaFeedTableView.delegate = self;
    self.instaFeedTableView.dataSource = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.instaFeedTableView insertSubview:self.refreshControl atIndex:0];
    
    
    
    CGRect frame = CGRectMake(0, self.instaFeedTableView.contentSize.height, self.instaFeedTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
    self.loadingMoreView = [[InfiniteScrollActivityView alloc] initWithFrame:frame];
    self.loadingMoreView.hidden = true;
    [self.instaFeedTableView addSubview:self.loadingMoreView];
    
    UIEdgeInsets insets = self.instaFeedTableView.contentInset;
    insets.bottom += InfiniteScrollActivityView.defaultHeight;
    self.instaFeedTableView.contentInset = insets;
    
    
    self.posts = [[NSMutableArray alloc] init];
    
    
    
}

- (IBAction)logoutButton:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    IGLoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
    
    
}


- (IBAction)postButton:(id)sender {

    
    [self performSegueWithIdentifier:@"makePostSegue" sender:nil];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    // for segue idetifier put in details segue
    
    if ([segue.identifier isEqualToString:@"detailsSegue"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.instaFeedTableView indexPathForCell:tappedCell];
        IGPost *post = self.posts[indexPath.row];
        
        IGPostDetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.post = post;
    }
    
    
    
}



-(void) fetchPosts {
    // construct PFQuery
    
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [query includeKey:@"createdAt"];
    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray<IGPost *> * _Nullable posts, NSError * _Nullable error) {
        if (!error) {
            // do something with the data fetched
            [self.posts addObjectsFromArray:posts];
            [self.instaFeedTableView reloadData];
        }
        else {
            // handle error
            NSLog(@"Error getting home timeline: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    IGHomeTimelineTableViewCell *cell = [self.instaFeedTableView dequeueReusableCellWithIdentifier:@"IGCell"];
    
    IGPost *post = self.posts[indexPath.row];
    NSString *caption = post.caption;
    NSString *imageURlString = post.image.url;
    NSURL *imageURL = [NSURL URLWithString:imageURlString];
    NSString *author = post.author.username;
    
    
    [cell setCaptionText:caption];
    [cell setPhotoImageWithURL:imageURL];
    [cell setUsernameText:author];

    return cell;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

-(void) loadMoreData {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    IGPost *lastPost = self.posts[self.posts.count - 1];
    
    
    [query whereKey:@"createdAt" lessThan:lastPost.createdAt];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [query includeKey:@"createdAt"];
    
    query.limit = 20;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray<IGPost *> * _Nullable posts, NSError * _Nullable error) {
        if (!error) {
            // do something with the data fetched
            [self.posts addObjectsFromArray:posts];
            
            // Update flag
            self.isMoreDataLoadingOnScroll = false;
            
            // Stop the loading indicator
            [self.loadingMoreView stopAnimating];
            [self.instaFeedTableView reloadData];
        }
        else {
            // handle error
            NSLog(@"Error getting home timeline: %@", error.localizedDescription);
        }
    }];
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.isMoreDataLoading){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.instaFeedTableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.instaFeedTableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.instaFeedTableView.isDragging) {
            self.isMoreDataLoadingOnScroll = true;
            
            // Update position of loadingMoreView, and start loading indicator
            CGRect frame = CGRectMake(0, self.instaFeedTableView.contentSize.height, self.instaFeedTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
            self.loadingMoreView.frame = frame;
            [self.loadingMoreView startAnimating];
            
            // Code to load more results
            [self loadMoreData];
        }
    }
}



 


@end
