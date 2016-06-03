//
//  TWRAutoDeleteSettingsInteractor.m
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/2/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import "TWRAutoSettingsInteractor.h"
#import "TWRCoreDataDAOProtocol.h"
#import "NSDate+Escort.h"

@interface TWRAutoSettingsInteractor()

@property (strong, nonatomic) id<TWRCoreDataDAOProtocol> coreDataDAO;

@end

@implementation TWRAutoSettingsInteractor

- (instancetype)initWithCoreDataDAO:(id<TWRCoreDataDAOProtocol>)coreDataDAO {
    self = [super init];
    if (self) {
        _coreDataDAO = coreDataDAO;
    }
    return self;
}

- (void)retrieveSavedWeeksNumber {
    NSDate *savedDateForAutoDeleting = [self.coreDataDAO tweetsAutoDeleteDate];

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
    [self.coreDataDAO deleteTweetsOlderThanDate:date];
}

- (void)saveAutomaticTweetsDeleteDate:(NSDate *)date {
    [self.coreDataDAO saveAutomaticTweetsDeleteDate:date];
}

@end
