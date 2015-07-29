//
//  TWRMedia.h
//  Twitteroid
//
//  Created by Mac on 26/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TWRTweet;

@interface TWRMedia : NSManagedObject

@property (nonatomic, retain) NSString *mediaURL;
@property (nonatomic) BOOL isPhoto;
@property (nonatomic, retain) TWRTweet *tweet;

@end
