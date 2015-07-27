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

+ (instancetype)sharedInstance;
+ (NSManagedObjectContext *)mainContext;
+ (void)saveContext:(NSManagedObjectContext *)context;
+ (NSFetchedResultsController *)fetchedResultsControllerForTweetsFeed;

+ (TWRTweet *)insertNewTweetInContext:(NSManagedObjectContext *)context;
+ (TWRHashtag *)insertNewHashtagInContext:(NSManagedObjectContext *)context;
+ (TWRMedia *)insertNewMediaInContext:(NSManagedObjectContext *)context;
+ (TWRPlace *)insertNewPlaceInContext:(NSManagedObjectContext *)context;

+ (BOOL)isExistsTweetWithID:(NSString *)tweetID performInContext:(NSManagedObjectContext *)context;
+ (BOOL)isAnySavedTweets;

+ (void)deleteTweetsOlderThanDate:(NSDate *)date performInContext:(NSManagedObjectContext *)context;

- (void)saveAutomaticTweetsDeleteDate:(NSDate *)date;
- (NSDate *)savedAutomaticTweetsDeleteDate;
- (BOOL)isTweetDateIsAllowed:(NSDate *)date;

@end
