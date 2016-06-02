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
#import "NSDateFormatter+LocaleAdditions.h"
#import "TWRTweet.h"
#import "TWRPlace.h"
#import "TWRHashtag.h"
#import "TWRMedia.h"

static NSUInteger const kTweetsLoadingPortion = 20;
static NSString *const kAppErrorDomain = @"com.kievkao.Twitteroid";
static NSString *const kTweetsDateFormat = @"eee MMM dd HH:mm:ss Z yyyy";

@interface TWRTweetsDAO()

@property (strong, nonatomic) NSDateFormatter *dateFormatter;   // init me!!!

@end

@implementation TWRTweetsDAO

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
        TWRTweet *tweet = [TWRTweet new];

        tweet.createdAt = [self.dateFormatter dateFromString:oneItem[@"created_at"]];
        tweet.tweetId = oneItem[@"id_str"];

        if (hashtag) {
            tweet.hashtag = hashtag;
        }

        NSDictionary *bodyDict = nil;

        if (oneItem[@"retweeted_status"]) {

            bodyDict = oneItem[@"retweeted_status"];
            tweet.isRetwitted = YES;

            NSArray *mentions = oneItem[@"entities"][@"user_mentions"];
            NSDictionary *userMention = [mentions firstObject];
            tweet.userName = userMention[@"name"];
            tweet.userNickname = userMention[@"screen_name"];

            NSDictionary *userInfoDict = oneItem[@"retweeted_status"][@"user"];
            tweet.userAvatarURL = userInfoDict[@"profile_image_url"];

            NSDictionary *whoRetweeted = oneItem[@"user"];
            tweet.retwittedBy = whoRetweeted[@"screen_name"];
        }
        else {
            bodyDict = oneItem;
            tweet.isRetwitted = NO;
            NSDictionary *userInfoDict = oneItem[@"user"];
            tweet.userAvatarURL = userInfoDict[@"profile_image_url"];
            tweet.userName = userInfoDict[@"name"];
            tweet.userNickname = userInfoDict[@"screen_name"];
        }

        if (![bodyDict[@"place"] isKindOfClass:[NSNull class]]) {
            NSDictionary *placeDict = bodyDict[@"place"];
            NSDictionary *boundingBoxDict = placeDict[@"bounding_box"];
            NSArray *coordinates = boundingBoxDict[@"coordinates"][0];

            double lattitude = 0;
            double longitude = 0;

            for (NSArray *latLongPair in coordinates) {
                lattitude += [[latLongPair lastObject] doubleValue];
                longitude += [[latLongPair firstObject] doubleValue];
            }

            lattitude /= coordinates.count;
            longitude /= coordinates.count;

            TWRPlace *place = [TWRPlace new];
            place.lattitude = lattitude;
            place.longitude = longitude;
            place.tweet = tweet;

            tweet.place = place;
        }

        tweet.text = bodyDict[@"text"];

        if (![oneItem[@"entities"] isKindOfClass:[NSNull class]]) {
            NSDictionary *entitiesDict = oneItem[@"entities"];

            if (![entitiesDict[@"hashtags"] isKindOfClass:[NSNull class]]) {
                NSArray *hastagsArray = entitiesDict[@"hashtags"];

                NSMutableSet *hashtags = [NSMutableSet set];

                for (NSDictionary *hash in hastagsArray) {
                    NSArray *indicies = hash[@"indicies"];
                    TWRHashtag *hashtag = [TWRHashtag new];
                    hashtag.startIndex = [[indicies firstObject] intValue];
                    hashtag.endIndex = [[indicies lastObject] intValue];
                    hashtag.text = hash[@"text"];
                    hashtag.tweet = tweet;

                    [hashtags addObject:hashtag];
                }
                tweet.hashtags = hashtags;
            }

        }

        if (oneItem[@"extended_entities"]) {
            NSDictionary *extEntities = oneItem[@"extended_entities"];
            NSArray *mediaArray = extEntities[@"media"];
            NSMutableSet *tweetMedias = [NSMutableSet new];

            for (NSDictionary *mediaDict in mediaArray) {
                TWRMedia *media = [TWRMedia new];
                media.mediaURL = mediaDict[@"media_url"];
                media.tweet = tweet;
                media.isPhoto = YES;

                [tweetMedias addObject:media];
            }

            tweet.medias = tweetMedias;
        }
        else if (oneItem[@"entities"]) {
            NSDictionary *entitiesDict = oneItem[@"entities"];
            NSArray *urls = entitiesDict[@"urls"];
            NSMutableSet *tweetUrls = [NSMutableSet new];

            if (![urls isKindOfClass:[NSNull class]]) {
                for (NSDictionary *urlDict in urls) {
                    if ([self isYoutubeLink:urlDict[@"expanded_url"]]) {
                        TWRMedia *media = [TWRMedia new];
                        media.mediaURL = urlDict[@"expanded_url"];
                        media.tweet = tweet;
                        media.isPhoto = NO;
                        
                        [tweetUrls addObject:media];
                    }
                }
                tweet.medias = tweetUrls;
            }
        }

        [tweets addObject:tweet];
    }

    return tweets;
}


- (BOOL)isYoutubeLink:(NSString *)urlStr {
    //@"www.youtube.com"
    //@"youtu.be"
    //@"m.youtube.com"
    return [urlStr containsString:@"youtu"];
}

- (BOOL)isInternetActive {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];

    return !(networkStatus == NotReachable);
}

- (NSDateFormatter *)dateFormatter {

    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] initWithSafeLocale];
        [_dateFormatter setDateFormat:kTweetsDateFormat];
    }
    return _dateFormatter;
}

@end
