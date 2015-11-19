//
//  CMDataProvider.h
//  Code Monk
//
//  Created by yogesh singh on 19/11/15.
//  Copyright © 2015 yogesh singh. All rights reserved.
//

@import Foundation;

@interface CMDataProvider : NSObject

+ (NSArray *)getAllTopicsByFilter:(NSString *)searchText;

+ (NSArray *)getAllCategoriesByFilter:(NSString *)searchText;

@end
