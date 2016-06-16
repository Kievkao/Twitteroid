//
//  TWRManualDeleteSettingsInteractor.m
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/2/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import "TWRManualSettingsInteractor.h"
#import "TWRStorageManagerProtocol.h"

@interface TWRManualSettingsInteractor()

@property (strong, nonatomic) id<TWRStorageManagerProtocol> storageManager;

@end

@implementation TWRManualSettingsInteractor

- (instancetype)initWithStorageManager:(id<TWRStorageManagerProtocol>)storageManager {
    self = [super init];
    if (self) {
        _storageManager = storageManager;
    }
    return self;
}

- (void)deleteTweetsOlderThanDate:(NSDate *)date {
    [self.storageManager deleteTweetsOlderThanDate:date];
}

@end
