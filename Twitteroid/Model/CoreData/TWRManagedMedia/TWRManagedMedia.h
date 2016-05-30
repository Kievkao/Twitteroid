//
//  TWRManagedMedia.h
//  Twitteroid
//
//  Created by Mac on 26/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TWRManagedTweet;

@interface TWRManagedMedia : NSManagedObject

@property (nonatomic, retain) NSString *mediaURL;
@property (nonatomic) BOOL isPhoto;
@property (nonatomic, retain) TWRManagedTweet *tweet;

@end
