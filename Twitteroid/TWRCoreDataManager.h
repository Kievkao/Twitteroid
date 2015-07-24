//
//  TWRCoreDataManager.h
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRBaseSingletonNSObject.h"
@class TWRTweet, TWRHashtag, TWRMedia;

@interface TWRCoreDataManager : TWRBaseSingletonNSObject

+ (NSManagedObjectContext *)mainContext;

+ (NSFetchedResultsController *)fetchedResultsControllerForTweetsFeed;

+ (TWRTweet *)insertNewTweetInContext:(NSManagedObjectContext *)context;
+ (TWRHashtag *)insertNewHashtagInContext:(NSManagedObjectContext *)context;
+ (TWRMedia *)insertNewMediaInContext:(NSManagedObjectContext *)context;

@end
