//
//  TWRManagedPlace.h
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TWRManagedTweet;

@interface TWRManagedPlace : NSManagedObject

@property (nonatomic, retain) NSString * countryName;
@property (nonatomic) double lattitude;
@property (nonatomic) double longitude;
@property (nonatomic, retain) TWRManagedTweet *tweet;

@end
