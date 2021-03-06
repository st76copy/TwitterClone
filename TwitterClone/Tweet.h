//
//  Tweet.h
//  TwitterClone
//
//  Created by Amber Roy on 1/23/14.
//  Copyright (c) 2014 Amber Roy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject

- (Tweet *)initWithDictionary:(NSDictionary *)dict;

@property NSString *name;
@property NSString *username;
@property UIImage *userImage;

@property NSString *tweet;
@property NSURL *tweetImageURL;
@property NSString *timestamp;
@property BOOL favorited;
@property BOOL retweeted;

@property NSString *tweetId;
@property NSString *userId;

@end
