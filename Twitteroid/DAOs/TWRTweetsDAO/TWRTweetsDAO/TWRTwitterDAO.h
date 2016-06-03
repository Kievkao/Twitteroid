//
//  TWRTweetsDAO.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/31/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWRTwitterDAOProtocol.h"

@protocol TWRTweetParserProtocol, TWRTwitterAPIManagerProtocol;

@interface TWRTwitterDAO : NSObject <TWRTwitterDAOProtocol>

- (instancetype)initWithTwitterAPIManager:(id<TWRTwitterAPIManagerProtocol>)twitterAPIManager tweetParser:(id<TWRTweetParserProtocol>)tweetParser;

@end
