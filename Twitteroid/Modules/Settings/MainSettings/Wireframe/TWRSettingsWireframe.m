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
#import "TWRSettingsInteractor.h"
#import "TWRUserProfileStorage.h"

#import "TWRManualSettingsWireframe.h"
#import "TWRAutoSettingsWireframe.h"
#import "TWRTwitterLoginServiceProtocol.h"

@interface TWRSettingsWireframe()

@property (weak, nonatomic) TWRSettingsViewController *settingsViewController;

@property (strong, nonatomic) TWRUserProfileStorage *userProfile;
@property (strong, nonatomic) id<TWRTwitterLoginServiceProtocol> loginService;

@end

@implementation TWRSettingsWireframe

- (void)presentSettingsScreenFromViewController:(UIViewController*)viewController {

    UINavigationController *settingsNavigationController = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"SettingsNavC"];

    TWRSettingsViewController *settingsViewController = (TWRSettingsViewController *)settingsNavigationController.topViewController;

    TWRSettingsInteractor *interactor = [[TWRSettingsInteractor alloc] initWithLoginService:self.loginService userProfileStorage:self.userProfile];
    TWRSettingsPresenter* presenter = [TWRSettingsPresenter new];

    presenter.wireframe = self;
    presenter.view = settingsViewController;
    presenter.interactor = interactor;

    interactor.presenter = presenter;

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
