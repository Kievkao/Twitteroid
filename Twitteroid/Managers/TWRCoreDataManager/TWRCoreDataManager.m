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
@property (nonatomic, strong) NSManagedObjectContext *privateContext;

@end

@implementation TWRCoreDataManager

+ (instancetype)sharedInstance {
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
    
    self.privateContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    self.privateContext.persistentStoreCoordinator = persistentStoreCoordinator;
    
    self.mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.mainContext.parentContext = self.privateContext;
    
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

- (nullable NSFetchedResultsController *)fetchedResultsControllerForTweetsHashtag:(nullable NSString *)hashtag {
    
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

- (BOOL)isAnySavedTweetsForHashtag:(nullable NSString *)hashtag {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[TWRTweet entityName]];
    [fetchRequest setFetchLimit:1];
    
    if (hashtag) {
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K = %@", [TWRTweet tweetHashtagParameter], hashtag];
    }
    else {
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K = nil", [TWRTweet tweetHashtagParameter]];
    }
    
    __block NSUInteger count = 0;
    
    [self.mainContext performBlockAndWait:^{
        count = [self.mainContext countForFetchRequest:fetchRequest error:nil];
    }];
    
    return count > 0;
}

- (nullable NSManagedObject *)insertNewEntity:(nonnull Class)entityClass {
    
    if ([entityClass isSubclassOfClass:[NSManagedObject class]]) {
        NSString *entityName = [entityClass entityName];
        return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.mainContext];
    }
    else {
        return nil;
    }
}

- (BOOL)isExistsTweetWithID:(nonnull NSString *)tweetID forHashtag:(nullable NSString *)hashtag {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[TWRTweet entityName]];
    
    NSPredicate *tweetIdPredicate = [NSPredicate predicateWithFormat:@"%K = %@", [TWRTweet tweetIDParameter], tweetID];
    NSPredicate *hashtagPredicate = (hashtag) ? [NSPredicate predicateWithFormat:@"%K = %@", [TWRTweet tweetHashtagParameter], hashtag] : [NSPredicate predicateWithFormat:@"%K = nil", [TWRTweet tweetHashtagParameter]];
    
    request.predicate = [[NSCompoundPredicate alloc] initWithType:NSAndPredicateType subpredicates:@[hashtagPredicate, tweetIdPredicate]];
    
    __block NSUInteger count = 0;
    
    [self.mainContext performBlockAndWait:^{
        count = [self.mainContext countForFetchRequest:request error:nil];
    }];
    
    return count;
}

- (void)saveAutomaticTweetsDeleteDate:(nonnull NSDate *)date {
    
    self.dateForOlderDeleting = date;
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:kTweetsDeleteDateKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isTweetDateIsAllowed:(nonnull NSDate *)date {
    
    if (self.dateForOlderDeleting && [date isEarlierThanDate:self.dateForOlderDeleting]) {
        return NO;
    }
    else {
        return YES;
    }
}

- (void)deleteTweetsOlderThanDate:(nonnull NSDate *)date {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[TWRTweet entityName]];
    request.predicate = [NSPredicate predicateWithFormat:@"createdAt < %@", date];
    
    NSBatchDeleteRequest *deleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    [self.mainContext performBlock:^{
        [self.mainContext executeRequest:deleteRequest error:nil];
        [self.mainContext save:nil];
    }];    
}

- (void)saveContext {
    [self.mainContext performBlock:^{
        [self.mainContext save:nil];
    }];
}

- (nullable NSDate *)savedAutomaticTweetsDeleteDate {
    return self.dateForOlderDeleting;
}

- (NSDate *)dateForOlderDeleting {
    if (!_dateForOlderDeleting) {
        _dateForOlderDeleting = [[NSUserDefaults standardUserDefaults] objectForKey:kTweetsDeleteDateKey];
    }
    return _dateForOlderDeleting;
}

@end
