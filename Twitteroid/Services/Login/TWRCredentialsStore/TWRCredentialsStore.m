//
//  TWRCredentialsStore.m
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/3/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import "TWRCredentialsStore.h"
#import "SSKeychain.h"

static NSString *const kKeychainAccountKey = @"kievkao.Twitteroid";
static NSString *const kKeychainTokenKey = @"TwitterToken";
static NSString *const kKeychainTokenSecretKey = @"TwitterTokenSecret";

static NSString *const kTwitterApiKey = @"Vtr9Yi3UkWuqqo4sD7WJaYHPp";
static NSString *const kTwitterApiSecret = @"FgJV89KXSGYf42opyMLFfZxk5J9fPIwITzYrKsZWG0xvxh7HdH";

@implementation TWRCredentialsStore

#pragma mark - Twitter Key & Secret
- (NSString *)twitterAPIKey {
    return kTwitterApiKey;
}

- (NSString *)twitterAPISecret {
    return kTwitterApiSecret;
}

#pragma mark - Token
- (NSString *)token {
    return [SSKeychain passwordForService:kKeychainTokenKey account:kKeychainAccountKey];
}

- (void)setToken:(NSString *)token {
    if (token) {
        [SSKeychain setPassword:token forService:kKeychainTokenKey account:kKeychainAccountKey];
    }
    else {
        [SSKeychain deletePasswordForService:kKeychainTokenKey account:kKeychainAccountKey];
    }
}

#pragma mark - Secret
- (NSString *)tokenSecret {
    return [SSKeychain passwordForService:kKeychainTokenSecretKey account:kKeychainAccountKey];
}

- (void)setTokenSecret:(NSString *)tokenSecret {
    if (tokenSecret) {
        [SSKeychain setPassword:tokenSecret forService:kKeychainTokenSecretKey account:kKeychainAccountKey];
    }
    else {
        [SSKeychain deletePasswordForService:kKeychainTokenSecretKey account:kKeychainAccountKey];
    }
}

@end
