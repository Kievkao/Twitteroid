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
#import "STTwitterAPI.h"
#import "TWRTwitterLoginService.h"
#import "TWRCredentialsStore.h"

@interface TWRLoginWebWireframe()

@property (weak, nonatomic) TWRLoginWebViewController *loginWebViewController;
@property (weak, nonatomic) id<TWRLoginWebModuleDelegate> moduleDelegate;

@property (strong, nonatomic) STTwitterAPI *twitterAPI;

@end

@implementation TWRLoginWebWireframe

- (instancetype)initWithTwitterAPI:(STTwitterAPI *)twitterAPI
{
    self = [super init];
    if (self) {
        _twitterAPI = twitterAPI;
    }
    return self;
}

- (void)presentLoginWebScreenFromViewController:(UIViewController*)viewController withURLRequest:(NSURLRequest *)request moduleDelegate:(id<TWRLoginWebModuleDelegate>)moduleDelegate {

    self.loginWebViewController = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:[TWRLoginWebViewController identifier]];

    self.moduleDelegate = moduleDelegate;

    TWRLoginWebPresenter* presenter = [[TWRLoginWebPresenter alloc] initWithURLRequest:request];

    TWRLoginWebInteractor* interactor = [[TWRLoginWebInteractor alloc] initWithLoginService:[[TWRTwitterLoginService alloc] initWithTwitterAPI:self.twitterAPI credentialsStore:[TWRCredentialsStore new]]];

    presenter.wireframe = self;
    presenter.interactor = interactor;
    presenter.view = self.loginWebViewController;

    interactor.presenter = presenter;

    self.loginWebViewController.eventHandler = presenter;

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
