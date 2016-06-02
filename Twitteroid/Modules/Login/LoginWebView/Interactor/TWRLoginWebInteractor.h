//
//  TWRLoginWebInteractor.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/30/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWRLoginWebInteractorProtocol.h"

@class TWRTwitterManager;

@interface TWRLoginWebInteractor : NSObject <TWRLoginWebInteractorProtocol>

- (instancetype)initWithTwitterAPIManager:(TWRTwitterManager *)twitterAPIManager;

@end
