//
//  TWRManualDeleteSettingsPresenter.m
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/2/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import "TWRManualSettingsPresenter.h"

@implementation TWRManualSettingsPresenter

- (void)handleDeleteNowAction {
    [self.view showDeleteAlertWithTitle:NSLocalizedString(@"Confirmation", @"Confirmation alert title") message:NSLocalizedString(@"Are you sure to delete tweets older than selected date?", @"\"Are you sure\" text for tweets deleting, that are older than selected date")];
}

- (void)handleDeleteConfirmationActionWithDate:(NSDate *)date {
    [self.interactor deleteTweetsOlderThanDate:date];

    [self.view showAlertWithTitle:NSLocalizedString(@"Done", @"Done alert text") message:NSLocalizedString(@"Filtered tweets have deleted", @"Filtered tweets have deleted")];
}

@end
