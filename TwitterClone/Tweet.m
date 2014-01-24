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
    self.name = dict[@"name"];
    self.username = dict[@"username"];
    self.tweet = dict[@"userImage"];
    self.userImage = dict[@"tweet"];
    self.tweetImage = dict[@"tweetImage"];
    
    return self;
}

//- (Tweet *)initWithDummyData
//{
//    return [self initWithDictionary:@{
//          @"name": @"Destiny The GAME",
//          @"username": @"destinythegame",
//          @"userImage": [[UIImage alloc]init],
//          @"tweet": @"#CaptionThis: Send us your best caption for this image, and we'll share our favorites tomorrow!",
//          @"tweetImage": [[UIImage alloc]init],
//     }];
//}

@end
