//
//  TWRLoginInteractor.m
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/28/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import "TWRLoginInteractor.h"
#import "TWRTwitterAPIManager+TWRLogin.h"

@interface TWRLoginInteractor()

@property (strong, nonatomic) TWRTwitterAPIManager *twitterAPIManager;

@end

@implementation TWRLoginInteractor

- (instancetype)initWithTwitterAPIManager:(TWRTwitterAPIManager *)twitterAPIManager
{
    self = [super init];
    if (self) {
        _twitterAPIManager = twitterAPIManager;
    }
    return self;
}

#pragma mark - TWRLoginInteractorProtocol

- (void)performRelogin {
    __typeof(self) __weak weakSelf = self;
    
    if ([self.twitterAPIManager isUserAlreadyLogged]) {
        [self.twitterAPIManager reloginWithCompletion:^(NSError *error) {
            if (error != nil) {
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

    [self.twitterAPIManager loginWithOpenRequestBlock:^(NSURLRequest *request) {
        [weakSelf.presenter presentWebLoginScreenWithRequest:request];
    } completion:^(NSError *error) {
        if (error != nil) {
            [weakSelf.twitterAPIManager fillUserProfile];
            [weakSelf.presenter loginSuccess];
        }
        else {
            [weakSelf.presenter loginDidFailWithError:error];
        }
    }];
}

@end
