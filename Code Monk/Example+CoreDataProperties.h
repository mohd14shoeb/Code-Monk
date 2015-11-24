//
//  Example+CoreDataProperties.h
//  Code Monk
//
//  Created by yogesh singh on 23/11/15.
//  Copyright © 2015 yogesh singh. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Example.h"

NS_ASSUME_NONNULL_BEGIN

@interface Example (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *idValue;
@property (nullable, nonatomic, retain) NSString *input;
@property (nullable, nonatomic, retain) NSString *link;
@property (nullable, nonatomic, retain) NSString *output;
@property (nullable, nonatomic, retain) NSString *solution;
@property (nullable, nonatomic, retain) NSString *statement;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *hasDetails;
@property (nullable, nonatomic, retain) NSNumber *isBookmarked;
@property (nullable, nonatomic, retain) Topic *exampleOfTopic;

@end

NS_ASSUME_NONNULL_END
