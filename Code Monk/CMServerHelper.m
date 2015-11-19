//
//  CMServerHelper.m
//  Code Monk
//
//  Created by yogesh singh on 19/11/15.
//  Copyright © 2015 yogesh singh. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#import "CMServerHelper.h"
#import "CMDataParser.h"
#import "CMUtils.h"

@implementation CMServerHelper

+ (void)fetchAllTopics{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [manager GET:TOPICSLIST parameters:nil
         success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
      
        //NSLog(@"CMServerHelper success responseObject : %@", responseObject);
        
        [CMDataParser parseAllTopicsInResponse:responseObject];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        NSLog(@"CMServerHelper fetchAllTopics error : %@", error.localizedDescription);
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

@end
