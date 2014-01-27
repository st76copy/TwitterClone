//
//  TweetViewController.h
//  TwitterClone
//
//  Created by Amber Roy on 1/23/14.
//  Copyright (c) 2014 Amber Roy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposeViewController.h"
#import "Tweet.h"

@interface TweetViewController : UIViewController <ComposeViewControllerDelegate>

@property (strong, nonatomic) Tweet *tweet;
@property (strong, nonatomic) Tweet *currentUserInfo;
-(void)setTweet:(Tweet *)tweet;

@end
