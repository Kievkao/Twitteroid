//
//  TWRCoreDataManager.h
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRBaseSingletonNSObject.h"
#import <CoreData/CoreData.h>
@class TWRTweet, TWRHashtag, TWRMedia;

@interface TWRCoreDataManager : TWRBaseSingletonNSObject

+ (NSManagedObjectContext *)mainContext;
+ (void)saveContext:(NSManagedObjectContext *)context;
+ (NSFetchedResultsController *)fetchedResultsControllerForTweetsFeed;

+ (TWRTweet *)insertNewTweetInContext:(NSManagedObjectContext *)context;
+ (TWRHashtag *)insertNewHashtagInContext:(NSManagedObjectContext *)context;
+ (TWRMedia *)insertNewMediaInContext:(NSManagedObjectContext *)context;

+ (BOOL)isExistsTweetWithID:(NSString *)tweetID performInContext:(NSManagedObjectContext *)context;

@end
