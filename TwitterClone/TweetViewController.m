//
//  DetailViewController.m
//  TwitterClone
//
//  Created by Amber Roy on 1/23/14.
//  Copyright (c) 2014 Amber Roy. All rights reserved.
//

#import "TweetViewController.h"

@interface TweetViewController ()
- (void)configureView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@end

@implementation TweetViewController

- (IBAction)retweet:(id)sender {
    // TODO
    NSLog(@"Retweet not yet implemented.");
}
- (IBAction)favorite:(id)sender {
    // TODO
    NSLog(@"Favorite not yet implemented.");
}

#pragma mark - Managing the detail item

- (void)setTweet:(id)newTweet
{
    if (self.tweet != newTweet) {
        self.tweet = newTweet;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.tweet) {
        self.nameLabel.text = self.tweet.name;
        self.usernameLabel.text = self.tweet.username;
        self.userImage.image = self.tweet.userImage;
        self.tweetLabel.text = self.tweet.tweet;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showComposeWithReply"]) {
        [segue.destinationViewController setReplyTo:self.tweet.username];
        [segue.destinationViewController setDelegate:self];
    }
}



#pragma mark - ComposeViewControllerDelegate
-(void)composeViewControllerDidFinish:(ComposeViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
