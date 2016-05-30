//
//  TWRHashtag.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/31/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TWRTweet;

@interface TWRHashtag : NSObject

@property (nonatomic) int32_t endIndex;
@property (nonatomic) int32_t startIndex;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) TWRTweet *tweet;

@end
