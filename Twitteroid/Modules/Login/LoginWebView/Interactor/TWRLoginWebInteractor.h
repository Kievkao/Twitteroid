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

@protocol TWRTwitterLoginServiceProtocol;

@interface TWRLoginWebInteractor : NSObject <TWRLoginWebInteractorProtocol>

- (instancetype)initWithLoginService:(id<TWRTwitterLoginServiceProtocol>)loginService;;

@property (nonatomic, weak) id<TWRLoginWebPresenterProtocol> presenter;

@end
