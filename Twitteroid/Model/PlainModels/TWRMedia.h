//
//  TWRMedia.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/31/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TWRTweet;

@interface TWRMedia : NSObject

@property (strong, nonatomic) NSString *mediaURL;
@property (nonatomic) BOOL isPhoto;
@property (strong, nonatomic) TWRTweet *tweet;

@end
