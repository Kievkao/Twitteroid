//
//  TWRFeedViewModel.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 2/14/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWRFeedViewModel : NSObject

- (instancetype)initWithHashtag:(NSString *)hashtag;
- (void)checkEnvironmentAndLoadFromTweetID:(NSString *)tweetID withCompletion:(void (^)(NSError *error))loadingCompletion;
- (void)loadFromTweetID:(NSString *)tweetID withCompletion:(void (^)(NSError *error))loadingCompletion;
- (void)parseTweetsArray:(NSArray *)items forHashtag:(NSString *)hashtag;

@end
