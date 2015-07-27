//
//  TWRMenuVC.m
//  Twitteroid
//
//  Created by Andrey Kravchenko on 7/27/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRMenuVC.h"
#import "TWRCoreDataManager.h"
#import "NSDate+Escort.h"

static NSUInteger const kDefaultInitialWeekIndex = 4;
static NSUInteger const kTotalWeeksAmount = 51;

@interface TWRMenuVC () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIDatePicker *manualDatePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *weeksAutoDatePicker;

@end

@implementation TWRMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

- (IBAction)deleteNowClicked:(id)sender {
    
    [self showSureAlertWithTitle:NSLocalizedString(@"Confirmation", @"Confirmation alert title") text:NSLocalizedString(@"Are you sure to delete tweets older than selected date?", @"\"Are you sure\" text for tweets deleting, that are older than selected date") okCompletionBlock:^(UIAlertAction *action) {
        
        NSDate *selectedDate = self.manualDatePicker.date;
        [TWRCoreDataManager deleteTweetsOlderThanDate:selectedDate performInContext:[TWRCoreDataManager mainContext]];
        
        [self showInfoAlertWithTitle:NSLocalizedString(@"Done", @"Done alert text") text:NSLocalizedString(@"Filtered tweets have deleted", @"Filtered tweets have deleted")];
    }];
}

- (IBAction)applyClicked:(id)sender {
    
    [self showSureAlertWithTitle:NSLocalizedString(@"Confirmation", @"Confirmation alert title") text:NSLocalizedString(@"Are you sure to confirm this time interval?", @"\"Are you sure\" text for applying automatic tweets delete interval") okCompletionBlock:^(UIAlertAction *action) {
        
        NSUInteger selectedWeeksCellIndex = [self.weeksAutoDatePicker selectedRowInComponent:0];
        
        NSDate *selectedDate = [NSDate dateWithDaysBeforeNow:(selectedWeeksCellIndex + 1)*7];
        [TWRCoreDataManager deleteTweetsOlderThanDate:selectedDate performInContext:[TWRCoreDataManager mainContext]];
        [[TWRCoreDataManager sharedInstance] saveAutomaticTweetsDeleteDate:selectedDate];
        
        [self showInfoAlertWithTitle:NSLocalizedString(@"Done", @"Done alert text") text:NSLocalizedString(@"Filtered tweets have deleted", @"Filtered tweets have deleted")];
    }];
}

- (void)showSureAlertWithTitle:(NSString *)title text:(NSString *)text okCompletionBlock:(void(^)(UIAlertAction *action))block {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:text preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:block]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
