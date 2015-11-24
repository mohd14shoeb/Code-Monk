//
//  CMServerHelper.m
//  Code Monk
//
//  Created by yogesh singh on 19/11/15.
//  Copyright © 2015 yogesh singh. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#import "UIView+Toast.h"
#import "MBProgressHUD.h"
#import "CMServerHelper.h"
#import "CMDataParser.h"
#import "CMUtils.h"

@implementation CMServerHelper

+ (void)fetchAllTopics{
    
    CMAppDelegate *appDelegate = (CMAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [manager GET:TOPICSLIST parameters:nil
         success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
      
        [CMDataParser parseAllTopicsInResponse:responseObject];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        NSLog(@"CMServerHelper fetchAllTopics error : %@", error.localizedDescription);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [appDelegate.window makeToast:error.localizedDescription];
    }];
}

+ (void)fetchDetailsOfTopic:(NSNumber *)idValue{

    CMAppDelegate *appDelegate = (CMAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *params = [NSDictionary dictionaryWithObject:idValue forKey:@"id"];

    [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [manager POST:TOPIC_DETAILS
       parameters:params
          success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
              
            [CMDataParser parseTopicDetailsInResponse:responseObject];
              
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
        
          } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
            NSLog(@"error : %@", error.localizedDescription);
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
            [appDelegate.window makeToast:error.localizedDescription];
    }];
}

+ (void)fetchExampleListsOfTopic:(NSNumber *)idValue{
    
    CMAppDelegate *appDelegate = (CMAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *params = [NSDictionary dictionaryWithObject:idValue forKey:@"id"];
    
    [manager POST:EXAMPLES_LIST parameters:params
          success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
              
              [CMDataParser parseExamplesInResponse:responseObject forTopic:idValue];
              
          } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
              
              NSLog(@"error : %@", error.localizedDescription);
              [appDelegate.window makeToast:error.localizedDescription];
          }];
}

+ (void)fetchDetailsOfExample:(NSNumber *)exampleID ofTopic:(NSNumber *)topicID{
    
    CMAppDelegate *appDelegate = (CMAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *params = @{@"id":exampleID, @"topic_id":topicID};
    
    [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [manager POST:EXAMPLE_DETAIL parameters:params
          success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
              [CMDataParser parseExampleDetailsInResponse:responseObject forTopic:topicID];
              
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
              [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
              
          } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
              NSLog(@"error : %@", error.localizedDescription);
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
              [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
              [appDelegate.window makeToast:error.localizedDescription];
    }];
}

@end

