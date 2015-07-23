//
//  TWRTwitterAPIManager+TWRLogin.h
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRTwitterAPIManager.h"

@interface TWRTwitterAPIManager (TWRLogin)

- (BOOL)isUserAlreadyLogged;
- (void)loginWithOpenRequestBlock:(void (^)(NSURLRequest *request))requestBlock completion:(void (^)(NSError *error))completion;
- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier;

@end
