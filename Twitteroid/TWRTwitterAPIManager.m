//
//  TWRTwitterAPIManager.m
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRTwitterAPIManager.h"
#import "STTwitter.h"
#import "SSKeychain.h"

static NSString *const kKeychainAccountKey = @"kievkao.Twitteroid";
static NSString *const kKeychainTokenKey = @"TwitterToken";
static NSString *const kKeychainTokenSecretKey = @"TwitterTokenSecret";

NSString *const kTwitterApiKey = @"Vtr9Yi3UkWuqqo4sD7WJaYHPp";
NSString *const kTwitterApiSecret = @"FgJV89KXSGYf42opyMLFfZxk5J9fPIwITzYrKsZWG0xvxh7HdH";

@interface TWRTwitterAPIManager()

@end

@implementation TWRTwitterAPIManager
@synthesize token = _token, tokenSecret = _tokenSecret;

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSString *)token {
    
    if (!_token) {
        _token = [SSKeychain passwordForService:kKeychainTokenKey account:kKeychainAccountKey];
    }
    return _token;
}

#pragma mark - Getters, setters
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