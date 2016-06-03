//
//  TWRTweetParserProtocol.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/3/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TWRTweet;

@protocol TWRTweetParserProtocol <NSObject>

- (TWRTweet *)parseTweetDictionary:(NSDictionary *)tweetDict;

@end
