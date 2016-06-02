//
//  TWRManualDeleteSettingsWireframe.m
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/2/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import "TWRManualSettingsWireframe.h"
#import "TWRManualSettingsViewController.h"
#import "TWRManualSettingsPresenter.h"
#import "TWRManualSettingsInteractor.h"

@interface TWRManualSettingsWireframe()

@property (weak, nonatomic) TWRManualSettingsViewController *manualSettingsViewController;

@end

@implementation TWRManualSettingsWireframe

- (void)presentSettingsScreenFromViewController:(UIViewController*)viewController {
    self.manualSettingsViewController = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"manualSettings"];

    TWRManualSettingsPresenter* presenter = [TWRManualSettingsPresenter new];

    presenter.wireframe = self;
    presenter.view = self.manualSettingsViewController;

    TWRManualSettingsInteractor *interactor = [TWRManualSettingsInteractor new];
    presenter.interactor = interactor;

    self.manualSettingsViewController.eventHandler = presenter;

    [viewController.navigationController pushViewController:self.manualSettingsViewController animated:YES];
}

- (void)dismissSettingsScreen {
    [self.manualSettingsViewController.navigationController popViewControllerAnimated:YES];
}

@end
