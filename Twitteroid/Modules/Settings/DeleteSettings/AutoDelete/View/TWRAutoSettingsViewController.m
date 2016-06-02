//
//  TWRAutoSettingsViewController.m
//  Twitteroid
//
//  Created by Andrey Kravchenko on 7/28/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRAutoSettingsViewController.h"

static NSUInteger const kTotalWeeksAmount = 52;

@interface TWRAutoSettingsViewController ()  <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *weeksAutoDatePicker;

@end

@implementation TWRAutoSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.eventHandler handleViewDidLoad];
}

- (void)setWeeksNumber:(NSUInteger)weeksNumber {
    [self.weeksAutoDatePicker selectRow:(weeksNumber - 1) inComponent:0 animated:NO];
}

- (IBAction)applyClicked:(id)sender {
    [self.eventHandler handleApplyDeleteRuleAction];
}

- (void)showApplyRuleAlertWithTitle:(NSString *)title message:(NSString *)message {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSUInteger selectedWeeksCellIndex = [self.weeksAutoDatePicker selectedRowInComponent:0];
        [self.eventHandler handleConfirmDeleteRuleActionWithWeeksNumber:selectedWeeksCellIndex + 1];
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];

    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return kTotalWeeksAmount - 1;
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
