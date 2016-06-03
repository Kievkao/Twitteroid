//
//  TWRTweetsDAOProtocol.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/31/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TWRTweet;

@protocol TWRTweetsDAOProtocol <NSObject>

- (void)loadTweetsFromID:(NSString *)tweetID hashtag:(NSString *)hashtag withCompletion:(void (^)(NSArray <TWRTweet *> *tweets, NSError *error))loadingCompletion;

@end
