//
//  CMDataParser.h
//  Code Monk
//
//  Created by yogesh singh on 19/11/15.
//  Copyright © 2015 yogesh singh. All rights reserved.
//

@import Foundation;

@interface CMDataParser : NSObject

+ (void)parseAllTopicsInResponse:(id)response;

+ (void)parseTopicDetailsInResponse:(id)response;

@end
