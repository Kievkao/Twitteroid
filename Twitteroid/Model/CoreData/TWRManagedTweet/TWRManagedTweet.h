//
//  TWRManagedTweet.h
//  Twitteroid
//
//  Created by Andrey Kravchenko on 7/29/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TWRManagedHashtag, TWRManagedMedia, TWRManagedPlace;

@interface TWRManagedTweet : NSManagedObject

@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSString *hashtag;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *tweetId;
@property (strong, nonatomic) NSString *userAvatarURL;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userNickname;
@property (strong, nonatomic) NSNumber *isRetwitted;
@property (strong, nonatomic) NSString *retwittedBy;
@property (strong, nonatomic) NSSet *hashtags;
@property (strong, nonatomic) NSSet *medias;
@property (strong, nonatomic) TWRManagedPlace *place;
@end

@interface TWRManagedTweet (CoreDataGeneratedAccessors)

- (void)addHashtagsObject:(TWRManagedHashtag *)value;
- (void)removeHashtagsObject:(TWRManagedHashtag *)value;
- (void)addHashtags:(NSSet *)values;
- (void)removeHashtags:(NSSet *)values;

- (void)addMediasObject:(TWRManagedMedia *)value;
- (void)removeMediasObject:(TWRManagedMedia *)value;
- (void)addMedias:(NSSet *)values;
- (void)removeMedias:(NSSet *)values;

@end
