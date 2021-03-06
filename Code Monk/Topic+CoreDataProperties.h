//
//  Topic+CoreDataProperties.h
//  Code Monk
//
//  Created by yogesh singh on 23/11/15.
//  Copyright © 2015 yogesh singh. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Topic.h"

NS_ASSUME_NONNULL_BEGIN

@interface Topic (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *category;
@property (nullable, nonatomic, retain) NSString *idValue;
@property (nullable, nonatomic, retain) NSNumber *isBookmarked;
@property (nullable, nonatomic, retain) NSString *link;
@property (nullable, nonatomic, retain) NSString *note;
@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *hasDetails;
@property (nullable, nonatomic, retain) NSSet<Example *> *examples;

@end

@interface Topic (CoreDataGeneratedAccessors)

- (void)addExamplesObject:(Example *)value;
- (void)removeExamplesObject:(Example *)value;
- (void)addExamples:(NSSet<Example *> *)values;
- (void)removeExamples:(NSSet<Example *> *)values;

@end

NS_ASSUME_NONNULL_END
