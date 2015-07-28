//
//  TWRTweet+TWRHelper.m
//  Twitteroid
//
//  Created by Andrey Kravchenko on 7/24/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRTweet+TWRHelper.h"

@implementation TWRTweet (TWRHelper)

+ (NSString *)entityName {
    return @"TWRTweet";
}

+ (NSString *)defaultSortDescriptor {
    return @"createdAt";
}

+ (NSString *)tweetIDParameter {
    return @"tweetId";
}

+ (NSString *)tweetHashtagParameter {
    return @"hashtag";
}

@end
