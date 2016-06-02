//
//  TWRAutoDeleteSettingsInteractor.m
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/2/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import "TWRAutoSettingsInteractor.h"
#import "TWRCoreDataManager.h"
#import "NSDate+Escort.h"

@implementation TWRAutoSettingsInteractor

- (void)retrieveSavedWeeksNumber {
    NSDate *savedDateForAutoDeleting = [[TWRCoreDataManager sharedInstance] tweetsAutoDeleteDate];

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
    [[TWRCoreDataManager sharedInstance] deleteTweetsOlderThanDate:date];
}

- (void)saveAutomaticTweetsDeleteDate:(NSDate *)date {
    [[TWRCoreDataManager sharedInstance] saveAutomaticTweetsDeleteDate:date];
}

@end
