//
//  TWRTweetsDAO.m
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/31/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import "TWRTweetsDAO.h"
#import "TWRTwitterManager+TWRLogin.h"
#import "TWRTwitterManager+TWRFeed.h"
#import "Reachability.h"
#import "TWRTweet.h"
#import "TWRTweetParserProtocol.h"

static NSUInteger const kTweetsLoadingPortion = 20;
static NSString *const kAppErrorDomain = @"TwitteroidDomain";

@interface TWRTweetsDAO()

@property (strong, nonatomic) id<TWRTweetParserProtocol> tweetParser;

@end

@implementation TWRTweetsDAO

- (instancetype)initWithTweetParser:(id<TWRTweetParserProtocol>)tweetParser
{
    self = [super init];
    if (self) {
        _tweetParser = tweetParser;
    }
    return self;
}

- (void)loadTweetsFromID:(NSString *)tweetID hashtag:(NSString *)hashtag withCompletion:(void (^)(NSArray <TWRTweet *> *tweets, NSError *error))loadingCompletion {
    __typeof(self) __weak weakSelf = self;

    [self prepareForLoadingWithCompletion:^(NSError *error) {
        if (error == nil) {
            [[TWRTwitterManager sharedInstance] getFeedOlderThatTwitID:tweetID forHashtag:hashtag count:kTweetsLoadingPortion completion:^(NSError *error, NSArray *items) {
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

    BOOL isSessionLoginDone = [[TWRTwitterManager sharedInstance] isSessionLoginDone];
    BOOL isInternetActive = [self isInternetActive];

    if (!isInternetActive) {
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorNotConnectedToInternet userInfo:nil];
        completion(error);
    }
    else if (!isSessionLoginDone) {
        [[TWRTwitterManager sharedInstance] reloginWithCompletion:^(NSError *error) {
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

#pragma mark - CoreData
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
