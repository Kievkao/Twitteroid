//
//  TWRSettingsAutoVC.m
//  Twitteroid
//
//  Created by Andrey Kravchenko on 7/28/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRSettingsAutoVC.h"
#import "TWRCoreDataManager.h"
#import "NSDate+Escort.h"

static NSUInteger const kDefaultInitialWeekIndex = 4;
static NSUInteger const kTotalWeeksAmount = 51;

@interface TWRSettingsAutoVC ()  <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *weeksAutoDatePicker;

@end

@implementation TWRSettingsAutoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setSavedDataForAutoDeleting];
}

- (void)setSavedDataForAutoDeleting {
    NSDate *savedDateForAutoDeleting = [[TWRCoreDataManager sharedInstance] savedAutomaticTweetsDeleteDate];
    
    if (savedDateForAutoDeleting) {
        NSInteger daysAfterSavedData = [[NSDate date] daysAfterDate:savedDateForAutoDeleting];
        NSUInteger weeksNumber = daysAfterSavedData / 7;
        
        [self.weeksAutoDatePicker selectRow:((weeksNumber < 51) && weeksNumber > 0) ? (weeksNumber - 1) : kDefaultInitialWeekIndex inComponent:0 animated:NO];
    }
    else {
        [self.weeksAutoDatePicker selectRow:kDefaultInitialWeekIndex inComponent:0 animated:NO];
    }
}

- (IBAction)applyClicked:(id)sender {
    
    __weak typeof(self)weakSelf = self;
    
    [self showSureAlertWithTitle:NSLocalizedString(@"Confirmation", @"Confirmation alert title") text:NSLocalizedString(@"Are you sure to confirm this time interval?", @"\"Are you sure\" text for applying automatic tweets delete interval") okCompletionBlock:^(UIAlertAction *action) {
        
        __strong TWRSettingsAutoVC *strongSelf = weakSelf;
        NSUInteger selectedWeeksCellIndex = [strongSelf.weeksAutoDatePicker selectedRowInComponent:0];
        
        NSDate *selectedDate = [NSDate dateWithDaysBeforeNow:(selectedWeeksCellIndex + 1)*7];
        [TWRCoreDataManager deleteTweetsOlderThanDate:selectedDate];
        [[TWRCoreDataManager sharedInstance] saveAutomaticTweetsDeleteDate:selectedDate];
        [strongSelf.navigationController popToRootViewControllerAnimated:YES];
        
        [strongSelf showInfoAlertWithTitle:NSLocalizedString(@"Done", @"Done alert text") text:NSLocalizedString(@"Filtered tweets have deleted", @"Filtered tweets have deleted")];
    }];
}

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return kTotalWeeksAmount;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (row) {
        case 0:
            return [NSString stringWithFormat:@"%ld week", (long)row + 1];
            
        default:
            return [NSString stringWithFormat:@"%ld weeks", (long)row + 1];
    }
}

@end
