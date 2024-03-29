//
//  IGLoginViewController.m
//  Instagrahm
//
//  Created by amandahar on 7/8/19.
//  Copyright © 2019 amandahar. All rights reserved.
//

#import "IGLoginViewController.h"
#import "Parse/Parse.h"

@interface IGLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;

@end

@implementation IGLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)didTapSignUp:(id)sender {
    [self performSegueWithIdentifier:@"createAccountSegue" sender:nil];
}

- (IBAction)didTapSignIn:(id)sender {
    [self loginUser];
}
- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
}

- (void)loginUser {
    NSString *username = self.usernameText.text;
    NSString *password = self.passwordText.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            [self performSegueWithIdentifier:@"signInSegue" sender:nil];
            // display view controller that needs to shown after successful login 
        }
    }];
}

-(NSString*)getUsername {
    return self.usernameText.text;
}

-(NSString*)getPassword {
    return self.passwordText.text;
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
