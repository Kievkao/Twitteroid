//
//  TWRTweetsDAO.m
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/31/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import "TWRTwitterDAO.h"
#import "Reachability.h"
#import "TWRTweet.h"
#import "TWRTweetParserProtocol.h"
#import "TWRTwitterAPIManagerProtocol.h"

static NSUInteger const kTweetsLoadingPortion = 20;
static NSString *const kAppErrorDomain = @"TwitteroidDomain";

@interface TWRTwitterDAO()

@property (strong, nonatomic) id<TWRTweetParserProtocol> tweetParser;
@property (strong, nonatomic) id<TWRTwitterAPIManagerProtocol> twitterAPIManager;

@end

@implementation TWRTwitterDAO

- (instancetype)initWithTwitterAPIManager:(id<TWRTwitterAPIManagerProtocol>)twitterAPIManager tweetParser:(id<TWRTweetParserProtocol>)tweetParser
{
    self = [super init];
    if (self) {
        _twitterAPIManager = twitterAPIManager;
        _tweetParser = tweetParser;
    }
    return self;
}

- (void)loadTweetsFromID:(NSString *)tweetID hashtag:(NSString *)hashtag withCompletion:(void (^)(NSArray <TWRTweet *> *tweets, NSError *error))loadingCompletion {
    __typeof(self) __weak weakSelf = self;

    [self prepareForLoadingWithCompletion:^(NSError *error) {
        if (error == nil) {
            [self.twitterAPIManager getFeedOlderThatTwitID:tweetID forHashtag:hashtag count:kTweetsLoadingPortion completion:^(NSError *error, NSArray *items) {
                if (!error) {
                    NSArray <TWRTweet *> *tweets = [weakSelf parseTweetsArray:items forHashtag:hashtag];
                    loadingCompletion(tweets, nil);
                }
                else {
                    NSLog(@"Loading error");
                }

                loadingCompletion(nil, error);
            }];
        }
        else {
            loadingCompletion(nil, error);
        }
    }];
}

- (void)prepareForLoadingWithCompletion:(void (^)(NSError *error))completion {

    BOOL isSessionLoginDone = [self.twitterAPIManager isSessionLoginDone];
    BOOL isInternetActive = [self isInternetActive];

    if (!isInternetActive) {
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorNotConnectedToInternet userInfo:nil];
        completion(error);
    }
    else if (!isSessionLoginDone) {
        [self.twitterAPIManager reloginWithCompletion:^(NSError *error) {
            if (!error) {
                completion(nil);
            }
            else {
                completion(error);
            }
        }];
    }
    else {
        completion(nil);
    }
}

- (NSArray <TWRTweet *> *)parseTweetsArray:(NSArray *)items forHashtag:(NSString *)hashtag {

    NSMutableArray <TWRTweet *> *tweets = [[NSMutableArray alloc] initWithCapacity:items.count];

    for (NSDictionary *oneItem in items) {

        TWRTweet *tweet = [self.tweetParser parseTweetDictionary:oneItem];

        if (hashtag) {
            tweet.hashtag = hashtag;
        }
        [tweets addObject:tweet];
    }

    return tweets;
}

- (BOOL)isInternetActive {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];

    return !(networkStatus == NotReachable);
}

@end
