//
//  TWRLoginViewModel.m
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/27/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import "TWRLoginViewModel.h"
#import "TWRTwitterAPIManager+TWRLogin.h"

@implementation TWRLoginViewModel

- (void)reloginWithCompletion:(void (^)(BOOL userWasLoggedPreviously, NSError *error))completion {
    if ([[TWRTwitterAPIManager sharedInstance] isUserAlreadyLogged]) {
        [[TWRTwitterAPIManager sharedInstance] reloginWithCompletion:^(NSError *error) {
            completion(YES, error);
        }];
    }
    else {
        completion(NO, nil);
    }
}

- (void)loginWithWebRequestHandler:(void (^)(NSURLRequest *request))requestHandler completion:(void (^)(NSError *error))completion {
    [[TWRTwitterAPIManager sharedInstance] loginWithOpenRequestBlock:requestHandler completion:^(NSError *error) {
        if (!error) {
            [[TWRTwitterAPIManager sharedInstance] fillUserProfile];
        }
        completion(error);
    }];
}

@end
