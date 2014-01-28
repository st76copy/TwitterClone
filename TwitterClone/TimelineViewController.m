//
//  TimelineViewController.m
//  TwitterClone
//
//  Created by Amber Roy on 1/23/14.
//  Copyright (c) 2014 Amber Roy. All rights reserved.
//

#import "TimelineViewController.h"

#import "TweetViewController.h"
#import "TweetCell.h"
#import "Tweet.h"

@interface TimelineViewController ()

@end

@implementation TimelineViewController
{
    TwitterAPI *_twitterAPI;
    NSMutableArray *_tweets;
    NSMutableArray *_dataFromTwitter;
    
    Tweet *_currentUserInfo;
    
    BOOL _isAuthenticated;
    UIActivityIndicatorView *_spinner;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _isAuthenticated = NO;
    _twitterAPI = [[TwitterAPI alloc] init];
    [_twitterAPI setDelegate:self];
    [_twitterAPI accessTwitterAPI:HOME_TIMELINE parameters:nil];
    [_twitterAPI accessTwitterAPI:SHOW_CURRENT_USER parameters:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didPushRefresh:(id)sender {
    [_spinner startAnimating];
    [_twitterAPI accessTwitterAPI:HOME_TIMELINE parameters:nil];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [_spinner startAnimating];
    [_twitterAPI accessTwitterAPI:HOME_TIMELINE parameters:nil];
}

#pragma mark - TwitterApi
- (void)twitterDidReturn:(NSArray *)data operation:(TwitterOperation)operation errorMessage:(NSString *)errorMessage
{
    if (_spinner.isAnimating) {
        [_spinner stopAnimating];
    }
    
    if (errorMessage) {
        _isAuthenticated = NO;
        NSLog(@"TwitterDidReturn with error.");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Setup Error"
                                              message:errorMessage delegate:self
                                              cancelButtonTitle:@"Retry"
                                              otherButtonTitles:nil, nil
        ];
        [alertView show];
    } else {
        _isAuthenticated = YES;
        
        switch (operation) {
                
            case HOME_TIMELINE: {
                _dataFromTwitter = [[NSMutableArray alloc] initWithArray:data];
                _tweets = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in data) {
                    Tweet *tweet = [[Tweet alloc] initWithDictionary:dict];
                    [_tweets addObject:tweet];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
                break;
            }
                
            case SHOW_CURRENT_USER: {
                NSLog(@"Done getting current user data.");
                _currentUserInfo = [[Tweet alloc] initWithDictionary:@{@"user": data}];
                break;
            }
                
            case POST_TWEET: {
                NSLog(@"Done posting tweet.");
                break;
            }
                
            default:
                NSLog(@"TwitterDidReturn with unknown operation: %i", operation);
                break;
        }
    }
    
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!_isAuthenticated) {
        return 1;
    }
    
    if (!_tweets) {
        return 0;
    }
    
    return [_tweets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_isAuthenticated) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        _spinner.center = cell.center;
        [cell addSubview:_spinner];
        [_spinner startAnimating];
        return cell;
    }
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    Tweet *tweet = [_tweets objectAtIndex:indexPath.row];
    cell = [cell initWithTweet:tweet];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tweet *tweet = _tweets[indexPath.row];
    if (tweet.tweetImageURL) {
        return 155;         // Height of prototype cell, with tweetImage.
    } else {
        return 155 - 76;    // Above minus the height of the tweetImage.
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showTweet"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Tweet *tweet = _tweets[indexPath.row];
        TweetViewController *tvc = (TweetViewController *)segue.destinationViewController;
        tvc.tweet = tweet;
        tvc.timelineViewController = self;
        [segue.destinationViewController setCurrentUserInfo:_currentUserInfo];
    } else if ([segue.identifier isEqualToString:@"showCompose"]) {
        [segue.destinationViewController setCurrentUserInfo:_currentUserInfo];
        [segue.destinationViewController setReplyTo:nil];
        [segue.destinationViewController setDelegate:self];
    } else {
        NSLog(@"Unrecognized segue.identifier: %@", segue.identifier);
    }
}

#pragma mark - ComposeViewControllerDelegate
-(void)composeViewControllerDidFinish:(ComposeViewController *)controller
{
    ComposeViewController *cvc = (ComposeViewController *)controller;
    if (cvc.tweetText) {
        Tweet *newTweet = _currentUserInfo;
        newTweet.tweet = cvc.tweetText;
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        // Sun Jan 26 10:33:03 +0000 2014
        [df setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
        newTweet.timestamp = [df stringFromDate:[NSDate date]];
        [_tweets insertObject:newTweet atIndex:0];
        [self.tableView reloadData];
        
        if (cvc.replyTo) {
            NSDictionary *parameters = @{@"status": newTweet.tweet,
                           @"in_reply_to_status_id": cvc.replyTo.tweetId};
            [_twitterAPI accessTwitterAPI:POST_TWEET parameters:parameters];
        } else {
            NSDictionary *parameters = @{@"status": newTweet.tweet};
            [_twitterAPI accessTwitterAPI:POST_TWEET parameters:parameters];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
