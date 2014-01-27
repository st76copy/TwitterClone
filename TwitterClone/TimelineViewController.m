//
//  MasterViewController.m
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
-(void) loginWithUsername:(NSString *)username;
@end

@implementation TimelineViewController
{
    NSMutableArray *_tweets;
    NSMutableArray *_dataFromTwitter;
    BOOL _isAuthenticated;
    UIActivityIndicatorView *_spinner;
    TwitterAPI *_twitterAPI;
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
    [_twitterAPI accessTwitterAPI:HOME_TIMELINE];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [_spinner startAnimating];
    [_twitterAPI accessTwitterAPI:HOME_TIMELINE];
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
        NSLog(@"TwitterDidReturn without error.");
        
        switch (operation) {
                
            case HOME_TIMELINE:
                _dataFromTwitter = [[NSMutableArray alloc] initWithArray:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
                break;
                
            //default:
            //    NSLog(@"TwitterDidReturn with unknown operation: %i", operation);
            //    break;
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
    
    //return _tweets.count;
    return 5;
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
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tweets[indexPath.row][@"tweetImage"]) {
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
        [tvc setTweet:tweet];
    } if ([segue.identifier isEqualToString:@"showLogin"]) {
        // TODO - logout the current user
        NSLog(@"Logout not yet implemented");
        [segue.destinationViewController setDelegate:self];
    } else if ([segue.identifier isEqualToString:@"showCompose"]) {
        [segue.destinationViewController setReplyTo:nil];
        [segue.destinationViewController setDelegate:self];
    }
}

#pragma mark - LoginViewControllerDelegate
-(void)loginViewControllerDidFinish:(LoginViewController *)controller
{
    LoginViewController *lvc = (LoginViewController *)controller;
    NSLog(@"Login successful for user %@", lvc.usernameField.text);
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ComposeViewControllerDelegate
-(void)composeViewControllerDidFinish:(ComposeViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Twitter API

-(void) loginWithUsername:(NSString *)username;
{

    //NSString *url = [NSString stringWithFormat:
    //                 @"http://api.twitter.com/oauth/authenticate&screen_name=%@", username];

}



//NSURL *url = [NSURL URLWithString:DVD_URL];
//NSURLRequest *request = [NSURLRequest requestWithURL:url];
//[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
// ~~~completionHandler:
// ~~~^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//     ~~~if (connectionError) { NSLog(@"ERROR connecting to %@",DVD_URL); } else {
//         ~~~id object=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//         ~~~NSLog(@"%@", object);  }}];  // Can use NSDictionary instead of id above.
//}

@end
