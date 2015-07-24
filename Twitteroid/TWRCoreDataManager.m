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
#import "TWRMedia+TWRHelper.h"
#import "TWRTweet+TWRHelper.h"
#import "TWRHashtag+TWRHelper.h"

#define MAIN_CONTEXT [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]

@implementation TWRCoreDataManager

+ (NSFetchedResultsController *)fetchedResultsControllerForTweetsFeed {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[TWRTweet entityName]];
    
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:[TWRTweet defaultSortDescriptor] ascending:YES]]];
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:MAIN_CONTEXT sectionNameKeyPath:nil cacheName:nil];
    
    return fetchedResultsController;
}

+ (NSManagedObjectContext *)mainContext {
    return MAIN_CONTEXT;
}

+ (TWRTweet *)insertNewTweetInContext:(NSManagedObjectContext *)context {
    TWRTweet *tweet = [NSEntityDescription insertNewObjectForEntityForName:[TWRTweet entityName] inManagedObjectContext:context];
    return tweet;
}

+ (TWRHashtag *)insertNewHashtagInContext:(NSManagedObjectContext *)context {
    TWRHashtag *hashtag = [NSEntityDescription insertNewObjectForEntityForName:[TWRHashtag entityName] inManagedObjectContext:context];
    return hashtag;
}

+ (TWRMedia *)insertNewMediaInContext:(NSManagedObjectContext *)context {
    TWRMedia *media = [NSEntityDescription insertNewObjectForEntityForName:[TWRMedia entityName] inManagedObjectContext:context];
    return media;
}


@end
