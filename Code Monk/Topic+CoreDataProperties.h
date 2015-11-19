//
//  Topic+CoreDataProperties.h
//  Code Monk
//
//  Created by yogesh singh on 19/11/15.
//  Copyright © 2015 yogesh singh. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Topic.h"

NS_ASSUME_NONNULL_BEGIN

@interface Topic (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *idValue;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) NSString *category;

@end

NS_ASSUME_NONNULL_END
