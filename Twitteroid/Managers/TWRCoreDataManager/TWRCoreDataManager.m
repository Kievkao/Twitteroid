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

@interface TWRCoreDataManager()

@property (nonatomic, strong) NSDate *dateForOlderDeleting;
@property (nonatomic, strong) NSManagedObjectContext *mainContext;

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

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setupStack];
    }
    return self;
}

// TODO: add child private context
- (void)setupStack {
    
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Twitteroid" withExtension:@"momd"]];
    if (!model) {
        abort();
    }
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    if (!persistentStoreCoordinator) {
        abort();
    }
    
    self.mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.mainContext.persistentStoreCoordinator = persistentStoreCoordinator;
    
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    if (!documentsURL) {
        abort();
    }
    
    NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"Twitteroid.sqlite"];
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption : @YES, NSInferMappingModelAutomaticallyOption : @YES, NSSQLitePragmasOption : @{@"journal_mode": @"DELETE"}};
    
    NSError *error = nil;
    [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error];
    if (error) {
        abort();
    }
}

// TODO: rework to generics
- (NSFetchedResultsController *)fetchedResultsControllerForTweetsHashtag:(NSString *)hashtag {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[TWRTweet entityName]];
    
    if (hashtag) {
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K = %@", [TWRTweet tweetHashtagParameter], hashtag];
    }
    else {
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K = nil", [TWRTweet tweetHashtagParameter]];
    }
    
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:[TWRTweet defaultSortDescriptor] ascending:NO]]];
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.mainContext sectionNameKeyPath:nil cacheName:nil];
    
    return fetchedResultsController;
}

// TODO: replace fetch to getting only count of elements
- (BOOL)isAnySavedTweetsForHashtag:(NSString *)hashtag {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[TWRTweet entityName]];
    [fetchRequest setFetchLimit:1];
    
    if (hashtag) {
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K = %@", [TWRTweet tweetHashtagParameter], hashtag];
    }
    else {
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K = nil", [TWRTweet tweetHashtagParameter]];
    }
    
    NSError *error = nil;
    NSArray *results = [self.mainContext executeFetchRequest:fetchRequest error:&error];
    
    return (results.count > 0);
}

// TODO: rework to some similar to objc-CoreData methodic or to generics
- (TWRTweet *)insertNewTweet {
    TWRTweet *tweet = [NSEntityDescription insertNewObjectForEntityForName:[TWRTweet entityName] inManagedObjectContext:[self mainContext]];
    return tweet;
}

- (TWRHashtag *)insertNewHashtag {
    TWRHashtag *hashtag = [NSEntityDescription insertNewObjectForEntityForName:[TWRHashtag entityName] inManagedObjectContext:[self mainContext]];
    return hashtag;
}

- (TWRPlace *)insertNewPlace {
    TWRPlace *place = [NSEntityDescription insertNewObjectForEntityForName:[TWRPlace entityName] inManagedObjectContext:[self mainContext]];
    return place;
}

- (TWRMedia *)insertNewMedia {
    TWRMedia *media = [NSEntityDescription insertNewObjectForEntityForName:[TWRMedia entityName] inManagedObjectContext:[self mainContext]];
    return media;
}

// TODO: replace fetch to getting only count of elements
- (BOOL)isExistsTweetWithID:(NSString *)tweetID forHashtag:(NSString *)hashtag {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[TWRTweet entityName]];
    
    if (hashtag) {
        request.predicate = [NSPredicate predicateWithFormat:@"%K = %@", [TWRTweet tweetHashtagParameter], hashtag];
    }
    else {
        request.predicate = [NSPredicate predicateWithFormat:@"%K = nil", [TWRTweet tweetHashtagParameter]];
    }
    
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

- (void)deleteTweetsOlderThanDate:(NSDate *)date {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[TWRTweet entityName]];
    
    request.predicate = [NSPredicate predicateWithFormat:@"createdAt < %@", date];
    NSError *error = nil;
    
    NSArray *results = [[self mainContext] executeFetchRequest:request error:&error];
    
    for (TWRTweet *tweet in results) {
        [[self mainContext] deleteObject:tweet];
    }
    
    [self saveContext];
}

- (void)saveContext {

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
