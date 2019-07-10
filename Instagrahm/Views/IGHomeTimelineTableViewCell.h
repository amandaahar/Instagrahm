//
//  IGHomeTimelineTableViewCell.h
//  Instagrahm
//
//  Created by amandahar on 7/9/19.
//  Copyright © 2019 amandahar. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IGHomeTimelineTableViewCell : UITableViewCell

-(UIImageView *) getPhotoImage;
-(UILabel *) getCaption;
-(UILabel *) getUsername;

-(void) setPhotoImageWithURL: (UIImageView *) image;
-(void) setCaptionText: (NSString *) text;
-(void) setUsernameText: (NSString *) text;

@end

NS_ASSUME_NONNULL_END
