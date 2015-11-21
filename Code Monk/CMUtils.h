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

#pragma mark - UI Standards

#define appIcon             [UIImage imageNamed:@"appIcon"]

#define FONT_MED            [UIFont fontWithName:@"Futura-Medium" size:14]

#define FONT_LRG            [UIFont fontWithName:@"Futura-Medium" size:24]

#define CUSTOM_BLUE_COLOR   [UIColor colorWithRed:89.0/255.0 green:159.0/255.0 blue:227.0/255.0 alpha:1.0]

#define RGB(r, g, b)        [UIColor colorWithRed:(float)r / 255.0 green:(float)g / 255.0 blue:(float)b / 255.0 alpha:1.0]

#define NAVBAR_HEIGHT       (self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height)


#pragma mark - API Standards

#define TOPICSLIST      @"https://api.hackerearth.com/codemonk/v1/topics-list/"

#define TOPIC_DETAILS   @"https://api.hackerearth.com/codemonk/v1/topic-detail/"

#define EXAMPLES_LIST   @"https://api.hackerearth.com/codemonk/v1/examples-list/"

#define EXAMPLE_DETAIL  @"https://api.hackerearth.com/codemonk/v1/example-detail/"


#pragma mark - Constants

#define TOPIC                   @"Topic"

#define UPDATED_ALL_TOPICS      @"UPDATED_ALL_TOPICS"

#define UPDATED_TOPIC_DETAILS   @"UPDATED_TOPIC_DETAILS"


#pragma mark - Helper Functions

/**
    Returns the average color of the image calculated over a 1x1 bit pixel
*/
+ (UIColor *)getAverageColorFromImage:(UIImage *)image;

@end
