//
//  TWRCoreDataManager.h
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import <CoreData/CoreData.h>
@class TWRTweet, TWRHashtag, TWRMedia, TWRPlace;

@interface TWRCoreDataManager : NSObject

+ (nullable instancetype)sharedInstance;
- (void)saveContext;
- (nullable NSFetchedResultsController *)fetchedResultsControllerForTweetsHashtag:(nullable NSString *)hashtag;

- (nullable NSManagedObject *)insertNewEntity:(nonnull Class)entityClass;

- (BOOL)isExistsTweetWithID:(nonnull NSString *)tweetID forHashtag:(nullable NSString *)hashtag;
- (BOOL)isAnySavedTweetsForHashtag:(nullable NSString *)hashtag;

- (void)deleteTweetsOlderThanDate:(nonnull NSDate *)date;

- (void)saveAutomaticTweetsDeleteDate:(nonnull NSDate *)date;
- (nonnull NSDate *)savedAutomaticTweetsDeleteDate;
- (BOOL)isTweetDateIsAllowed:(nonnull NSDate *)date;

@end
