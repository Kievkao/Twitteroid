//
//  TWRTwitterAPIManager.m
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

// TODO: embed parsing and separate class
+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
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

@end
