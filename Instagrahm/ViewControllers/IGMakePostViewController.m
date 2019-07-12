//
//  IGMakePostViewController.m
//  Instagrahm
//
//  Created by amandahar on 7/9/19.
//  Copyright © 2019 amandahar. All rights reserved.
//

#import "IGMakePostViewController.h"
#import <UIKit/UIKit.h>
#import "IGPost.h"


@interface IGMakePostViewController () 
@property (weak, nonatomic) IBOutlet UIImageView *composePostImage;
@property (weak, nonatomic) IBOutlet UITextField *composeCaption;
@property (weak, nonatomic) IBOutlet UILabel *tapImageLabel;


@end

@implementation IGMakePostViewController

-(void) tapImage:(id)sender{
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
   
   
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        // camera is not available so photo library will pop up instead
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
     [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (IBAction)uploadFromLibraryButton:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
    [self.composePostImage addGestureRecognizer:profileTapGestureRecognizer];
    [self.composePostImage setUserInteractionEnabled:YES];
    
}

- (IBAction)cancelPost:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)shareButton:(id)sender {
    [IGPost postUserImage:self.composePostImage.image withCaption:self.composeCaption.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        //completion
        if (succeeded) {
            NSLog(@"posted");
        } else {
            NSLog(@"wrong");
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    // Do something with the images (based on your use case)
    UIImage *resizedImage = [self resizeImage:editedImage withSize:CGSizeMake(200, 200)];
    self.composePostImage.image = resizedImage;
    
    [self.tapImageLabel setHidden:YES];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
