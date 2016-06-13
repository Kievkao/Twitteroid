//
//  TWRLoginInteractor.m
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/28/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import "TWRLoginInteractor.h"
#import "TWRTwitterLoginServiceProtocol.h"

@interface TWRLoginInteractor()

@property (strong, nonatomic) id<TWRTwitterLoginServiceProtocol> loginService;

@end

@implementation TWRLoginInteractor

- (instancetype)initWithLoginService:(id<TWRTwitterLoginServiceProtocol>)loginService
{
    self = [super init];
    if (self) {
        _loginService = loginService;
    }
    return self;
}

#pragma mark - TWRLoginInteractorProtocol

- (void)performRelogin {
    __typeof(self) __weak weakSelf = self;
    
    if ([self.loginService isUserLogged]) {
        [self.presenter reloginDidStart];

        [self.loginService reloginWithCompletion:^(NSError *error) {
            if (error == nil) {
                [weakSelf.presenter loginSuccess];
            }
            else {
                [weakSelf.presenter loginDidFailWithError:error];
            }
        }];
    }
}

- (void)performLogin {
    __typeof(self) __weak weakSelf = self;

    [self.loginService loginWithOpenRequestBlock:^(NSURLRequest *request) {
        [weakSelf.presenter processWebLoginWithRequest:request];
    } completion:^(NSError *error) {
        if (error == nil) {
            [weakSelf.presenter loginSuccess];
        }
        else {
            [weakSelf.presenter loginDidFailWithError:error];
        }
    }];
}

@end
