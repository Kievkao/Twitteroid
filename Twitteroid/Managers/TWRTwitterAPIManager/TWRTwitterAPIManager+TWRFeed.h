//
//  TWRTwitterAPIManager+TWRFeed.h
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRTwitterAPIManager.h"

@interface TWRTwitterAPIManager (TWRFeed)

- (void)getFeedOlderThatTwitID:(NSString *)twitID count:(NSUInteger)count completion:(void(^)(NSError *error, NSArray *items))completion;
- (void)getTweetsByHashtag:(NSString *)hashtag olderThatTwitID:(NSString *)twitID count:(NSUInteger)count completion:(void(^)(NSError *error, NSArray *items))completion;

@end
