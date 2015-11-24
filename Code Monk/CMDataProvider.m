//
//  CMDataProvider.m
//  Code Monk
//
//  Created by yogesh singh on 19/11/15.
//  Copyright © 2015 yogesh singh. All rights reserved.
//

#import "CMDataProvider.h"
#import "CMUtils.h"

@implementation CMDataProvider

+ (NSArray *)getAllTopicsByFilter:(NSString *)searchText{
    
    CMAppDelegate *appDelegate = (CMAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:TOPIC];
    
    if (searchText) {
        NSPredicate *titlePredicate = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@", searchText];
        NSPredicate *categPredicate = [NSPredicate predicateWithFormat:@"category CONTAINS[cd] %@", searchText];
        NSCompoundPredicate *pred = [NSCompoundPredicate orPredicateWithSubpredicates:@[titlePredicate, categPredicate]];
        [request setPredicate:pred];
    }
    
    NSError *fetchErr = nil;
    NSArray *fetchedTopics = [appDelegate.managedObjectContext executeFetchRequest:request error:&fetchErr];
    
    if (fetchErr) {
        NSLog(@"CMDataProvider getAllTopicsByFilter:%@ fetchErr : %@", searchText, fetchErr.localizedDescription);
    }
    
    return fetchedTopics;
}

+ (NSArray *)getAllCategoriesByFilter:(NSString *)searchText{
    
    CMAppDelegate *appDelegate = (CMAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:TOPIC];
    
    if (searchText) {
        NSPredicate *categPredicate = [NSPredicate predicateWithFormat:@"category CONTAINS[cd] %@", searchText];
        [request setPredicate:categPredicate];
    }
    
    [request setResultType:NSDictionaryResultType];
    [request setPropertiesToFetch:[NSArray arrayWithObject:@"category"]];
    
    NSError *fetchErr = nil;
    NSArray *fetchedCategories = [appDelegate.managedObjectContext executeFetchRequest:request error:&fetchErr];
    
    if (fetchErr) {
        NSLog(@"CMDataProvider getAllCategoriesByFilter:%@ fetchErr : %@", searchText, fetchErr.localizedDescription);
    }
    
    NSMutableArray *uniqueCategories = [NSMutableArray array];
    
    for (NSDictionary *category in fetchedCategories) {
        if (![uniqueCategories containsObject:[category valueForKey:@"category"]]) {
            [uniqueCategories addObject:[category valueForKey:@"category"]];
        }
    }
    
    uniqueCategories = [[uniqueCategories sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] mutableCopy];
    
    [uniqueCategories insertObject:@"All Topics" atIndex:0];
    
    return [uniqueCategories copy];
}

+ (NSArray *)getAllBookmarkedTopics{
    
    CMAppDelegate *appDelegate = (CMAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:TOPIC];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isBookmarked == %@", [NSNumber numberWithBool:YES]];
    
    [request setPredicate:predicate];
    
    NSError *fetchErr = nil;
    NSArray *fetchedTopics = [appDelegate.managedObjectContext executeFetchRequest:request error:&fetchErr];
    
    if (fetchErr) {
        NSLog(@"CMDataProvider getAllBookmarkedTopics: fetchErr : %@", fetchErr.localizedDescription);
    }
    
    return fetchedTopics;
}

+ (NSArray *)getAllBookmarkedExamples{
    
    CMAppDelegate *appDelegate = (CMAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:EXAMPLE];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isBookmarked == %@", [NSNumber numberWithBool:YES]];
    
    [request setPredicate:predicate];
    
    NSError *fetchErr = nil;
    NSArray *fetchedExamples = [appDelegate.managedObjectContext executeFetchRequest:request error:&fetchErr];
    
    if (fetchErr) {
        NSLog(@"CMDataProvider getAllBookmarkedExamples: fetchErr : %@", fetchErr.localizedDescription);
    }
    
    return fetchedExamples;
}

@end
