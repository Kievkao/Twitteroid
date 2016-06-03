//
//  TWRTwitterManager.m
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRTwitterAPIManager.h"
#import "SSKeychain.h"
#import "TWRUserProfile.h"

static NSString *const kKeychainAccountKey = @"kievkao.Twitteroid";
static NSString *const kKeychainTokenKey = @"TwitterToken";
static NSString *const kKeychainTokenSecretKey = @"TwitterTokenSecret";

NSString *const kTwitterApiKey = @"Vtr9Yi3UkWuqqo4sD7WJaYHPp";
NSString *const kTwitterApiSecret = @"FgJV89KXSGYf42opyMLFfZxk5J9fPIwITzYrKsZWG0xvxh7HdH";

@interface TWRTwitterAPIManager()

@end

@implementation TWRTwitterAPIManager
@synthesize token = _token, tokenSecret = _tokenSecret;

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)getFeedOlderThatTwitID:(NSString *)twitID
                    forHashtag:(NSString *)hashtag
                         count:(NSUInteger)count
                    completion:(void(^)(NSError *error, NSArray *items))completion {

    if (hashtag) {
        [self.twitter getSearchTweetsWithQuery:hashtag successBlock:^(NSDictionary *searchMetadata, NSArray *statuses) {
            completion(nil, statuses);
        } errorBlock:^(NSError *error) {
            completion(error, nil);
        }];
    }
    else {
        [self.twitter getStatusesHomeTimelineWithCount:[NSString stringWithFormat:@"%lu", (unsigned long)count] sinceID:nil maxID:twitID trimUser:nil excludeReplies:nil contributorDetails:nil includeEntities:nil successBlock:^(NSArray *statuses) {
            completion(nil, statuses);
        } errorBlock:^(NSError *error) {
            completion(error, nil);
        }];
    }
}

- (void)resetKeychain {
    self.token = nil;
    self.tokenSecret = nil;
}

- (void)fillUserProfile {

    if ([[TWRUserProfile sharedInstance] userNickname]) {
        [self.twitter getUserInformationFor:[[TWRUserProfile sharedInstance] userNickname] successBlock:^(NSDictionary *user) {
            [[TWRUserProfile sharedInstance] setUserName:user[@"name"]];
            [[TWRUserProfile sharedInstance] setUserAvatarByURL:[NSURL URLWithString:user[@"profile_image_url"]]];
        } errorBlock:^(NSError *error) {
            NSLog(@"Retrieving profile error");
        }];
    }
    else {
        NSLog(@"User nickname is empty");
    }
}

#pragma mark - Getters, setters
- (NSString *)token {
    if (!_token) {
        _token = [SSKeychain passwordForService:kKeychainTokenKey account:kKeychainAccountKey];
    }
    return _token;
}

- (void)setToken:(NSString *)token {
    _token = token;
    
    if (token) {
        [SSKeychain setPassword:token forService:kKeychainTokenKey account:kKeychainAccountKey];
    }
    else {
        [SSKeychain deletePasswordForService:kKeychainTokenKey account:kKeychainAccountKey];
    }
}

- (NSString *)tokenSecret {
    if (!_tokenSecret) {
        _tokenSecret = [SSKeychain passwordForService:kKeychainTokenSecretKey account:kKeychainAccountKey];
    }
    return _tokenSecret;
}

- (void)setTokenSecret:(NSString *)tokenSecret {
    _tokenSecret = tokenSecret;
    
    if (tokenSecret) {
        [SSKeychain setPassword:tokenSecret forService:kKeychainTokenSecretKey account:kKeychainAccountKey];
    }
    else {
        [SSKeychain deletePasswordForService:kKeychainTokenSecretKey account:kKeychainAccountKey]; 
    }
}

#pragma mark - Login

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
        [[TWRUserProfile sharedInstance] setUserID:userID];
        [[TWRUserProfile sharedInstance] setUserNickname:username];
        [[TWRTwitterAPIManager sharedInstance] fillUserProfile];
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
