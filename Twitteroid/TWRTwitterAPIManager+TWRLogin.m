//
//  TWRTwitterAPIManager+TWRLogin.m
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRTwitterAPIManager+TWRLogin.h"
#import "TWRTwitterAPIManager.h"
#import "STTwitter.h"
#import "TWRUserProfile.h"

@implementation TWRTwitterAPIManager (TWRLogin)

- (BOOL)isUserAlreadyLogged {
    return (self.token && self.tokenSecret);
}

- (void)loginWithOpenRequestBlock:(void (^)(NSURLRequest *request))requestBlock completion:(void (^)(NSError *error))completion {
    
    if (self.token && self.tokenSecret) {
        [self reloginWithOpenRequestBlock:requestBlock completion:completion];
    }
    else {
        [self initialLoginWithOpenRequestBlock:requestBlock completion:completion];
    }
}

- (void)reloginWithCompletion:(void (^)(NSError *error))completion {
    
    self.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:kTwitterApiKey consumerSecret:kTwitterApiSecret oauthToken:self.token oauthTokenSecret:self.tokenSecret];
    [self.twitter verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
        self.sessionLoginDone = YES;
        completion(nil);

    } errorBlock:^(NSError *error) {
        self.token = nil;
        self.tokenSecret = nil;
        self.sessionLoginDone = NO;
        completion(error);
    }];
}

- (void)reloginWithOpenRequestBlock:(void (^)(NSURLRequest *request))requestBlock completion:(void (^)(NSError *error))completion {
    
    self.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:kTwitterApiKey consumerSecret:kTwitterApiSecret oauthToken:self.token oauthTokenSecret:self.tokenSecret];
    
    [self.twitter verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
        completion(nil);
        self.sessionLoginDone = YES;
        
    } errorBlock:^(NSError *error) {
        self.token = nil;
        self.tokenSecret = nil;
        self.sessionLoginDone = NO;
        
        [self initialLoginWithOpenRequestBlock:requestBlock completion:completion];
    }];
}

- (void)initialLoginWithOpenRequestBlock:(void (^)(NSURLRequest *request))requestBlock completion:(void (^)(NSError *error))completion {
    
    self.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:kTwitterApiKey consumerSecret:kTwitterApiSecret];
    
    self.loginCompletion = completion;
    
    [self.twitter postTokenRequest:^(NSURL *url, NSString *oauthToken) {
        requestBlock([NSURLRequest requestWithURL:url]);
        
    } authenticateInsteadOfAuthorize:NO forceLogin:@(YES) screenName:nil oauthCallback:@"myapp.here.com" errorBlock:^(NSError *error) {
        completion(error);
    }];
}

- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier {
    
    __weak typeof(self) weakSelf = self;
    
    [self.twitter postAccessTokenRequestWithPIN:verifier successBlock:^(NSString *oauthToken, NSString *oauthTokenSecret, NSString *userID, NSString *screenName) {
        
        [[TWRUserProfile sharedInstance] setUserID:userID];
        [[TWRUserProfile sharedInstance] setUserNickname:screenName];
        
        weakSelf.token = oauthToken;
        weakSelf.tokenSecret = oauthTokenSecret;
        weakSelf.sessionLoginDone = YES;
        weakSelf.loginCompletion(nil);
        
    } errorBlock:^(NSError *error) {
        weakSelf.loginCompletion(error);
    }];
}

- (BOOL)isSessionLoginDone {
    return self.sessionLoginDone;
}

@end
