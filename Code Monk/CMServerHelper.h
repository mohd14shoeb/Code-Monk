//
//  CMServerHelper.h
//  Code Monk
//
//  Created by yogesh singh on 19/11/15.
//  Copyright © 2015 yogesh singh. All rights reserved.
//

@import Foundation;

@interface CMServerHelper : NSObject 

+ (void)fetchAllTopics;

+ (void)fetchDetailsOfTopic:(NSNumber *)idValue;

+ (void)fetchExampleListsOfTopic:(NSNumber *)idValue;

+ (void)fetchDetailsOfExample:(NSNumber *)exampleID ofTopic:(NSNumber *)topicID;

@end
