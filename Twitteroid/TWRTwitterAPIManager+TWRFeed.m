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

- (void)getFeedOlderThatTwitID:(NSString *)twitID count:(NSUInteger)count completion:(void(^)(NSError *error, NSArray *items))completion
{
    [self.twitter getStatusesHomeTimelineWithCount:[NSString stringWithFormat:@"%d", count] sinceID:nil maxID:twitID trimUser:nil excludeReplies:nil contributorDetails:nil includeEntities:nil successBlock:^(NSArray *statuses) {
        completion(nil, statuses);
    } errorBlock:^(NSError *error) {
        completion(error, nil);
    }];
}

@end
