//
//  TWRTwitterFeedService.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/3/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWRTwitterFeedServiceProtocol.h"

@class STTwitterAPI;
@protocol TWRTweetParserProtocol;

@interface TWRTwitterFeedService : NSObject <TWRTwitterFeedServiceProtocol>

- (instancetype)initWithTwitterAPI:(STTwitterAPI *)twitterAPI tweetParser:(id<TWRTweetParserProtocol>)tweetParser;

@end
