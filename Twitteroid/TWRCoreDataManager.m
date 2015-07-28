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
#import "NSDate+Escort.h"

static NSString *const kTweetsDeleteDateKey = @"TWRTweetsDeleteDateKey";

#define MAIN_CONTEXT [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]

@interface TWRCoreDataManager()

@property (nonatomic, strong) NSDate *dateForOlderDeleting;

@end

@implementation TWRCoreDataManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

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

+ (TWRTweet *)insertNewTweet {
    TWRTweet *tweet = [NSEntityDescription insertNewObjectForEntityForName:[TWRTweet entityName] inManagedObjectContext:[self mainContext]];
    return tweet;
}

+ (TWRHashtag *)insertNewHashtag {
    TWRHashtag *hashtag = [NSEntityDescription insertNewObjectForEntityForName:[TWRHashtag entityName] inManagedObjectContext:[self mainContext]];
    return hashtag;
}

+ (TWRPlace *)insertNewPlace {
    TWRPlace *place = [NSEntityDescription insertNewObjectForEntityForName:[TWRPlace entityName] inManagedObjectContext:[self mainContext]];
    return place;
}

+ (TWRMedia *)insertNewMedia {
    TWRMedia *media = [NSEntityDescription insertNewObjectForEntityForName:[TWRMedia entityName] inManagedObjectContext:[self mainContext]];
    return media;
}

+ (BOOL)isExistsTweetWithID:(NSString *)tweetID {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[TWRTweet entityName]];
    
    request.predicate = [NSPredicate predicateWithFormat:@"%K = %@", [TWRTweet tweetIDParameter], tweetID];
    NSError *error = nil;
    
    NSArray *results = [[self mainContext] executeFetchRequest:request error:&error];
    return results.count;
}

- (NSDate *)savedAutomaticTweetsDeleteDate {
    return self.dateForOlderDeleting;
}

- (void)saveAutomaticTweetsDeleteDate:(NSDate *)date {
    
    self.dateForOlderDeleting = date;
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:kTweetsDeleteDateKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isTweetDateIsAllowed:(NSDate *)date {
    
    if (self.dateForOlderDeleting && [date isEarlierThanDate:self.dateForOlderDeleting]) {
        return NO;
    }
    else {
        return YES;
    }
}

+ (void)deleteTweetsOlderThanDate:(NSDate *)date {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[TWRTweet entityName]];
    
    request.predicate = [NSPredicate predicateWithFormat:@"createdAt < %@", date];
    NSError *error = nil;
    
    NSArray *results = [[self mainContext] executeFetchRequest:request error:&error];
    
    for (TWRTweet *tweet in results) {
        [[self mainContext] deleteObject:tweet];
    }
    
    [self saveContext];
}

+ (void)saveContext {

    NSError *error = nil;
    [[self mainContext] save:&error];
    if (error) {
        NSLog(@"Context saving error");
    }
}

- (NSDate *)dateForOlderDeleting {
    
    if (!_dateForOlderDeleting) {
        _dateForOlderDeleting = [[NSUserDefaults standardUserDefaults] objectForKey:kTweetsDeleteDateKey];
    }
    
    return _dateForOlderDeleting;
}

@end
