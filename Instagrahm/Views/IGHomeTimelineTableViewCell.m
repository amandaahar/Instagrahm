//
//  IGHomeTimelineTableViewCell.m
//  Instagrahm
//
//  Created by amandahar on 7/9/19.
//  Copyright © 2019 amandahar. All rights reserved.
//

#import "IGHomeTimelineTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface IGHomeTimelineTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;


@end

@implementation IGHomeTimelineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UIImageView *) getPhotoImage {
    return self.photoImage;
}

-(UILabel *) getCaption {
    return self.captionLabel;
}

-(UILabel *) getUsername {
    return self.usernameLabel;
}

-(void) setPhotoImageWithURL: (NSURL *) imageURL {
    [self.photoImage setImageWithURL:imageURL];
}

-(void) setCaptionText: (NSString *) text {
    self.captionLabel.text = text;
}

-(void) setUsernameText: (NSString *) text {
    self.usernameLabel.text = text;
}



@end
