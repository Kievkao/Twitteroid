//
//  TWRTweet.h
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TWRHash, TWRMedia, TWRPlace;

@interface TWRTweet : NSManagedObject

@property (nonatomic) NSTimeInterval createdAt;
@property (nonatomic, retain) NSString * userAvatarURL;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSSet *hashes;
@property (nonatomic, retain) NSSet *medias;
@property (nonatomic, retain) TWRPlace *place;
@end

@interface TWRTweet (CoreDataGeneratedAccessors)

- (void)addHashesObject:(TWRHash *)value;
- (void)removeHashesObject:(TWRHash *)value;
- (void)addHashes:(NSSet *)values;
- (void)removeHashes:(NSSet *)values;

- (void)addMediasObject:(TWRMedia *)value;
- (void)removeMediasObject:(TWRMedia *)value;
- (void)addMedias:(NSSet *)values;
- (void)removeMedias:(NSSet *)values;

@end
