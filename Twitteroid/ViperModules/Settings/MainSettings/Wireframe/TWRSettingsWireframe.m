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
#import "TWRUserProfile.h"

#import "TWRManualSettingsWireframe.h"
#import "TWRAutoSettingsWireframe.h"

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
    TWRAutoSettingsWireframe *autoSettingsWireframe = [TWRAutoSettingsWireframe new];
    [autoSettingsWireframe presentSettingsScreenFromViewController:self.settingsViewController];
}

- (void)presentManualSettingsScreen {
    TWRManualSettingsWireframe *manualSettingsWireframe = [TWRManualSettingsWireframe new];
    [manualSettingsWireframe presentSettingsScreenFromViewController:self.settingsViewController];
}

@end
