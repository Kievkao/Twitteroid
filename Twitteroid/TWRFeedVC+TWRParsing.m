//
//  TWRFeedVC+TWRParsing.m
//  Twitteroid
//
//  Created by Andrey Kravchenko on 7/24/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRFeedVC+TWRParsing.h"

@implementation TWRFeedVC (TWRParsing)

- (void)parseTweetsArray:(NSArray *)items {
    
    for (NSDictionary *oneItem in items) {
        
        if ([TWRCoreDataManager isExistsTweetWithID:oneItem[@"id_str"] performInContext:[TWRCoreDataManager mainContext]]) {
            continue;
        }
        
        TWRTweet *tweet = [TWRCoreDataManager insertNewTweetInContext:[TWRCoreDataManager mainContext]];
        
        tweet.createdAt = [self.dateFormatter dateFromString:oneItem[@"created_at"]];
        
        NSDictionary *userInfoDict = oneItem[@"user"];
        tweet.userAvatarURL = userInfoDict[@"profile_image_url"];
        tweet.userName = userInfoDict[@"name"];
        tweet.userNickname = userInfoDict[@"screen_name"];
        tweet.tweetId = oneItem[@"id_str"];
        
        NSDictionary *tweetTextContainer = (oneItem[@"retweeted_status"]) ? (oneItem[@"retweeted_status"]) : oneItem;
        tweet.text = tweetTextContainer[@"text"];
        
        if (![oneItem[@"place"] isKindOfClass:[NSNull class]]) {
            NSDictionary *placeDict = oneItem[@"place"];
            NSDictionary *boundingBoxDict = placeDict[@"bounding_box"];
            NSArray *coordinates = boundingBoxDict[@"coordinates"];
        }
        
        if (![oneItem[@"entities"] isKindOfClass:[NSNull class]]) {
            NSDictionary *entitiesDict = oneItem[@"entities"];
            
            if (![entitiesDict[@"hashtags"] isKindOfClass:[NSNull class]]) {
                NSArray *hastagsArray = entitiesDict[@"hashtags"];
                
                NSMutableSet *hashtags = [NSMutableSet set];
                
                for (NSDictionary *hash in hastagsArray) {
                    
                    NSArray *indicies = hash[@"indicies"];
                    TWRHashtag *hashtag = [TWRCoreDataManager insertNewHashtagInContext:[TWRCoreDataManager mainContext]];
                    hashtag.startIndex = [[indicies firstObject] intValue];
                    hashtag.endIndex = [[indicies lastObject] intValue];
                    hashtag.text = hash[@"text"];
                    hashtag.tweet = tweet;
                    
                    [hashtags addObject:hashtag];
                }
                
                tweet.hashtags = hashtags;
            }
            
            if (![entitiesDict[@"media"] isKindOfClass:[NSNull class]]) {
                NSArray *mediaArray = entitiesDict[@"media"];\
                NSDictionary *mediaDict = [mediaArray firstObject];
                
                TWRMedia *media = [TWRCoreDataManager insertNewMediaInContext:[TWRCoreDataManager mainContext]];
                media.mediaURL = mediaDict[@"media_url"];
                media.tweet = tweet;
                
                tweet.medias = [NSSet setWithObject:media];
            }
        }
    }
}


@end
