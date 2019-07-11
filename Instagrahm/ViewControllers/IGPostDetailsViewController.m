//
//  IGPostDetailsViewController.m
//  Instagrahm
//
//  Created by amandahar on 7/10/19.
//  Copyright © 2019 amandahar. All rights reserved.
//

#import "IGPostDetailsViewController.h"
#import "IGPost.h"
#import "UIImageView+AFNetworking.h"
#import "DateTools.h"

@interface IGPostDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *captionText;

@property (weak, nonatomic) IBOutlet UILabel *timeStampLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;


@end

@implementation IGPostDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *caption = self.post.caption;
    NSString *imageURlString = self.post.image.url;
    NSURL *imageURL = [NSURL URLWithString:imageURlString];
    NSString *username = self.post.author.username;
    NSDate *timeStamp = self.post.createdAt;
    
    self.captionText.text = caption;
    [self.postImage setImageWithURL:imageURL];
    self.usernameLabel.text = username;
    self.timeStampLabel.text = timeStamp.timeAgoSinceNow;
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
