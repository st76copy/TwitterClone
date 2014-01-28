//
//  TweetViewController.h
//  TwitterClone
//
//  Created by Amber Roy on 1/23/14.
//  Copyright (c) 2014 Amber Roy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposeViewController.h"
#import "TimelineViewController.h"
#import "Tweet.h"
#import "TwitterAPI.h"

@interface TweetViewController : UIViewController <TwitterAPIDelegate>

@property (strong, nonatomic) Tweet *tweet;
@property (strong, nonatomic) Tweet *currentUserInfo;
@property TimelineViewController *timelineViewController;
-(void)setTweet:(Tweet *)tweet;

@end
