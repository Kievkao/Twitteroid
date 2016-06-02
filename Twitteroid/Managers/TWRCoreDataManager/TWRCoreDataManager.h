//
//  TWRCoreDataManager.h
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import <CoreData/CoreData.h>
@class TWRManagedTweet, TWRManagedHashtag, TWRManagedMedia, TWRManagedPlace, TWRTweet, TWRHashtag, TWRMedia, TWRPlace;

NS_ASSUME_NONNULL_BEGIN

@interface TWRCoreDataManager : NSObject

- (nullable instancetype)init __attribute__((unavailable("Must use 'sharedInstance' instead.")));

+ (nullable instancetype)sharedInstance;
- (void)saveContext;
- (nullable NSFetchedResultsController *)fetchedResultsControllerForTweetsHashtag:(nullable NSString *)hashtag;

- (void)deleteTweetsOlderThanDate:(nonnull NSDate *)date;

- (void)saveAutomaticTweetsDeleteDate:(nonnull NSDate *)date;
- (nullable NSDate *)savedAutomaticTweetsDeleteDate;
- (BOOL)isTweetDateIsAllowed:(nonnull NSDate *)date;

- (void)insertNewTweet:(TWRTweet *)tweet;

@end

NS_ASSUME_NONNULL_END
