//
//  TWRAutoDeleteSettingsInteractor.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/2/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWRAutoSettingsInteractorProtocol.h"
#import "TWRAutoSettingsPresenterProtocol.h"

@protocol TWRStorageManagerProtocol;

@interface TWRAutoSettingsInteractor : NSObject <TWRAutoSettingsInteractorProtocol>

@property (nonatomic, weak) id<TWRAutoSettingsPresenterProtocol> presenter;

- (instancetype)initWithStorageManager:(id<TWRStorageManagerProtocol>)storageManager;

@end
