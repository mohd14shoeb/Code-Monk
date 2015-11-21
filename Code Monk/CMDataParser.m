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
    }
    else if (fetchedArr.count == 1){    //topic matched, update topic details from the response
        
        topicToUpdate = [fetchedArr firstObject];

        if(![topicToUpdate.link isEqualToString:[response valueForKey:@"browser_link"]]) [topicToUpdate setLink:[response valueForKey:@"browser_link"]];
        if(![topicToUpdate.note isEqualToString:[response valueForKey:@"note"]]) [topicToUpdate setNote:[response valueForKey:@"note"]];
    }
    else{   //should never goto else block, indicates invalid response received
        //ignore for now
    }
    
//    if ([appDelegate.managedObjectContext hasChanges]) {
//
//        NSError *saveErr = nil;
//        if ([appDelegate.managedObjectContext save:&saveErr]) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:UPDATED_TOPIC_DETAILS object:nil userInfo:@{@"topicObject":topicToUpdate}];
//        }
//        else{
//            NSLog(@"CMDataParser parseTopicDetailsInResponse save error : %@", saveErr.localizedDescription);
//        }
//    }
}

@end
