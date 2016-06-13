//
//  TWRLoginPresenter.m
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/28/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import "TWRLoginPresenter.h"
#import "TWRLoginWebModuleDelegate.h"

@interface TWRLoginPresenter() <TWRLoginWebModuleDelegate>

@end

@implementation TWRLoginPresenter

#pragma mark - TWRLoginEventHandlerProtocol

- (void)handleViewDidLoad {
    [self.interactor performRelogin];
}

- (void)handleLoginClicked {
    [self.view setProgressIndicatorVisible:YES];
    [self.interactor performLogin];
}

#pragma mark - TWRLoginWebModuleDelegate

- (void)loginSuccess {
    [self.view setProgressIndicatorVisible:NO];
    [self.wireframe presentFeedScreen];
}

- (void)loginDidFailWithError:(NSError *)error {
    [self.view setProgressIndicatorVisible:NO];
    [self.view showAlertWithTitle:NSLocalizedString(@"Login Error", @"Error title") message:error.localizedDescription];
}

- (void)webLoginDidSuccess {
    [self.wireframe dismissWebLoginScreen];
    [self.view setProgressIndicatorVisible:NO];
    [self.wireframe presentFeedScreen];
}

- (void)webLoginDidFinishWithError:(NSError *)error {
    [self.wireframe dismissWebLoginScreen];
    [self.view setProgressIndicatorVisible:NO];
    [self.view showAlertWithTitle:NSLocalizedString(@"Login Error", @"Error title") message:error.localizedDescription];
}

#pragma mark - TWRLoginPresenterProtocol

- (void)processWebLoginWithRequest:(NSURLRequest *)request {
    [self.wireframe processWebLoginWithRequest:request moduleDelegate:self];
}

- (void)reloginDidStart {
    [self.view setProgressIndicatorVisible:YES];
}

@end
