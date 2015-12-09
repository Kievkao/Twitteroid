//
//  TWRFeedVC+TWRParsing.m
//  Twitteroid
//
//  Created by Andrey Kravchenko on 7/24/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRFeedVC+TWRParsing.h"

@implementation TWRFeedVC (TWRParsing)

- (void)parseTweetsArray:(NSArray *)items forHashtag:(NSString *)hashtag {
    
    for (NSDictionary *oneItem in items) {
        
        NSDate *tweetDate = [self.dateFormatter dateFromString:oneItem[@"created_at"]];
        
        if ([TWRCoreDataManager isExistsTweetWithID:oneItem[@"id_str"] forHashtag:hashtag] ||
            ![[TWRCoreDataManager sharedInstance] isTweetDateIsAllowed:tweetDate]) {
            continue;
        }
        
        TWRTweet *tweet = [TWRCoreDataManager insertNewTweet];
        
        tweet.createdAt = tweetDate;
        tweet.tweetId = oneItem[@"id_str"];
        
        if (hashtag) {
            tweet.hashtag = hashtag;
        }
        
        NSDictionary *bodyDict = nil;
        
        if (oneItem[@"retweeted_status"]) {
            
            bodyDict = oneItem[@"retweeted_status"];
            tweet.isRetwitted = @(YES);
            
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
            tweet.isRetwitted = @(NO);
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
            
            TWRPlace *place  = [TWRCoreDataManager insertNewPlace];
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
                    TWRHashtag *hashtag = [TWRCoreDataManager insertNewHashtag];
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
                TWRMedia *media = [TWRCoreDataManager insertNewMedia];
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
                        TWRMedia *media = [TWRCoreDataManager insertNewMedia];
                        media.mediaURL = urlDict[@"expanded_url"];
                        media.tweet = tweet;
                        media.isPhoto = NO;
                    
                        [tweetUrls addObject:media];
                    }
                }
                
                tweet.medias = tweetUrls;
            }
        }
    }
}

- (BOOL)isYoutubeLink:(NSString *)urlStr {
//@"www.youtube.com"
//@"youtu.be"
//@"m.youtube.com"
    return [urlStr containsString:@"youtu"];
}


@end
