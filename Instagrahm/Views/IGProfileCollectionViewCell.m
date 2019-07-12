//
//  IGProfileCollectionViewCell.m
//  Instagrahm
//
//  Created by amandahar on 7/11/19.
//  Copyright © 2019 amandahar. All rights reserved.
//

#import "IGProfileCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface IGProfileCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *profilePostsImage;


@end

@implementation IGProfileCollectionViewCell

-(UIImageView *) getPhotoImage {
    return self.profilePostsImage;
}

-(void) setPhotoImageWithURL: (NSURL *) imageURL {
    [self.profilePostsImage setImageWithURL:imageURL];
}

@end
