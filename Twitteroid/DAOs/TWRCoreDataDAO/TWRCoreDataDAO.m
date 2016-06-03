//
//  TWRCoreDataDAO.m
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "AppDelegate.h"
#import "TWRCoreDataDAO.h"
#import "TWRManagedMedia+TWRHelper.h"
#import "TWRManagedTweet+TWRHelper.h"
#import "TWRManagedHashtag+TWRHelper.h"
#import "TWRManagedPlace+TWRHelper.h"
#import "NSDate+Escort.h"
#import "TWRTweet.h"
#import "TWRPlace.h"
#import "TWRHashtag.h"
#import "TWRMedia.h"

static NSString *const kTweetsDeleteDateKey = @"TWRManagedTweetsDeleteDateKey";

@interface TWRCoreDataDAO()

@property (nonatomic, strong) NSDate *dateForOlderDeleting;
@property (nonatomic, strong) NSManagedObjectContext *mainContext;
@property (nonatomic, strong) NSManagedObjectContext *privateContext;

@end

@implementation TWRCoreDataDAO

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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:self.privateContext];
}

- (NSFetchedResultsController *)fetchedResultsControllerForTweetsHashtag:(nullable NSString *)hashtag {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[TWRManagedTweet entityName]];
    
    if (hashtag) {
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K = %@", [TWRManagedTweet tweetHashtagParameter], hashtag];
    }
    else {
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K = nil", [TWRManagedTweet tweetHashtagParameter]];
    }
    
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:[TWRManagedTweet defaultSortDescriptor] ascending:NO]]];
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.mainContext sectionNameKeyPath:nil cacheName:nil];
    
    return fetchedResultsController;
}

- (void)insertNewTweet:(TWRTweet *)tweet {

    __typeof(self) __weak weakSelf = self;

    [self.privateContext performBlockAndWait:^{
       TWRManagedTweet * managedTweet = [NSEntityDescription insertNewObjectForEntityForName:[TWRManagedTweet entityName] inManagedObjectContext:weakSelf.privateContext];

        managedTweet.createdAt = tweet.createdAt;
        managedTweet.hashtag = tweet.hashtag;
        managedTweet.text = tweet.text;
        managedTweet.tweetId = tweet.tweetId;
        managedTweet.userAvatarURL = tweet.userAvatarURL;
        managedTweet.userName = tweet.userName;
        managedTweet.userNickname = tweet.userNickname;
        managedTweet.isRetwitted = @(tweet.isRetwitted);
        managedTweet.retwittedBy = tweet.retwittedBy;

        if (tweet.hashtags.count > 0) {
            NSMutableSet *hashtags = [NSMutableSet new];
            for (TWRHashtag *hashtag in tweet.hashtags) {
                TWRManagedHashtag *managedHashtag = [weakSelf insertNewHashtag:hashtag];
                managedHashtag.tweet = managedTweet;

                [hashtags addObject:managedHashtag];
            }
            managedTweet.hashtags = hashtags;
        }

        if (tweet.medias.count > 0) {
            NSMutableSet *medias = [NSMutableSet new];
            for (TWRMedia *media in tweet.medias) {
                TWRManagedMedia *managedMedia = [weakSelf insertNewMedia:media];
                managedMedia.tweet = managedTweet;

                [medias addObject:managedMedia];
            }
            managedTweet.medias = medias;
        }

        if (tweet.place != nil) {
            TWRManagedPlace *managedPlace = [weakSelf insertNewPlace:tweet.place];
            
            managedPlace.tweet = managedTweet;
            managedTweet.place = managedPlace;
        }
    }];
}

- (TWRManagedHashtag *)insertNewHashtag:(TWRHashtag *)hashtag {

    __block TWRManagedHashtag *managedHashtag = nil;
    __typeof(self) __weak weakSelf = self;

    [self.privateContext performBlockAndWait:^{
        managedHashtag = [NSEntityDescription insertNewObjectForEntityForName:[TWRManagedHashtag entityName] inManagedObjectContext:weakSelf.privateContext];
        managedHashtag.startIndex = hashtag.startIndex;
        managedHashtag.endIndex = hashtag.endIndex;
        managedHashtag.text = hashtag.text;
    }];

    return managedHashtag;
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
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[TWRManagedTweet entityName]];
    request.predicate = [NSPredicate predicateWithFormat:@"createdAt < %@", date];
    
    NSBatchDeleteRequest *deleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];

    __typeof(self) __weak weakSelf = self;
    [self.mainContext performBlock:^{
        [weakSelf.mainContext executeRequest:deleteRequest error:nil];
        [weakSelf.mainContext save:nil];
    }];    
}

- (void)saveContext {
    __typeof(self) __weak weakSelf = self;

    [self.privateContext performBlock:^{
        NSError *error = nil;
        [weakSelf.privateContext save:&error];

        if (error) {
            NSLog(@"Save private context error: %@", error.localizedDescription);
        }
    }];
}

- (void)managedObjectContextDidSave:(NSNotification *)notification {
    __typeof(self) __weak weakSelf = self;

    [self.mainContext performBlock:^{
        [weakSelf.mainContext mergeChangesFromContextDidSaveNotification:notification];
    }];
}

- (nullable NSDate *)tweetsAutoDeleteDate {
    return self.dateForOlderDeleting;
}

- (NSDate *)dateForOlderDeleting {
    if (!_dateForOlderDeleting) {
        _dateForOlderDeleting = [[NSUserDefaults standardUserDefaults] objectForKey:kTweetsDeleteDateKey];
    }
    return _dateForOlderDeleting;
}

- (TWRManagedMedia *)insertNewMedia:(TWRMedia *)media {

    __block TWRManagedMedia *managedMedia = nil;
    __typeof(self) __weak weakSelf = self;

    [self.privateContext performBlockAndWait:^{
        managedMedia = [NSEntityDescription insertNewObjectForEntityForName:[TWRManagedMedia entityName] inManagedObjectContext:weakSelf.privateContext];
        managedMedia.mediaURL = media.mediaURL;
        managedMedia.isPhoto = media.isPhoto;
    }];

    return managedMedia;
}

- (TWRManagedPlace *)insertNewPlace:(TWRPlace *)place {

    __block TWRManagedPlace *managedPlace = nil;
    __typeof(self) __weak weakSelf = self;

    [self.privateContext performBlockAndWait:^{
        managedPlace = [NSEntityDescription insertNewObjectForEntityForName:[TWRManagedPlace entityName] inManagedObjectContext:weakSelf.privateContext];
        managedPlace.countryName = place.countryName;
        managedPlace.lattitude = place.lattitude;
        managedPlace.longitude = place.longitude;
    }];

    return managedPlace;
}

@end
