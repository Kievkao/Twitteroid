//
//  TWRSettingsManualVC.m
//  Twitteroid
//
//  Created by Andrey Kravchenko on 7/28/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRSettingsManualVC.h"
#import "TWRCoreDataManager.h"

@interface TWRSettingsManualVC ()

@property (weak, nonatomic) IBOutlet UIDatePicker *manualDatePicker;

@end

@implementation TWRSettingsManualVC

- (IBAction)deleteNowClicked:(id)sender {
    
    [self showSureAlertWithTitle:NSLocalizedString(@"Confirmation", @"Confirmation alert title") text:NSLocalizedString(@"Are you sure to delete tweets older than selected date?", @"\"Are you sure\" text for tweets deleting, that are older than selected date") okCompletionBlock:^(UIAlertAction *action) {
        
        NSDate *selectedDate = self.manualDatePicker.date;
        [TWRCoreDataManager deleteTweetsOlderThanDate:selectedDate];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        [self showInfoAlertWithTitle:NSLocalizedString(@"Done", @"Done alert text") text:NSLocalizedString(@"Filtered tweets have deleted", @"Filtered tweets have deleted")];
    }];
}

@end
