//
//  TWRSettingsWireframe.m
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/2/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import "TWRSettingsWireframe.h"
#import "TWRSettingsViewController.h"
#import "TWRSettingsPresenter.h"

#import "TWRSettingsAutoVC.h"
#import "TWRSettingsManualVC.h"

#import "TWRUserProfile.h"

@interface TWRSettingsWireframe()

@property (weak, nonatomic) TWRSettingsViewController *settingsViewController;

@end

@implementation TWRSettingsWireframe

- (void)presentSettingsScreenFromViewController:(UIViewController*)viewController {

    UINavigationController *settingsNavigationController = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"SettingsNavC"];

    TWRSettingsViewController *settingsViewController = (TWRSettingsViewController *)settingsNavigationController.topViewController;
    settingsViewController.userName = [[TWRUserProfile sharedInstance] userName];
    settingsViewController.userNickname = [NSString stringWithFormat:@"@%@",[[TWRUserProfile sharedInstance] userNickname]];
    settingsViewController.userAvatar = [[TWRUserProfile sharedInstance] userAvatar];

    TWRSettingsPresenter* presenter = [TWRSettingsPresenter new];

    presenter.wireframe = self;
    presenter.view = settingsViewController;

    settingsViewController.eventHandler = presenter;
    self.settingsViewController = settingsViewController;

    [viewController presentViewController:settingsNavigationController animated:YES completion:nil];
}

- (void)dismissSettingsScreen {
    [self.settingsViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)presentAutoSettingsScreen {
    TWRSettingsAutoVC *autoSettingsViewController = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"AutoSettingsVC"];
    [self.settingsViewController.navigationController pushViewController:autoSettingsViewController animated:YES];
}

- (void)presentManualSettingsScreen {
    TWRSettingsManualVC *manualSettingsViewController = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"manualSettings"];
    [self.settingsViewController.navigationController pushViewController:manualSettingsViewController animated:YES];
}

@end
