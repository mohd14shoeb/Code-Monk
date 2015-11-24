//
//  CMExampleDetailsVC.h
//  Code Monk
//
//  Created by yogesh singh on 23/11/15.
//  Copyright © 2015 yogesh singh. All rights reserved.
//

@import UIKit;

@class Topic;
@class Example;

@interface CMExampleDetailsVC : UIViewController

@property (nonatomic, strong) Topic *topicObj;
@property (nonatomic, strong) Example *exampleObj;

@end
