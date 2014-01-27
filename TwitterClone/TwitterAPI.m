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


- (void)accessTwitterAPI:(TwitterOperation)operation parameters:(NSDictionary *)parameters;

//@property NSArray *dataSource;
    
@end


@implementation TwitterAPI


- (void)accessTwitterAPI:(TwitterOperation)operation parameters:(NSDictionary *)parameters
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
                 self.current_username = twitterAccount.username;
                 NSLog(@"Twitter account access granted, proceeding with request.");
                 
                 NSURL *requestURL;
                 SLRequestMethod myRequestMethod;
                 NSDictionary  *myParams = parameters;
                 BOOL expectingResponse = YES;
                 switch (operation) {
                     case HOME_TIMELINE:
                         requestURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/home_timeline.json"];
                         myRequestMethod = SLRequestMethodGET;
                         if (!myParams) {
                             myParams = @{ @"count": @"20", @"include_entities": @"1"};
                         }
                         break;
                         
                     case SHOW_CURRENT_USER:
                         requestURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"];
                         myRequestMethod = SLRequestMethodGET;
                         if (!myParams) {
                             myParams = @{ @"screen_name": self.current_username};
                         } else {
                             [myParams setValue:self.current_username forKey:@"screen_name"];
                         }
                         break;
                         
                     case POST_TWEET:
                         requestURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/update.json"];
                         myRequestMethod = SLRequestMethodPOST;
                         if (!myParams || !myParams[@"status"]) {
                             NSLog(@"Cannot post new Tweet: Failed to specify 'status' parameter.");
                             NSString *errorMessage = @"Cannot post Tweet due to internal error.";
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 [self.delegate twitterDidReturn:nil operation:operation errorMessage:errorMessage];
                             });
                         }
                         expectingResponse = NO;
                         break;
                         
                     default:
                         NSLog(@"Cannot access Twitter API, unrecognized opeartion: %i", operation);
                         NSString *errorMessage = @"Cannot access Twitter due to internal error.";
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [self.delegate twitterDidReturn:nil operation:operation errorMessage:errorMessage];
                         });
                         break;
                 }
                 
                 SLRequest *postRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:myRequestMethod URL:requestURL parameters:myParams];
                 postRequest.account = twitterAccount;
                 
                 NSLog(@"Sending request: %@", requestURL);
                 [postRequest performRequestWithHandler: ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
                  {
                      //if (expectingResponse) {
                          NSArray *dataSource = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                          if (dataSource.count != 0) {
                          
                              NSLog(@"JSON Response: %@", dataSource);
                              [self.delegate twitterDidReturn:dataSource operation:operation errorMessage:nil];
                          } else {
                              NSLog(@"Response contains no data. Error: %@", error);
                          }
                      //}
                  }];
                 
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

@end


