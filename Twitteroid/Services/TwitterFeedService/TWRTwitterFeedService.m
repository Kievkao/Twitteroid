//
//  TWRTwitterFeedService.m
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/3/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import "TWRTwitterFeedService.h"
#import "STTwitterAPI.h"
#import "TWRTweetParserProtocol.h"
#import "TWRTweet.h"
#import "Reachability.h"

static NSUInteger const kTweetsLoadingPortion = 10;

@interface TWRTwitterFeedService()

@property (nonatomic, strong) STTwitterAPI *twitterAPI;
@property (strong, nonatomic) id<TWRTweetParserProtocol> tweetParser;

@end

@implementation TWRTwitterFeedService

#pragma mark - Public
- (void)loadTweetsFromID:(NSString *)tweetID hashtag:(NSString *)hashtag withCompletion:(void (^)(NSArray <TWRTweet *> *tweets, NSError *error))loadingCompletion {
    __typeof(self) __weak weakSelf = self;

    [self getFeedOlderThatTwitID:tweetID forHashtag:hashtag count:kTweetsLoadingPortion completion:^(NSError *error, NSArray *items) {
        if (!error) {
            NSArray <TWRTweet *> *tweets = [weakSelf parseTweetsArray:items forHashtag:hashtag];
            loadingCompletion(tweets, nil);
        }

        loadingCompletion(nil, error);
    }];
}

#pragma mark - Private
- (NSArray <TWRTweet *> *)parseTweetsArray:(NSArray *)items forHashtag:(NSString *)hashtag {
    NSMutableArray <TWRTweet *> *tweets = [[NSMutableArray alloc] initWithCapacity:items.count];

    for (NSDictionary *oneItem in items) {
        TWRTweet *tweet = [self.tweetParser parseTweetDictionary:oneItem];

        if (hashtag != nil) {
            tweet.hashtag = hashtag;
        }
        [tweets addObject:tweet];
    }
    return tweets;
}

- (void)getFeedOlderThatTwitID:(NSString *)twitID
                    forHashtag:(NSString *)hashtag
                         count:(NSUInteger)count
                    completion:(void(^)(NSError *error, NSArray *items))completion {

    if (hashtag != nil) {
        [self.twitterAPI getSearchTweetsWithQuery:hashtag geocode:nil lang:nil locale:nil resultType:nil count:[NSString stringWithFormat:@"%lu", (unsigned long)count] until:nil sinceID:nil maxID:twitID includeEntities:nil callback:nil successBlock:^(NSDictionary *searchMetadata, NSArray *statuses) {
            completion(nil, statuses);
        } errorBlock:^(NSError *error) {
            completion(error, nil);
        }];
    }
    else {
        [self.twitterAPI getStatusesHomeTimelineWithCount:[NSString stringWithFormat:@"%lu", (unsigned long)count] sinceID:nil maxID:twitID trimUser:nil excludeReplies:nil contributorDetails:nil includeEntities:nil successBlock:^(NSArray *statuses) {
            completion(nil, statuses);
        } errorBlock:^(NSError *error) {
            completion(error, nil);
        }];
    }
}

@end
