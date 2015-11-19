//
//  CMUtils.h
//  Code Monk
//
//  Created by yogesh singh on 19/11/15.
//  Copyright © 2015 yogesh singh. All rights reserved.
//

@import Foundation;
@import UIKit;

#import "CMAppDelegate.h"
#import "Topic+CoreDataProperties.h"

@interface CMUtils : NSObject

#define appIcon [UIImage imageNamed:@"appIcon"]

#define FONT_MED [UIFont fontWithName:@"Futura-Medium" size:14]

#define FONT_LRG [UIFont fontWithName:@"Futura-Medium" size:18]

#define RGB(r, g, b) [UIColor colorWithRed:(float)r / 255.0 green:(float)g / 255.0 blue:(float)b / 255.0 alpha:1.0]

#define TOPICSLIST @"https://api.hackerearth.com/codemonk/v1/topics-list/"

#define TOPIC @"Topic"

#define UPDATED_ALL_TOPICS @"UPDATED_ALL_TOPICS"

+ (UIColor *)getAverageColorFromImage:(UIImage *)image;

@end
