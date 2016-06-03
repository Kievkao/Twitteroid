//
//  TWRAutoDeleteSettingsWireframe.m
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/2/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import "TWRAutoSettingsWireframe.h"
#import "TWRAutoSettingsViewController.h"
#import "TWRAutoSettingsPresenter.h"
#import "TWRAutoSettingsInteractor.h"

#import "TWRCoreDataDAO.h"

@interface TWRAutoSettingsWireframe()

@property (weak, nonatomic) TWRAutoSettingsViewController *autoSettingsViewController;

@end

@implementation TWRAutoSettingsWireframe

- (void)presentSettingsScreenFromViewController:(UIViewController*)viewController {
    self.autoSettingsViewController = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"AutoSettingsVC"];

    TWRAutoSettingsPresenter* presenter = [TWRAutoSettingsPresenter new];

    presenter.wireframe = self;
    presenter.view = self.autoSettingsViewController;

    TWRAutoSettingsInteractor *interactor = [[TWRAutoSettingsInteractor alloc] initWithCoreDataDAO:[TWRCoreDataDAO sharedInstance]];
    interactor.presenter = presenter;
    presenter.interactor = interactor;

    self.autoSettingsViewController.eventHandler = presenter;

    [viewController.navigationController pushViewController:self.autoSettingsViewController animated:YES];
}

- (void)dismissSettingsScreen {
    [self.autoSettingsViewController.navigationController popViewControllerAnimated:YES];
}

@end
