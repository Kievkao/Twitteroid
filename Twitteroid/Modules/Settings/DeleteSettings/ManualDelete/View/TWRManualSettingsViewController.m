//
//  TWRSettingsManualViewController.m
//  Twitteroid
//
//  Created by Andrey Kravchenko on 7/28/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRManualSettingsViewController.h"
#import "TWRCoreDataDAO.h"

@interface TWRManualSettingsViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *manualDatePicker;

@end

@implementation TWRManualSettingsViewController

- (IBAction)deleteNowClicked:(id)sender {
    [self.eventHandler handleDeleteNowAction];
}

- (void)showDeleteAlertWithTitle:(NSString *)title message:(NSString *)message {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.eventHandler handleDeleteConfirmationActionWithDate:self.manualDatePicker.date];
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];

    [self presentViewController:alert animated:YES completion:nil];
}

@end
