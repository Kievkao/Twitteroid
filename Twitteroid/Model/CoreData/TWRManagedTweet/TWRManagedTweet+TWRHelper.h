//
//  TWRManagedTweet+TWRHelper.h
//  Twitteroid
//
//  Created by Andrey Kravchenko on 7/24/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRManagedTweet.h"

@interface TWRManagedTweet (TWRHelper)

+ (NSString *)entityName;
+ (NSString *)defaultSortDescriptor;
+ (NSString *)tweetIDParameter;
+ (NSString *)tweetHashtagParameter;

@end
