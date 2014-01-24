//
//  TweetCell.m
//  TwitterClone
//
//  Created by Amber Roy on 1/23/14.
//  Copyright (c) 2014 Amber Roy. All rights reserved.
//

#import "TweetCell.h"

@implementation TweetCell

- (TweetCell *)initWithTweet:(Tweet *)tweet
{
    self.nameLabel.text = tweet.name;
    self.usernameLabel.text = tweet.username;
    self.userImage.image = tweet.userImage;
    
    self.tweetLabel.text = tweet.tweet;
    self.tweetImage.image = tweet.tweetImage;
    
    return self;
}

- (TweetCell *)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
