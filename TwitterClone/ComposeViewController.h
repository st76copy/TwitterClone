//
//  ComposeViewController.h
//  TwitterClone
//
//  Created by Amber Roy on 1/25/14.
//  Copyright (c) 2014 Amber Roy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ComposeViewController;

@protocol ComposeViewControllerDelegate
- (void)composeViewControllerDidFinish:(ComposeViewController *)controller;
@end

@interface ComposeViewController : UIViewController

@property (weak, nonatomic) id <ComposeViewControllerDelegate> delegate;

@property NSString *replyTo;
// Following are for the current user, who is composing the tweet.
@property NSString *senderName;
@property NSString *senderUsername;
@property UIImage *senderImage;

-(IBAction)doneCompose:(id)sender;
-(IBAction)cancelCompose:(id)sender;

@end
