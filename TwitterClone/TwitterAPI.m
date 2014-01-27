//
//  TwitterAPI.m
//  TwitterClone
//
//  Created by Amber Roy on 1/26/14.
//  Copyright (c) 2014 Amber Roy. All rights reserved.
//

#import <Accounts/Accounts.h>
#import <Social/Social.h>

#import "TwitterAPI.h"

@interface TwitterAPI ()


- (void)accessTwitterAPI:(TwitterOperation)operation;
- (void)homeTimeline:(ACAccount *)twitterAccount;
    
//@property NSArray *dataSource;
    
@end


@implementation TwitterAPI


- (void)accessTwitterAPI:(TwitterOperation)operation
{
    // Example usage: [self accessTwitterAPI:HOME_TIMELINE];
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error)
     {
         if (granted == YES)
         {
             NSArray *arrayOfAccounts = [accountStore accountsWithAccountType:accountType];
             if ([arrayOfAccounts count] > 0) {
                 ACAccount *twitterAccount = [arrayOfAccounts lastObject];
                 NSLog(@"Twitter account access granted, proceeding with request.");
                 
                 switch (operation) {
                     case HOME_TIMELINE:
                         [self homeTimeline:twitterAccount];
                         break;
                         
                     default:
                         NSLog(@"Cannot access Twitter API, unrecognized opeartion: %i", operation);
                         NSString *errorMessage = @"Cannot access Twitter due to internal error.";
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [self.delegate twitterDidReturn:nil operation:operation errorMessage:errorMessage];
                         });
                         break;
                 }
             } else {
                 NSLog(@"No Twitter Account found on this device.");
                 NSString *errorMessage = @"No Twitter accounts configured.      \n"
                                          @"Go to iOS Home->Settings->Twitter,   \n"
                                          @"Add Account, then retry.";
                 NSLog(@"%@", errorMessage);
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self.delegate twitterDidReturn:nil operation:operation errorMessage:errorMessage];
                 });
             }
         } else {
             NSLog(@"Twitter Access not granted for this app.");
             NSString *errorMessage = @"To continue, grant Twitter access.   \n"
                                      @"Go to iOS Home->Settings->Twitter,   \n"
                                      @"scroll down to Allow These Apps,     \n"
                                      @"enable this app, then retry.";
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.delegate twitterDidReturn:nil operation:operation errorMessage:errorMessage];
             });
         }
     }];
}

- (void)homeTimeline:(ACAccount *)twitterAccount
{
    // Do not call this method directly, must be call from requestAccessToAccountsWithType completion Block.
    NSURL *requestURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/home_timeline.json"];
    NSDictionary *parameters = @{ @"count": @"20", @"include_entities": @"1"};
    
    SLRequest *postRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:requestURL parameters:parameters];
    postRequest.account = twitterAccount;
    
    NSLog(@"Sending request: %@", requestURL);
    [postRequest performRequestWithHandler: ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
     {
         NSArray *dataSource = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
         if (dataSource.count != 0) {
             
             NSLog(@"JSON Response: %@", dataSource);
             [self.delegate twitterDidReturn:dataSource operation:HOME_TIMELINE errorMessage:nil];
             //dispatch_async(dispatch_get_main_queue(), ^{
             //    [self.tweetTableView reloadData];
             //});
         } else {
             NSLog(@"Response contains no data. Error: %@", error);
         }
     }];
}

@end


