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

#import "STTwitterAPI.h"
#import "TWRTwitterLoginServiceProtocol.h"

@interface TWRLoginWireframe()

@property (weak, nonatomic) TWRLoginViewController *loginViewController;

@property (strong, nonatomic) TWRLoginWebWireframe *webLoginWireframe;
@property (strong, nonatomic) TWRFeedWireframe *feedWireframe;

@property (strong, nonatomic) STTwitterAPI *twitterAPI;
@property (strong, nonatomic) id<TWRTwitterLoginServiceProtocol> loginService;

@end

@implementation TWRLoginWireframe

- (UIViewController *)createLoginViewController
{
    self.loginViewController = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:[TWRLoginViewController identifier]];

    TWRLoginInteractor* interactor = [[TWRLoginInteractor alloc] initWithLoginService:self.loginService];
    TWRLoginPresenter* presenter = [TWRLoginPresenter new];

    presenter.wireframe = self;
    presenter.interactor = interactor;
    presenter.view = self.loginViewController;

    interactor.presenter = presenter;
    self.loginViewController.eventHandler = presenter;

    return self.loginViewController;
}

- (void)presentFeedScreen {
    [self.feedWireframe setFeedScreenInsteadViewController:self.loginViewController withHashtag:nil];
}

- (void)processWebLoginWithRequest:(NSURLRequest *)request moduleDelegate:(id<TWRLoginWebModuleDelegate>)moduleDelegate {
    [self.webLoginWireframe presentLoginWebScreenFromViewController:self.loginViewController withURLRequest:request moduleDelegate:moduleDelegate];
}

- (void)dismissWebLoginScreen {
    [self.webLoginWireframe dismissLoginWebScreen];
}

@end
