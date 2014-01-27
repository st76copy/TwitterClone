//
//  Tweet.m
//  TwitterClone
//
//  Created by Amber Roy on 1/23/14.
//  Copyright (c) 2014 Amber Roy. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (Tweet *)initWithDictionary:(NSDictionary *)dict
{
    self.name = dict[@"user"][@"name"];
    self.username = dict[@"user"][@"screen_name"];
    self.userId = dict[@"user"][@"id_str"];
    
    NSURL *user_image_url = [NSURL URLWithString:dict[@"user"][@"profile_image_url"]];
    self.userImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:user_image_url]];
    
    self.tweet = dict[@"text"];
    self.tweetImage = dict[@"tweetImage"];
    self.tweetId = dict[@"id_str"];
    self.timestamp = dict[@"created_at"];
    self.favorited = [dict[@"favorited"] boolValue];
    self.retweeted = [dict[@"retweeted"] boolValue];
    
    return self;
}

@end
