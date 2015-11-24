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
#import "Example+CoreDataProperties.h"

@interface CMUtils : NSObject

#pragma mark - UI Standards

#define appIcon             [UIImage imageNamed:@"appIcon"]

#define FONT_MED            [UIFont fontWithName:@"Futura-Medium" size:14]

#define FONT_LRG            [UIFont fontWithName:@"Futura-Medium" size:22]

#define CUSTOM_BLUE_COLOR   [UIColor colorWithRed:89.0/255.0 green:159.0/255.0 blue:227.0/255.0 alpha:1.0]

#define RGB(r, g, b)        [UIColor colorWithRed:(float)r / 255.0 green:(float)g / 255.0 blue:(float)b / 255.0 alpha:1.0]

#define NAVBAR_HEIGHT       (self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height)


#pragma mark - API Standards

#define TOPICSLIST      @"https://api.hackerearth.com/codemonk/v1/topics-list/"

#define TOPIC_DETAILS   @"https://api.hackerearth.com/codemonk/v1/topic-detail/"

#define EXAMPLES_LIST   @"https://api.hackerearth.com/codemonk/v1/examples-list/"

#define EXAMPLE_DETAIL  @"https://api.hackerearth.com/codemonk/v1/example-detail/"

#define LINK_TO_SHARE   @"Code Monk Android App by HackerEarth - Hey I use Code Monk to improve my concepts of programming. You should try it too. Download the app by clicking on this link https://play.google.com/store/apps/details?id=com.hackerearth.codemonk"


#pragma mark - Constants

#define TOPIC                   @"Topic"
#define EXAMPLE                 @"Example"

#define UPDATED_ALL_TOPICS      @"UPDATED_ALL_TOPICS"

#define UPDATED_TOPIC_DETAILS   @"UPDATED_TOPIC_DETAILS"

#define UPDATED_EXAMPLES_LIST   @"UPDATED_EXAMPLES_LIST"

#define UPDATED_EXAMPLE_DETAILS @"UPDATED_EXAMPLE_DETAILS"

#define BOOKMARK_TOGGLED        @"BOOKMARK_TOGGLED"

#pragma mark - Helper Functions

/**
    Returns the average color of the image calculated over a 1x1 bit pixel
*/
+ (UIColor *)getAverageColorFromImage:(UIImage *)image;

@end
