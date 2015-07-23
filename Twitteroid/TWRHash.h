//
//  TWRHash.h
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject;

@interface TWRHash : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic) int32_t startIndex;
@property (nonatomic) int32_t endIndex;
@property (nonatomic, retain) NSManagedObject *tweet;

@end
