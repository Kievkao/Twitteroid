//
//  TWRTweet+TWRHelper.h
//  Twitteroid
//
//  Created by Andrey Kravchenko on 7/24/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRTweet.h"

@interface TWRTweet (TWRHelper)

+ (NSString *)entityName;
+ (NSString *)defaultSortDescriptor;
+ (NSString *)tweetIDParameter;
+ (NSString *)tweetHashtagParameter;

@end
