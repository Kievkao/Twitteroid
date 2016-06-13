//
//  TWRSettingsPresenter.m
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/2/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import "TWRSettingsPresenter.h"
#import "TWRUserProfile.h"

@implementation TWRSettingsPresenter

#pragma mark - TWRSettingsEventHandlerProtocol

- (void)handleViewDidLoad {
    [self.interactor retrieveUserProfileInfo];
}

- (void)handleDoneAction {
    [self.wireframe dismissSettingsScreen];
}

- (void)handleAutoSettingsAction {
    [self.wireframe presentAutoSettingsScreen];
}

- (void)handleManualSettingsAction {
    [self.wireframe presentManualSettingsScreen];
}

#pragma mark - TWRSettingsPresenterProtocol

- (void)retrieveUserProfileDidLoad:(TWRUserProfile *)userProfile {
    [self.view setProgressIndicatorVisible:NO];

    [self.view setUserName:userProfile.userName];
    [self.view setUserNickname:userProfile.userNickname];
    [self.view setUserAvatar:userProfile.userAvatar];
}

- (void)retrieveUserProfileDidStartAsync {
    [self.view setProgressIndicatorVisible:YES];
}

- (void)retrieveUserProfileDidFinishWithError:(NSError *)error {
    [self.view setProgressIndicatorVisible:NO];
    [self.view showAlertWithTitle:NSLocalizedString(@"Error", @"Error") message:NSLocalizedString(@"Loading user profile error", @"Loading user profile error")];
}

@end
