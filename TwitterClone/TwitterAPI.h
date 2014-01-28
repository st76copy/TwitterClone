//
//  TwitterAPI.h
//  TwitterClone
//
//  Created by Amber Roy on 1/26/14.
//  Copyright (c) 2014 Amber Roy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TwitterAPI;

@protocol TwitterAPIDelegate

typedef enum {
    HOME_TIMELINE,
    SHOW_CURRENT_USER,
    POST_TWEET,
    POST_RETWEET,
    FAVORITES_CREATE,
} TwitterOperation;

// ErrorMessage is nil unless we failed to get access to Twitter on this device.
- (void)twitterDidReturn:(NSArray *)data operation:(TwitterOperation)operation errorMessage:(NSString *)errorMessage;
@end


@interface TwitterAPI : NSObject

@property (weak, nonatomic) id <TwitterAPIDelegate> delegate;
@property NSString *current_username;

- (void)accessTwitterAPI:(TwitterOperation)operation parameters:(NSDictionary *)parameters;

@end
