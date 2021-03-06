//
//  CMAppDelegate.h
//  Code Monk
//
//  Created by yogesh singh on 18/11/15.
//  Copyright © 2015 yogesh singh. All rights reserved.
//

@import UIKit;
@import CoreData;
@import QuartzCore;

@interface CMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

