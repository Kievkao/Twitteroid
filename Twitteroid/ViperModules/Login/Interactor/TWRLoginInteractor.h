//
//  TWRLoginInteractor.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/28/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWRLoginInteractorProtocol.h"
#import "TWRLoginPresenterProtocol.h"

@class TWRTwitterAPIManager;

@interface TWRLoginInteractor : NSObject <TWRLoginInteractorProtocol>

@property (nonatomic, weak) id<TWRLoginPresenterProtocol> presenter;

- (instancetype)initWithTwitterAPIManager:(TWRTwitterAPIManager *)twitterAPIManager;

@end
