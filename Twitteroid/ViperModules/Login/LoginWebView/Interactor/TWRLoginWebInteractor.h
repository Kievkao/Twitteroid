//
//  TWRLoginWebInteractor.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/30/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWRLoginWebInteractorProtocol.h"

@class TWRTwitterAPIManager;

@interface TWRLoginWebInteractor : NSObject <TWRLoginWebInteractorProtocol>

- (instancetype)initWithTwitterAPIManager:(TWRTwitterAPIManager *)twitterAPIManager;

@end
