//
//  TWRLoginWebInteractor.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/30/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWRLoginWebInteractorProtocol.h"
#import "TWRLoginWebPresenterProtocol.h"

@class TWRTwitterAPIManager;

@interface TWRLoginWebInteractor : NSObject <TWRLoginWebInteractorProtocol>

@property (nonatomic, weak) id<TWRLoginWebPresenterProtocol> presenter;

- (instancetype)initWithTwitterAPIManager:(TWRTwitterAPIManager *)twitterAPIManager;

@end
