//
//  TWRPlace.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/30/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TWRTweet;

@interface TWRPlace : NSObject

@property (strong, nonatomic) NSString *countryName;
@property (assign, nonatomic) double lattitude;
@property (assign, nonatomic) double longitude;
@property (weak, nonatomic) TWRTweet *tweet;

@end
