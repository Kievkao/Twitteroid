//
//  TWRTwitterAPIManager+TWRFeed.m
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRTwitterAPIManager.h"
#import "TWRTwitterAPIManager+TWRFeed.h"

@implementation TWRTwitterAPIManager (TWRFeed)

- (void)getFeedSinceTwitID:(NSString *)twitID count:(NSUInteger)count completion:(void(^)(NSError *error, NSArray *items))completion
{
    [self.twitter getHomeTimelineSinceID:twitID count:count successBlock:^(NSArray *statuses) {
        completion(nil, statuses);
    } errorBlock:^(NSError *error) {
        completion(error, nil);
    }];
}

@end
