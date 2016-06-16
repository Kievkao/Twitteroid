//
//  TWRTwitterLoginServiceProtocol.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/3/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TWRTwitterLoginServiceProtocol <NSObject>

- (void)loginWithOpenRequestBlock:(void (^)(NSURLRequest *request))requestBlock completion:(void (^)(NSError *error))completion;
- (void)reloginWithCompletion:(void (^)(NSError *error))completion;
- (void)sendOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier completion:(void (^)(NSError *error))completion;

- (BOOL)isUserLogged;

- (void)getLoggedUserInfoWithCompletion:(void (^)(NSError *error, NSDictionary *profile))completion;

@end
