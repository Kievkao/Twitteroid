//
//  TWRTweetParser.m
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/3/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import "TWRTweetParser.h"
#import "TWRTweet.h"
#import "TWRPlace.h"
#import "TWRHashtag.h"
#import "TWRMedia.h"
#import "NSDateFormatter+LocaleAdditions.h"

static NSString *const kTweetsDateFormat = @"eee MMM dd HH:mm:ss Z yyyy";

@interface TWRTweetParser()

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation TWRTweetParser

- (TWRTweet *)parseTweetDictionary:(NSDictionary *)tweetDict {
    TWRTweet *tweet = [TWRTweet new];

    tweet.createdAt = [self.dateFormatter dateFromString:tweetDict[@"created_at"]];
    tweet.tweetId = tweetDict[@"id_str"];

    NSDictionary *bodyDict = nil;

    if (tweetDict[@"retweeted_status"]) {

        bodyDict = tweetDict[@"retweeted_status"];
        tweet.isRetwitted = YES;

        NSArray *mentions = tweetDict[@"entities"][@"user_mentions"];
        NSDictionary *userMention = [mentions firstObject];
        tweet.userName = userMention[@"name"];
        tweet.userNickname = userMention[@"screen_name"];

        NSDictionary *userInfoDict = tweetDict[@"retweeted_status"][@"user"];
        tweet.userAvatarURL = userInfoDict[@"profile_image_url"];

        NSDictionary *whoRetweeted = tweetDict[@"user"];
        tweet.retwittedBy = whoRetweeted[@"screen_name"];
    }
    else {
        bodyDict = tweetDict;
        tweet.isRetwitted = NO;
        NSDictionary *userInfoDict = tweetDict[@"user"];
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

    if (![tweetDict[@"entities"] isKindOfClass:[NSNull class]]) {
        NSDictionary *entitiesDict = tweetDict[@"entities"];

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

    if (tweetDict[@"extended_entities"]) {
        NSDictionary *extEntities = tweetDict[@"extended_entities"];
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
    else if (tweetDict[@"entities"]) {
        NSDictionary *entitiesDict = tweetDict[@"entities"];
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

    return tweet;
}

- (BOOL)isYoutubeLink:(NSString *)urlStr {
    //@"www.youtube.com"
    //@"youtu.be"
    //@"m.youtube.com"
    return [urlStr containsString:@"youtu"];
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] initWithSafeLocale];
        [_dateFormatter setDateFormat:kTweetsDateFormat];
    }
    return _dateFormatter;
}

@end
