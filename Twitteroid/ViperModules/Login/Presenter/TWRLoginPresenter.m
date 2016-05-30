//
//  TWRLoginPresenter.m
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/28/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import "TWRLoginPresenter.h"

@implementation TWRLoginPresenter

#pragma mark - TWRLoginEventHandlerProtocol

- (void)handleViewDidLoad {
    [self.interactor performRelogin];
}

- (void)loginSuccess {
    [self.wireframe dismissWebLoginScreen];
    [self.view setProgressIndicatorVisible:NO];
    [self.wireframe presentFeedScreen];
}

- (void)loginDidFailWithError:(NSError *)error {
    [self.wireframe dismissWebLoginScreen];
    [self.view setProgressIndicatorVisible:NO];
    [self.view showAlertWithTitle:NSLocalizedString(@"Login Error", @"Error title") message:error.localizedDescription];
}

- (void)presentWebLoginScreenWithRequest:(NSURLRequest *)request {
    [self.wireframe presentWebLoginScreenWithRequest:request];
}

- (void)handleLoginClicked {
    [self.view setProgressIndicatorVisible:YES];
    [self.interactor performLogin];
}

@end
