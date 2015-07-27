//
//  TWRCoreDataManager.m
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "AppDelegate.h"
#import "TWRCoreDataManager.h"
#import "TWRMedia+TWRHelper.h"
#import "TWRTweet+TWRHelper.h"
#import "TWRHashtag+TWRHelper.h"
#import "TWRPlace+TWRHelper.h"

#define MAIN_CONTEXT [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]

@implementation TWRCoreDataManager

+ (NSFetchedResultsController *)fetchedResultsControllerForTweetsFeed {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[TWRTweet entityName]];
    
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:[TWRTweet defaultSortDescriptor] ascending:NO]]];
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:MAIN_CONTEXT sectionNameKeyPath:nil cacheName:nil];
    
    return fetchedResultsController;
}

+ (BOOL)isAnySavedTweets {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[TWRTweet entityName]];
    [fetchRequest setFetchLimit:1];
    
    NSError *error = nil;
    NSArray *results = [MAIN_CONTEXT executeFetchRequest:fetchRequest error:&error];
    
    return (results.count > 0);
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

+ (TWRPlace *)insertNewPlaceInContext:(NSManagedObjectContext *)context {
    TWRPlace *place = [NSEntityDescription insertNewObjectForEntityForName:[TWRPlace entityName] inManagedObjectContext:context];
    return place;
}

+ (TWRMedia *)insertNewMediaInContext:(NSManagedObjectContext *)context {
    TWRMedia *media = [NSEntityDescription insertNewObjectForEntityForName:[TWRMedia entityName] inManagedObjectContext:context];
    return media;
}

+ (BOOL)isExistsTweetWithID:(NSString *)tweetID performInContext:(NSManagedObjectContext *)context {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[TWRTweet entityName]];
    
    request.predicate = [NSPredicate predicateWithFormat:@"%K = %@", [TWRTweet tweetIDParameter], tweetID];
    NSError *error = nil;
    
    NSArray *results = [context executeFetchRequest:request error:&error];
    return results.count;
}

+ (void)saveContext:(NSManagedObjectContext *)context {

    [context performBlockAndWait:^{
        NSError *error = nil;
        [context save:&error];
        if (error) {
            NSLog(@"Context saving error");
        }
    }];
}

@end
