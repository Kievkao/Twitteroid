//
//  TWRAutoDeleteSettingsPresenter.m
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/2/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import "TWRAutoSettingsPresenter.h"
#import "NSDate+Escort.h"

static NSUInteger const kDefaultInitialWeekIndex = 4;
static NSUInteger const kMaxWeeksNumber = 52;

@implementation TWRAutoSettingsPresenter

- (void)handleViewDidLoad {
    [self.interactor retrieveSavedWeeksNumber];
}

- (void)presentWeeksNumber:(NSUInteger)weeksNumber {
    [self.view setWeeksNumber:((weeksNumber < kMaxWeeksNumber) && weeksNumber > 0) ? weeksNumber : kDefaultInitialWeekIndex];
}

- (void)handleApplyDeleteRuleAction {
    [self.view showApplyRuleAlertWithTitle:NSLocalizedString(@"Confirmation", @"Confirmation alert title") message:NSLocalizedString(@"Are you sure to confirm this time interval?", @"\"Are you sure\" text for applying automatic tweets delete interval")];
}

- (void)handleConfirmDeleteRuleActionWithWeeksNumber:(NSUInteger)weeksNumber {
    NSDate *selectedDate = [NSDate dateWithDaysBeforeNow:(weeksNumber * 7)];

    [self.interactor deleteTweetsOlderThanDate:selectedDate];
    [self.interactor saveAutomaticTweetsDeleteDate:selectedDate];
    [self.view showAlertWithTitle:NSLocalizedString(@"Done", @"Done alert text") message:NSLocalizedString(@"Filtered tweets have deleted", @"Filtered tweets have deleted")];
}

@end
