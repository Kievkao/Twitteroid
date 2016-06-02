//
//  TWRTwitterManager+TWRFeed.h
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRTwitterManager.h"

@interface TWRTwitterManager (TWRFeed)

- (void)getFeedOlderThatTwitID:(NSString *)twitID
                    forHashtag:(NSString *)hashtag
                         count:(NSUInteger)count
                    completion:(void(^)(NSError *error, NSArray *items))completion;

@end
