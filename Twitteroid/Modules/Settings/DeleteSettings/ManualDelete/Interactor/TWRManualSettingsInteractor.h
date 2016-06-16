//
//  TWRManualDeleteSettingsInteractor.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/2/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWRManualSettingsInteractorProtocol.h"

@protocol TWRStorageManagerProtocol;

@interface TWRManualSettingsInteractor : NSObject <TWRManualSettingsInteractorProtocol>

- (instancetype)initWithStorageManager:(id<TWRStorageManagerProtocol>)storageManager;

@end
