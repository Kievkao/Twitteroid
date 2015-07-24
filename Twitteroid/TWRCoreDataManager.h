//
//  TWRCoreDataManager.h
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRBaseSingletonNSObject.h"

@interface TWRCoreDataManager : TWRBaseSingletonNSObject

+ (NSFetchedResultsController *)fetchedResultsControllerForTweetsFeed;

@end
