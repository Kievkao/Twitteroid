//
//  TWRCoreDataManager.m
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "TWRCoreDataManager.h"
#import "TWRTweet+TWRHelper.h"

#define MAIN_CONTEXT [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]

@implementation TWRCoreDataManager

+ (NSFetchedResultsController *)fetchedResultsControllerForTweetsFeed {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[TWRTweet entityName]];
    
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:[TWRTweet defaultSortDescriptor] ascending:YES]]];
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:MAIN_CONTEXT sectionNameKeyPath:nil cacheName:nil];
    
    return fetchedResultsController;
}

@end
