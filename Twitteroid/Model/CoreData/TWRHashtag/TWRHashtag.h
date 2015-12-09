//
//  TWRHashtag.h
//  Twitteroid
//
//  Created by Andrey Kravchenko on 7/24/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TWRTweet;

@interface TWRHashtag : NSManagedObject

@property (nonatomic) int32_t endIndex;
@property (nonatomic) int32_t startIndex;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) TWRTweet *tweet;

@end
