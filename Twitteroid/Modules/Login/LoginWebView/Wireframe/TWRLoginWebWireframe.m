//
//  TWRLoginWebWireframe.m
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/30/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import "TWRLoginWebWireframe.h"

#import "TWRLoginWebInteractor.h"
#import "TWRLoginWebPresenter.h"
#import "TWRLoginWebViewController.h"
#import "TWRCredentialsStore.h"
#import "TWRTwitterLoginService.h"

@interface TWRLoginWebWireframe()

@property (weak, nonatomic) TWRLoginWebViewController *loginWebViewController;
@property (weak, nonatomic) id<TWRLoginWebModuleDelegate> moduleDelegate;
@property (strong, nonatomic) TWRTwitterLoginService *loginService;

@end

@implementation TWRLoginWebWireframe

- (void)presentLoginWebScreenFromViewController:(UIViewController*)viewController withURLRequest:(NSURLRequest *)request moduleDelegate:(id<TWRLoginWebModuleDelegate>)moduleDelegate {

    self.loginWebViewController = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:[TWRLoginWebViewController identifier]];

    TWRLoginWebInteractor* interactor = [[TWRLoginWebInteractor alloc] initWithLoginService:self.loginService];

    TWRLoginWebPresenter* presenter = [[TWRLoginWebPresenter alloc] initWithURLRequest:request];

    presenter.wireframe = self;
    presenter.interactor = interactor;
    presenter.view = self.loginWebViewController;

    interactor.presenter = presenter;

    self.loginWebViewController.eventHandler = presenter;
    self.moduleDelegate = moduleDelegate;

    [viewController presentViewController:self.loginWebViewController animated:YES completion:nil];
}

- (void)notifyLoginSuccess {
    [self.moduleDelegate webLoginDidSuccess];
}

- (void)notifyLoginError:(NSError *)error {
    [self.moduleDelegate webLoginDidFinishWithError:error];
}

- (void)dismissLoginWebScreen {
    [self.loginWebViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
