//
//  TWRTweet.h
//  Twitteroid
//
//  Created by Andrey Kravchenko on 7/28/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TWRHashtag, TWRMedia, TWRPlace;

@interface TWRTweet : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * tweetId;
@property (nonatomic, retain) NSString * userAvatarURL;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * userNickname;
@property (nonatomic, retain) NSString * hashtag;
@property (nonatomic, retain) NSSet *hashtags;
@property (nonatomic, retain) NSSet *medias;
@property (nonatomic, retain) TWRPlace *place;
@end

@interface TWRTweet (CoreDataGeneratedAccessors)

- (void)addHashtagsObject:(TWRHashtag *)value;
- (void)removeHashtagsObject:(TWRHashtag *)value;
- (void)addHashtags:(NSSet *)values;
- (void)removeHashtags:(NSSet *)values;

- (void)addMediasObject:(TWRMedia *)value;
- (void)removeMediasObject:(TWRMedia *)value;
- (void)addMedias:(NSSet *)values;
- (void)removeMedias:(NSSet *)values;

@end
