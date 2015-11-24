//
//  CMDataParser.m
//  Code Monk
//
//  Created by yogesh singh on 19/11/15.
//  Copyright © 2015 yogesh singh. All rights reserved.
//

#import "CMDataParser.h"
#import "CMUtils.h"

@implementation CMDataParser

+ (void)setTopic:(Topic *)topic fromResponse:(NSDictionary *)response{
    
    if(![topic.title    isEqualToString:[response valueForKey:@"title"]])    [topic setTitle     :[response valueForKey:@"title"]];
    if(![topic.text     isEqualToString:[response valueForKey:@"text"]])     [topic setText      :[response valueForKey:@"text"]];
    if(![topic.category isEqualToString:[response valueForKey:@"category"]]) [topic setCategory  :[response valueForKey:@"category"]];
}

+ (void)parseAllTopicsInResponse:(id)response{
    
    CMAppDelegate *appDelegate = (CMAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSArray *allTopics = [response valueForKey:@"topics"];
    
    for (NSDictionary *topic in allTopics) {
        
        NSString *idValue = [[topic valueForKey:@"id"] stringValue];
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:TOPIC];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idValue == %@",idValue];
        
        [request setPredicate:predicate];
        
        NSError *fetchErr = nil;
        NSArray *fetchedArr = [appDelegate.managedObjectContext executeFetchRequest:request error:&fetchErr];
        
        if (fetchErr) {
             NSLog(@"CMDataParser parseAllTopicsInResponse: fetchErr : %@", fetchErr.localizedDescription);
        }
        
        if (fetchedArr.count == 0) {    //create new topic
            
            Topic *newTopic = [NSEntityDescription insertNewObjectForEntityForName:TOPIC inManagedObjectContext:appDelegate.managedObjectContext];
            
            [newTopic setIdValue:idValue];
            [newTopic setHasDetails:[NSNumber numberWithBool:NO]];
            
            [self setTopic:newTopic fromResponse:topic];
        }
        else if(fetchedArr.count == 1){ //update existing topic
            
            Topic *existingTopic = [fetchedArr firstObject];
            
            [self setTopic:existingTopic fromResponse:topic];
        }
        else{
            NSLog(@"duplicate topic id's received, fetchedArr.count(= %lu) in CMDataParser parseAllTopicsInResponse:, will ignore for now", (unsigned long)fetchedArr.count);
        }
        
        if ([appDelegate.managedObjectContext hasChanges]) {
            
            NSError *saveErr = nil;
            if ([appDelegate.managedObjectContext save:&saveErr]) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:UPDATED_ALL_TOPICS object:nil];
            }
            else{
                NSLog(@"CMDataParser parseAllTopicsInResponse: saveErr : %@", saveErr.localizedDescription);
            }
        }
    }
}

+ (void)parseTopicDetailsInResponse:(id)response{
    
    CMAppDelegate *appDelegate = (CMAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *idValue = [[response valueForKey:@"id"] stringValue];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:TOPIC];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idValue == %@",idValue];
    
    [request setPredicate:predicate];
    
    NSError *fetchErr = nil;
    NSArray *fetchedArr = [appDelegate.managedObjectContext executeFetchRequest:request error:&fetchErr];
    
    if (fetchErr) {
        NSLog(@"CMDataParser parseAllTopicsInResponse: fetchErr : %@", fetchErr.localizedDescription);
    }
    
    Topic *topicToUpdate = nil;
    
    if (fetchedArr.count == 0){ //count cannot be zero, selected topic has to exist at this point in execution
        //ignore for now
        NSLog(@"CMDataParser parseAllTopicsInResponse: fetchErr.count : %lu | contents : %@",(unsigned long)fetchedArr.count, fetchedArr);
    }
    else if (fetchedArr.count == 1){    //topic matched, update topic details from the response
        
        topicToUpdate = [fetchedArr firstObject];
        
        if (![topicToUpdate.hasDetails boolValue]) {
            
            [topicToUpdate setNote:[response valueForKey:@"note"]];
            
            [topicToUpdate setLink:[response valueForKey:@"browser_link"]];
            
            topicToUpdate.hasDetails = [NSNumber numberWithBool:YES];
        }
    }
    else{   //should never goto else block, indicates invalid response received
        //ignore for now
        NSLog(@"CMDataParser parseAllTopicsInResponse: fetchErr.count : %lu | contents : %@",(unsigned long)fetchedArr.count, fetchedArr);
    }
    
    if ([appDelegate.managedObjectContext hasChanges]) {

        NSError *saveErr = nil;
        if ([appDelegate.managedObjectContext save:&saveErr]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:UPDATED_TOPIC_DETAILS
                                                                object:nil userInfo:@{@"topicObject":topicToUpdate}];
        }
        else{
            NSLog(@"CMDataParser parseTopicDetailsInResponse save error : %@", saveErr.localizedDescription);
        }
    }
    else{
        //already exists
        [[NSNotificationCenter defaultCenter] postNotificationName:UPDATED_TOPIC_DETAILS
                                                            object:nil userInfo:@{@"topicObject":topicToUpdate}];
    }
}

+ (void)parseExamplesInResponse:(id)response forTopic:(NSNumber *)topicID{
    
    CMAppDelegate *appDelegate = (CMAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *topicFetch = [NSFetchRequest fetchRequestWithEntityName:TOPIC];
    
    NSPredicate *topicPred = [NSPredicate predicateWithFormat:@"idValue == %@",[topicID stringValue]];
    
    [topicFetch setPredicate:topicPred];
    
    NSError *topicFetchErr = nil;
    NSArray *fetchedTopicsArr = [appDelegate.managedObjectContext executeFetchRequest:topicFetch error:&topicFetchErr];
    
    if (topicFetchErr) {
        NSLog(@"CMDataParser parseExamplesInResponse: fetchedTopicsArr : %@", topicFetchErr.localizedDescription);
    }
    
    Topic *topic = nil;
    
    if (fetchedTopicsArr.count == 1) {
        topic = [fetchedTopicsArr firstObject];
    }
    else{   //fetched topics array is always expected to be one here
        //ignore for now
        NSLog(@"CMDataParser parseExamplesInResponse: topicFetchErr : %@", topicFetchErr.localizedDescription);
    }
    
    NSArray *examples = [response valueForKey:@"examples"];
    
    for (NSDictionary *exampleDict in examples) {
        
        NSString *idValue = [[exampleDict valueForKey:@"id"] stringValue];
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:EXAMPLE];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idValue == %@",idValue];
        
        [request setPredicate:predicate];
        
        NSError *examplefetchErr = nil;
        NSArray *fetchedExamplesArr = [appDelegate.managedObjectContext executeFetchRequest:request error:&examplefetchErr];
        
        if (examplefetchErr) {
            NSLog(@"CMDataParser parseExamplesInResponse: examplefetchErr : %@", examplefetchErr.localizedDescription);
        }

        Example *example = nil;
        
        if (fetchedExamplesArr.count == 0){     //create new example
            
            example = [NSEntityDescription insertNewObjectForEntityForName:EXAMPLE
                                                    inManagedObjectContext:appDelegate.managedObjectContext];

            example.idValue        = idValue;
            example.title          = [exampleDict valueForKey:@"title"];
            example.exampleOfTopic = topic;
        }
        else{
            //ignore example list updation for now
        }
        
    }
    
    if ([appDelegate.managedObjectContext hasChanges]) {
        
        NSError *saveErr = nil;
        if ([appDelegate.managedObjectContext save:&saveErr]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:UPDATED_EXAMPLES_LIST object:nil userInfo:@{@"topicObject":topic}];
        }
        else{
            NSLog(@"CMDataParser parseExamplesInResponse save error : %@", saveErr.localizedDescription);
        }
    }
    else{
        //example list already exists
        [[NSNotificationCenter defaultCenter] postNotificationName:UPDATED_EXAMPLES_LIST object:nil userInfo:@{@"topicObject":topic}];
    }
}

+ (void)parseExampleDetailsInResponse:(id)response forTopic:(NSNumber *)topicID{

    CMAppDelegate *appDelegate = (CMAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *topicRequest = [NSFetchRequest fetchRequestWithEntityName:TOPIC];
    
    NSPredicate *topicPred = [NSPredicate predicateWithFormat:@"idValue == %@",[topicID stringValue]];
    
    [topicRequest setPredicate:topicPred];
    
    NSError *topicFetchErr = nil;
    NSArray *fetchedTopicsArr = [appDelegate.managedObjectContext executeFetchRequest:topicRequest error:&topicFetchErr];
    
    if (topicFetchErr) {
        NSLog(@"CMDataParser parseExampleDetailsInResponse: topicFetchErr : %@", topicFetchErr.localizedDescription);
    }
    
    Topic *topic = nil;
    
    if (fetchedTopicsArr.count == 1) {
        topic = [fetchedTopicsArr firstObject];
    }
    else{   //fetchedTopicsArr is expected to be exactly one here
        //ignore for now
        NSLog(@"CMDataParser parseExampleDetailsInResponse: topicFetchErr : %@", topicFetchErr.localizedDescription);
    }
    
    NSString *idValue = [response valueForKey:@"id"];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:EXAMPLE];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idValue == %@",idValue];
    
    [request setPredicate:predicate];
    
    NSError *examplefetchErr = nil;
    NSArray *fetchedExamplesArr = [appDelegate.managedObjectContext executeFetchRequest:request error:&examplefetchErr];
    
    if (examplefetchErr) {
        NSLog(@"CMDataParser parseExamplesInResponse: examplefetchErr : %@", examplefetchErr.localizedDescription);
    }
    
    Example *example = nil;
    
    if (fetchedExamplesArr.count == 1) {
        
        example = [fetchedExamplesArr firstObject];
        
        if (![example.hasDetails boolValue]) {

            example.statement   = [response valueForKey:@"statement"];
            example.solution    = [response valueForKey:@"solution"];
            example.link        = [response valueForKey:@"browser_link"];
            example.input       = [response valueForKey:@"sample_input"];
            example.output      = [response valueForKey:@"sample_output"];
            example.hasDetails  = [NSNumber numberWithBool:YES];
        }
    }
    else{   //fetchedExamplesArr is expected to be exactly one here
        //ignore for now
        NSLog(@"CMDataParser parseExampleDetailsInResponse: fetchedExamplesArr : %@", fetchedExamplesArr);
    }
    
    if ([appDelegate.managedObjectContext hasChanges]) {

        NSError *saveErr = nil;
        if ([appDelegate.managedObjectContext save:&saveErr]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:UPDATED_EXAMPLE_DETAILS
                                                                object:nil userInfo:@{@"topicObject":topic, @"exampleObject":example}];
        }
        else{
            NSLog(@"CMDataParser parseExampleDetailsInResponse: saveErr : %@", saveErr.localizedDescription);
        }
    }
    else{   //example details already exist
        [[NSNotificationCenter defaultCenter] postNotificationName:UPDATED_EXAMPLE_DETAILS
                                                            object:nil userInfo:@{@"topicObject":topic, @"examplObject":example}];
    }
}

+ (void)toggleBookmarkOfTopic:(NSNumber *)topicID{
    
    CMAppDelegate *appDelegate = (CMAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *topicRequest = [NSFetchRequest fetchRequestWithEntityName:TOPIC];
    
    NSPredicate *topicPred = [NSPredicate predicateWithFormat:@"idValue == %@",[topicID stringValue]];
    
    [topicRequest setPredicate:topicPred];
    
    NSError *topicFetchErr = nil;
    NSArray *fetchedTopicsArr = [appDelegate.managedObjectContext executeFetchRequest:topicRequest error:&topicFetchErr];
    
    if (topicFetchErr) {
        NSLog(@"CMDataParser parseExampleDetailsInResponse: topicFetchErr : %@", topicFetchErr.localizedDescription);
    }
    
    Topic *topic = nil;
    
    if (fetchedTopicsArr.count == 1) {
        topic = [fetchedTopicsArr firstObject];
    }
    else{   //fetchedTopicsArr is expected to be exactly one here
        //ignore for now
        NSLog(@"CMDataParser toggleBookmarkOfTopic: fetchedTopicsArr : %@", fetchedTopicsArr);
    }
    
    topic.isBookmarked = [NSNumber numberWithBool:(![topic.isBookmarked boolValue])];

    NSError *saveErr = nil;
    if ([appDelegate.managedObjectContext save:&saveErr]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:BOOKMARK_TOGGLED
                                                            object:nil userInfo:@{@"topicObject":topic}];
    }
    else{
        NSLog(@"CMDataParser toggleBookmarkOfTopic: saveErr : %@", saveErr.localizedDescription);
    }
}

+ (void)toggleBookmarkOfExample:(NSNumber *)exampleID forTopic:(NSNumber *)topicID{
    
    CMAppDelegate *appDelegate = (CMAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *topicRequest = [NSFetchRequest fetchRequestWithEntityName:TOPIC];
    
    NSPredicate *topicPred = [NSPredicate predicateWithFormat:@"idValue == %@",[topicID stringValue]];
    
    [topicRequest setPredicate:topicPred];
    
    NSError *topicFetchErr = nil;
    NSArray *fetchedTopicsArr = [appDelegate.managedObjectContext executeFetchRequest:topicRequest error:&topicFetchErr];
    
    if (topicFetchErr) {
        NSLog(@"CMDataParser parseExampleDetailsInResponse: topicFetchErr : %@", topicFetchErr.localizedDescription);
    }
    
    Topic *topic = nil;
    
    if (fetchedTopicsArr.count == 1) {
        topic = [fetchedTopicsArr firstObject];
    }
    else{   //fetchedTopicsArr is expected to be exactly one here
        //ignore for now
        NSLog(@"CMDataParser toggleBookmarkOfExample: fetchedTopicsArr : %@", fetchedTopicsArr);
    }
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:EXAMPLE];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"idValue == %@",[exampleID stringValue]];
    
    [request setPredicate:pred];
    
    NSError *fetchErr = nil;
    NSArray *fetchedArr = [appDelegate.managedObjectContext executeFetchRequest:request error:&fetchErr];
    
    if (fetchErr) {
        NSLog(@"CMDataParser toggleBookmarkOfExample: fetchErr : %@", fetchErr.localizedDescription);
    }
    
    Example *example = nil;
    
    if (fetchedArr.count == 1) {
        example = [fetchedArr firstObject];
    }
    else{   //fetchedArr is expected to be exactly one here
        //ignore for now
        NSLog(@"CMDataParser toggleBookmarkOfExample: fetchedArr : %@", fetchedArr);
    }
    
    example.isBookmarked = [NSNumber numberWithBool:(![example.isBookmarked boolValue])];
    example.exampleOfTopic = topic;
    
    NSError *saveErr = nil;
    if ([appDelegate.managedObjectContext save:&saveErr]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:BOOKMARK_TOGGLED
                                                            object:nil userInfo:@{@"exampleObject":example}];
    }
    else{
        NSLog(@"CMDataParser toggleBookmarkOfExample: saveErr : %@", saveErr.localizedDescription);
    }
}

@end
