//
//  IGProfileCollectionViewCell.h
//  Instagrahm
//
//  Created by amandahar on 7/11/19.
//  Copyright © 2019 amandahar. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IGProfileCollectionViewCell : UICollectionViewCell

-(UIImageView *) getPhotoImage;
-(void) setPhotoImageWithURL: (UIImageView *) image;
@end

NS_ASSUME_NONNULL_END
