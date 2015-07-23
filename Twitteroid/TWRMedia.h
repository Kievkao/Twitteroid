//
//  TWRMedia.h
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject;

@interface TWRMedia : NSManagedObject

@property (nonatomic, retain) NSString * mediaURL;
@property (nonatomic, retain) NSManagedObject *tweet;

@end
