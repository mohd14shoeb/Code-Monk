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

#define FONT_LRG [UIFont fontWithName:@"Futura-Medium" size:24]

#define CUSTOM_BLUE_COLOR [UIColor colorWithRed:89.0/255.0 green:159.0/255.0 blue:227.0/255.0 alpha:1.0]

#define RGB(r, g, b) [UIColor colorWithRed:(float)r / 255.0 green:(float)g / 255.0 blue:(float)b / 255.0 alpha:1.0]

#define NAVBAR_HEIGHT (self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height)

#define TOPICSLIST @"https://api.hackerearth.com/codemonk/v1/topics-list/"

#define TOPICDETAILS @"https://api.hackerearth.com/codemonk/v1/topic-detail/"

#define TOPIC @"Topic"

#define UPDATED_ALL_TOPICS @"UPDATED_ALL_TOPICS"

+ (UIColor *)getAverageColorFromImage:(UIImage *)image;

@end
