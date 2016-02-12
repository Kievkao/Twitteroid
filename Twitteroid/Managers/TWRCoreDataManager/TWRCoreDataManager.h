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
- (void)saveContext;
- (NSFetchedResultsController *)fetchedResultsControllerForTweetsHashtag:(NSString *)hashtag;

- (TWRTweet *)insertNewTweet;
- (TWRHashtag *)insertNewHashtag;
- (TWRMedia *)insertNewMedia;
- (TWRPlace *)insertNewPlace;

- (BOOL)isExistsTweetWithID:(NSString *)tweetID forHashtag:(NSString *)hashtag;
- (BOOL)isAnySavedTweetsForHashtag:(NSString *)hashtag;

- (void)deleteTweetsOlderThanDate:(NSDate *)date;

- (void)saveAutomaticTweetsDeleteDate:(NSDate *)date;
- (NSDate *)savedAutomaticTweetsDeleteDate;
- (BOOL)isTweetDateIsAllowed:(NSDate *)date;

@end
