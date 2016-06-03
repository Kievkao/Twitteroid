//
//  TWRCoreDataDAO.h
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "TWRCoreDataDAOProtocol.h"

@interface TWRCoreDataDAO : NSObject <TWRCoreDataDAOProtocol>

- (instancetype)init __attribute__((unavailable("Use 'sharedInstance' instead")));

+ (instancetype)sharedInstance;

@end
