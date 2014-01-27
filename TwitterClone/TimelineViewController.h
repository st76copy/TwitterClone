//
//  MasterViewController.h
//  TwitterClone
//
//  Created by Amber Roy on 1/23/14.
//  Copyright (c) 2014 Amber Roy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "ComposeViewController.h"
#import "TwitterAPI.h"

@interface TimelineViewController : UITableViewController <TwitterAPIDelegate, ComposeViewControllerDelegate, UIAlertViewDelegate>

@end
