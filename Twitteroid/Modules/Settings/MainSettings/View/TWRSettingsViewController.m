//
//  TWRSettingsVC.m
//  Twitteroid
//
//  Created by Andrey Kravchenko on 7/28/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRSettingsViewController.h"
#import "BHRRoundedImageView.h"

typedef enum : NSUInteger {
    TWRManualSettingsSection,
    TWRAutoSettingsSection
} TWRSettingsSection;

@interface TWRSettingsViewController ()

@property (weak, nonatomic) IBOutlet BHRRoundedImageView *userAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNicknameLabel;

@end

@implementation TWRSettingsViewController

+ (NSString *)identifier {
    return @"SettingsNavC";
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.eventHandler handleViewDidLoad];
}

#pragma mark - TWRSettingsViewProtocol

- (void)setUserName:(NSString *)userName {
    self.userNameLabel.text = userName;
}

- (void)setUserNickname:(NSString *)nickname {
    self.userNicknameLabel.text = [NSString stringWithFormat:@"@%@", nickname];
}

- (void)setUserAvatar:(UIImage *)avatar {
    self.userAvatarImageView.image = avatar;
}

- (void)setProgressIndicatorVisible:(BOOL)visible {
    if (visible) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    else {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* alertAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"Alert button title") style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:alertAction];

    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Actions

- (IBAction)doneClicked:(id)sender {
    [self.eventHandler handleDoneAction];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case TWRManualSettingsSection:
            [self.eventHandler handleManualSettingsAction];
            break;

        case TWRAutoSettingsSection:
            [self.eventHandler handleAutoSettingsAction];
            break;

        default:
            break;
    }
}

@end
