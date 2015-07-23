//
//  TWRLoginManager.m
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRLoginManager.h"
#import "STTwitter.h"
#import "SSKeychain.h"

static NSString *const twitterApiKey = @"Vtr9Yi3UkWuqqo4sD7WJaYHPp";
static NSString *const twitterApiSecret = @"FgJV89KXSGYf42opyMLFfZxk5J9fPIwITzYrKsZWG0xvxh7HdH";

@interface TWRLoginManager()

@property (nonatomic, strong) STTwitterAPI *twitter;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *tokenSecret;
@property (nonatomic, strong) void (^loginCompletion)(NSError *error);

@end

@implementation TWRLoginManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)loginWithOpenRequestBlock:(void (^)(NSURLRequest *request))requestBlock completion:(void (^)(NSError *error))completion {

    self.token = [SSKeychain passwordForService:@"TwitterToken" account:@"kievkao.Twitteroid"];
    self.tokenSecret = [SSKeychain passwordForService:@"TwitterVerifier" account:@"kievkao.Twitteroid"];
    
    if (self.token && self.tokenSecret) {
        [self reloginWithOpenRequestBlock:requestBlock completion:completion];
    }
    else {
        [self initialLoginWithOpenRequestBlock:requestBlock completion:completion];
    }
}

- (void)reloginWithOpenRequestBlock:(void (^)(NSURLRequest *request))requestBlock completion:(void (^)(NSError *error))completion {
    
    self.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:twitterApiKey consumerSecret:twitterApiSecret oauthToken:self.token oauthTokenSecret:self.tokenSecret];
    
    [self.twitter verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
        completion(nil);
        
    } errorBlock:^(NSError *error) {
        self.token = nil;
        self.tokenSecret = nil;
        [SSKeychain deletePasswordForService:@"TwitterToken" account:@"kievkao.Twitteroid"];
        [SSKeychain deletePasswordForService:@"TwitterVerifier" account:@"kievkao.Twitteroid"];
        
        [self initialLoginWithOpenRequestBlock:requestBlock completion:completion];
    }];
}

- (void)initialLoginWithOpenRequestBlock:(void (^)(NSURLRequest *request))requestBlock completion:(void (^)(NSError *error))completion {
    
    self.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:twitterApiKey consumerSecret:twitterApiSecret];
    
    self.loginCompletion = completion;
    
    [self.twitter postTokenRequest:^(NSURL *url, NSString *oauthToken) {
        requestBlock([NSURLRequest requestWithURL:url]);
        
    } authenticateInsteadOfAuthorize:NO
                        forceLogin:@(YES)
                        screenName:nil
                     oauthCallback:@"myapp.here.com"
                        errorBlock:^(NSError *error) {
                            NSLog(@"-- error: %@", error);
                        }];
}
// 1108194253-MByxrpahN67nqVkAtSOPixeqgEigsO7tlHyS3Em cdgDgklHuh6im3MODOiHksviLBixfjKOfSNVbj2zlYIB2
- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier {

    __weak typeof(self) weakSelf = self;

    [self.twitter postAccessTokenRequestWithPIN:verifier successBlock:^(NSString *oauthToken, NSString *oauthTokenSecret, NSString *userID, NSString *screenName) {
        weakSelf.token = oauthToken;
        weakSelf.tokenSecret = oauthTokenSecret;
        
        [SSKeychain setPassword:oauthToken forService:@"TwitterToken" account:@"kievkao.Twitteroid"];
        [SSKeychain setPassword:oauthTokenSecret forService:@"TwitterVerifier" account:@"kievkao.Twitteroid"];
        
        weakSelf.loginCompletion(nil);
        
    } errorBlock:^(NSError *error) {
        weakSelf.loginCompletion(error);
    }];
    
}

@end
