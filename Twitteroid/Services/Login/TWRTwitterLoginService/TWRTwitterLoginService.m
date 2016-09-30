//
//  TWRTwitterLoginService.m
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/3/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import "TWRTwitterLoginService.h"
#import "STTwitterAPI.h"
#import "TWRCredentialsStore.h"

@interface TWRTwitterLoginService()

@property (strong, nonatomic) STTwitterAPI *twitterAPI;
@property (strong, nonatomic) TWRCredentialsStore *credentialsStore;

@property (nonatomic) BOOL sessionLoginDone;

@end

@implementation TWRTwitterLoginService

#pragma mark - Login

- (void)initialLoginWithOpenRequestBlock:(void (^)(NSURLRequest *request))requestBlock completion:(void (^)(NSError *error))completion {

    [self.twitterAPI postTokenRequest:^(NSURL *url, NSString *oauthToken) {
        requestBlock([NSURLRequest requestWithURL:url]);

    } authenticateInsteadOfAuthorize:NO forceLogin:@(YES) screenName:nil oauthCallback:@"myapp.here.com" errorBlock:^(NSError *error) {
        completion(error);
    }];
}

- (void)loginWithOpenRequestBlock:(void (^)(NSURLRequest *request))requestBlock completion:(void (^)(NSError *error))completion {
    if ([self.credentialsStore token] && [self.credentialsStore tokenSecret]) {
        [self reloginWithOpenRequestBlock:requestBlock completion:completion];
    }
    else {
        [self initialLoginWithOpenRequestBlock:requestBlock completion:completion];
    }
}

- (void)reloginWithCompletion:(void (^)(NSError *error))completion {
    __typeof(self) __weak weakSelf = self;
    
    [self.twitterAPI verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
        weakSelf.sessionLoginDone = YES;
        completion(nil);

    } errorBlock:^(NSError *error) {
        [weakSelf resetKeychain];
        weakSelf.sessionLoginDone = NO;
        completion(error);
    }];
}

- (void)reloginWithOpenRequestBlock:(void (^)(NSURLRequest *request))requestBlock completion:(void (^)(NSError *error))completion {
    __typeof(self) __weak weakSelf = self;
    
    [self.twitterAPI verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
        completion(nil);
        weakSelf.sessionLoginDone = YES;

    } errorBlock:^(NSError *error) {
        [weakSelf resetKeychain];
        weakSelf.sessionLoginDone = NO;

        [weakSelf initialLoginWithOpenRequestBlock:requestBlock completion:completion];
    }];
}

- (void)sendOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier completion:(void (^)(NSError *error))completion {
    __weak typeof(self) weakSelf = self;
    
    [self.twitterAPI postAccessTokenRequestWithPIN:verifier successBlock:^(NSString *oauthToken, NSString *oauthTokenSecret, NSString *userID, NSString *screenName) {

        [weakSelf.credentialsStore setToken:oauthToken];
        [weakSelf.credentialsStore setTokenSecret:oauthTokenSecret];
        weakSelf.sessionLoginDone = YES;

        completion(nil);

    } errorBlock:^(NSError *error) {
        completion(error);
    }];
}

- (void)getLoggedUserInfoWithCompletion:(void (^)(NSError *error, NSDictionary *profile))completion {
    [self.twitterAPI getUsersShowForUserID:[self.twitterAPI userID] orScreenName:nil includeEntities:nil successBlock:^(NSDictionary *user) {
        completion(nil, user);
    } errorBlock:^(NSError *error) {
        completion(error, nil);
    }];
}

- (BOOL)isUserLogged {
    return self.credentialsStore.token && self.credentialsStore.tokenSecret;
}

- (void)resetKeychain {
    [self.credentialsStore setToken:nil];
    [self.credentialsStore setTokenSecret:nil];
}

- (BOOL)isSessionLoginDone {
    return self.sessionLoginDone;
}

@end
