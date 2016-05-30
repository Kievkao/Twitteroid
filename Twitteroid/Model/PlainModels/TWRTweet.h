//
//  TWRTweet.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/30/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TWRPlace;

@interface TWRTweet : NSObject

@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSString *hashtag;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *tweetId;
@property (strong, nonatomic) NSString *userAvatarURL;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userNickname;
@property (assign, nonatomic) BOOL isRetwitted;
@property (strong, nonatomic) NSString *retwittedBy;
@property (strong, nonatomic) NSSet *hashtags;
@property (strong, nonatomic) NSSet *medias;
@property (strong, nonatomic) TWRPlace *place;

@end
