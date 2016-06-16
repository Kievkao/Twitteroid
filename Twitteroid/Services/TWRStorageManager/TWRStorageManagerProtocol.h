//
//  TWRStorageManagerProtocol.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/2/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TWRTweet;

NS_ASSUME_NONNULL_BEGIN

@protocol TWRStorageManagerProtocol <NSObject>

- (void)insertNewTweet:(TWRTweet *)tweet;
- (void)saveContext;
- (NSFetchedResultsController *)fetchedResultsControllerForTweetsHashtag:(nullable NSString *)hashtag;

- (void)deleteTweetsOlderThanDate:(nonnull NSDate *)date;
- (void)saveAutomaticTweetsDeleteDate:(nonnull NSDate *)date;
- (nullable NSDate *)tweetsAutoDeleteDate;
- (BOOL)isTweetDateIsAllowed:(nonnull NSDate *)date;

@end

NS_ASSUME_NONNULL_END
