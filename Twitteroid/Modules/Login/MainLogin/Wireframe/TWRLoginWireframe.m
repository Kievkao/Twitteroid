//
//  TWRLoginWireframe.m
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/28/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import "TWRLoginWireframe.h"
#import "TWRFeedWireframe.h"
#import "TWRLoginWebWireframe.h"

#import "TWRLoginInteractor.h"
#import "TWRLoginPresenter.h"
#import "TWRLoginViewController.h"

#import "TWRTwitterManager.h"

@interface TWRLoginWireframe()

@property (weak, nonatomic) TWRLoginViewController *loginViewController;
@property (strong, nonatomic) TWRLoginWebWireframe *webLoginWireframe;
@property (strong, nonatomic) TWRFeedWireframe *feedWireframe;

@end

@implementation TWRLoginWireframe

- (void)presentLoginScreenFromViewController:(UIViewController*)viewController
{
    self.loginViewController = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"loginVC"];

    TWRLoginInteractor* interactor = [[TWRLoginInteractor alloc] initWithTwitterAPIManager:[TWRTwitterManager sharedInstance]];
    TWRLoginPresenter* presenter = [TWRLoginPresenter new];

    presenter.wireframe = self;
    presenter.interactor = interactor;
    presenter.view = self.loginViewController;

    interactor.presenter = presenter;
    self.loginViewController.eventHandler = presenter;

    [viewController presentViewController:self.loginViewController animated:YES completion:nil];
}

- (UIViewController *)createLoginViewController
{
    self.loginViewController = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"loginVC"];

    TWRLoginInteractor* interactor = [[TWRLoginInteractor alloc] initWithTwitterAPIManager:[TWRTwitterManager sharedInstance]];
    TWRLoginPresenter* presenter = [TWRLoginPresenter new];

    presenter.wireframe = self;
    presenter.interactor = interactor;
    presenter.view = self.loginViewController;

    interactor.presenter = presenter;
    self.loginViewController.eventHandler = presenter;

    return self.loginViewController;
}

- (void)presentFeedScreen {
    self.feedWireframe = [TWRFeedWireframe new];
    [self.feedWireframe setFeedScreenInsteadViewController:self.loginViewController withHashtag:nil];
}

- (void)presentWebLoginScreenWithRequest:(NSURLRequest *)request {
    self.webLoginWireframe = [TWRLoginWebWireframe new];
    [self.webLoginWireframe presentLoginWebScreenFromViewController:self.loginViewController withURLRequest:request];
}

- (void)dismissWebLoginScreen {
    [self.webLoginWireframe dismissLoginWebScreen];
}

@end
