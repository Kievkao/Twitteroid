//
//  TWRAutoDeleteSettingsInteractor.m
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/2/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import "TWRAutoSettingsInteractor.h"
#import "TWRStorageManagerProtocol.h"
#import "NSDate+Escort.h"

@interface TWRAutoSettingsInteractor()

@property (strong, nonatomic) id<TWRStorageManagerProtocol> storageManager;

@end

@implementation TWRAutoSettingsInteractor

- (instancetype)initWithStorageManager:(id<TWRStorageManagerProtocol>)storageManager {
    self = [super init];
    if (self) {
        _storageManager = storageManager;
    }
    return self;
}

- (void)retrieveSavedWeeksNumber {
    NSDate *savedDateForAutoDeleting = [self.storageManager tweetsAutoDeleteDate];

    if (savedDateForAutoDeleting) {
        NSInteger daysAfterSavedData = [[NSDate date] daysAfterDate:savedDateForAutoDeleting];
        NSUInteger weeksNumber = daysAfterSavedData / 7;

        [self.presenter presentWeeksNumber:weeksNumber];
    }
    else {
        [self.presenter presentWeeksNumber:0];
    }
}

- (void)deleteTweetsOlderThanDate:(NSDate *)date {
    [self.storageManager deleteTweetsOlderThanDate:date];
}

- (void)saveAutomaticTweetsDeleteDate:(NSDate *)date {
    [self.storageManager saveAutomaticTweetsDeleteDate:date];
}

@end
