//
//  TWRSettingsInteractor.m
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/13/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import "TWRSettingsInteractor.h"
#import "TWRTwitterLoginServiceProtocol.h"
#import "TWRUserProfileStorage.h"
#import "TWRUserProfile.h"

@interface TWRSettingsInteractor()

@property (strong, nonatomic) id<TWRTwitterLoginServiceProtocol> loginService;
@property (strong, nonatomic) TWRUserProfileStorage *userProfileStorage;

@end

@implementation TWRSettingsInteractor

- (instancetype)initWithLoginService:(id<TWRTwitterLoginServiceProtocol>)loginService userProfileStorage:(TWRUserProfileStorage *)userProfileStorage
{
    self = [super init];
    if (self) {
        _loginService = loginService;
        _userProfileStorage = userProfileStorage;
    }
    return self;
}

#pragma mark - TWRSettingsInteractorProtocol

- (void)retrieveUserProfileInfo {
    if ([self.userProfileStorage userName] == nil) {

        [self.presenter retrieveUserProfileDidStartAsync];

        __typeof(self) __weak weakSelf = self;
        [self.loginService getLoggedUserInfoWithCompletion:^(NSError *error, NSDictionary *profile) {
            [weakSelf.userProfileStorage setUserName:profile[@"name"]];
            [weakSelf.userProfileStorage setUserNickname:profile[@"screen_name"]];

            [weakSelf.userProfileStorage setUserAvatarByURL:[NSURL URLWithString:profile[@"profile_image_url"]] completion:^(NSError *error) {
                [weakSelf.presenter retrieveUserProfileDidLoad:[weakSelf userProfileFromStorage]];
            }];
        }];
    }
    else {
        [self.presenter retrieveUserProfileDidLoad:[self userProfileFromStorage]];
    }
}

- (TWRUserProfile *)userProfileFromStorage {
    TWRUserProfile *userProfile = [TWRUserProfile new];
    userProfile.userName = self.userProfileStorage.userName;
    userProfile.userNickname = self.userProfileStorage.userNickname;
    userProfile.userAvatar = self.userProfileStorage.userAvatar;

    return userProfile;
}

@end
