//
//  TWRMenuVC.m
//  Twitteroid
//
//  Created by Andrey Kravchenko on 7/27/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRMenuVC.h"

@interface TWRMenuVC () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIDatePicker *manualDatePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *weeksAutoDatePicker;

@end

@implementation TWRMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.weeksAutoDatePicker selectRow:4 inComponent:0 animated:NO];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 52;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    switch (row) {
        case 1:
            return [NSString stringWithFormat:@"%ld week", (long)row];
            
        default:
            return [NSString stringWithFormat:@"%ld weeks", (long)row];
    }    
}

- (IBAction)manualDeletingDateSelected:(UIDatePicker *)sender {
    
}

@end
