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
#import "TWRTwitterAPIManager.h"

@interface TWRLoginWebWireframe()

@property (weak, nonatomic) TWRLoginWebViewController *loginWebViewController;

@end

@implementation TWRLoginWebWireframe

- (void)presentLoginWebScreenFromViewController:(UIViewController*)viewController withURLRequest:(NSURLRequest *)request
{
    self.loginWebViewController = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:[TWRLoginWebViewController identifier]];

    TWRLoginWebInteractor* interactor = [[TWRLoginWebInteractor alloc] initWithTwitterAPIManager:[TWRTwitterAPIManager sharedInstance]];
    TWRLoginWebPresenter* presenter = [[TWRLoginWebPresenter alloc] initWithURLRequest:request];

    presenter.wireframe = self;
    presenter.interactor = interactor;
    presenter.view = self.loginWebViewController;

    interactor.presenter = presenter;
    self.loginWebViewController.eventHandler = presenter;

    [viewController presentViewController:self.loginWebViewController animated:YES completion:nil];
}

- (void)dismissLoginWebScreen {
    [self.loginWebViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
