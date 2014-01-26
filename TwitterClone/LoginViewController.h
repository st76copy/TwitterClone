//
//  LoginViewController.h
//  TwitterClone
//
//  Created by Amber Roy on 1/25/14.
//  Copyright (c) 2014 Amber Roy. All rights reserved.
//

#import <UIKit/UIKit.h>

// AJR - Modal VC defines delegate protocol,  (Add @class )
// Delegate header file must add <LoginViewControllerDelegate>
@class LoginViewController;

@protocol LoginViewControllerDelegate

// AJR - Delegate implements this method and calls
// [self dismissViewControllerAnimated:YES completion:nil];
- (void)loginViewControllerDidFinish:(LoginViewController *)controller;
@end

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

// AJR - Property set by delegate in its prepareForSegue method
// if ([segue.identifier isEqualToString:@"showLogin"]) {
//     [segue.destinationViewController setDelegate:self];}
@property (weak, nonatomic) id <LoginViewControllerDelegate> delegate;

// AJR - Method that will dismiss this view, usually from button,
// calls [self.delegate loginViewControllerDidFinish:self];
- (IBAction)loginButton:(id)sender;

@end
