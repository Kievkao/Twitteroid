//
//  TWRSettingsInteractor.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/13/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWRSettingsInteractorProtocol.h"
#import "TWRSettingsPresenterProtocol.h"

@class TWRUserProfileStorage;
@protocol TWRTwitterLoginServiceProtocol;

@interface TWRSettingsInteractor : NSObject <TWRSettingsInteractorProtocol>

@property (nonatomic, weak) id<TWRSettingsPresenterProtocol> presenter;

- (instancetype)initWithLoginService:(id<TWRTwitterLoginServiceProtocol>)loginService userProfileStorage:(TWRUserProfileStorage *)userProfileStorage;

@end
