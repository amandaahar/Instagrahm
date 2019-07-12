//
//  IGProfilePageViewController.m
//  Instagrahm
//
//  Created by amandahar on 7/11/19.
//  Copyright © 2019 amandahar. All rights reserved.
//

#import "IGProfilePageViewController.h"
#import "Parse/Parse.h"
#import "IGProfileCollectionViewCell.h"
#import "IGPost.h"
#import "UIImageView+AFNetworking.h"
@interface IGProfilePageViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) NSMutableArray *posts;

@property (weak, nonatomic) IBOutlet UICollectionView *profilePageCollectionView;


@end

@implementation IGProfilePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.posts = [[NSMutableArray alloc] init];
    self.profilePageCollectionView.dataSource = self;
    self.profilePageCollectionView.delegate = self;
    self.navigationItem.title = PFUser.currentUser.username;
    
    [self fetchPosts];
}

-(void) fetchPosts {
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"author" equalTo:PFUser.currentUser];
    
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [query includeKey:@"createdAt"];
    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray<IGPost *> * _Nullable posts, NSError * _Nullable error) {
        if (!error) {
            // do something with the data fetched
            [self.posts addObjectsFromArray:posts];
            [self.profilePageCollectionView reloadData];
        }
        else {
            // handle error
            NSLog(@"Error getting home timeline: %@", error.localizedDescription);
        }
        
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    IGProfileCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IGProfileCollectionViewCell" forIndexPath:indexPath];
    
    IGPost *post = self.posts[indexPath.item];
    NSString *imageURlString = post.image.url;
    NSURL *imageURL = [NSURL URLWithString:imageURlString];
    
    [cell setPhotoImageWithURL:imageURL];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}



@end
