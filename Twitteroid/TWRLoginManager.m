//
//  TWRLoginManager.m
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRLoginManager.h"
#import "STTwitter.h"

static NSString *const twitterApiKey = @"Vtr9Yi3UkWuqqo4sD7WJaYHPp";
static NSString *const twitterApiSecret = @"FgJV89KXSGYf42opyMLFfZxk5J9fPIwITzYrKsZWG0xvxh7HdH";

@interface TWRLoginManager()

@property (nonatomic, strong) STTwitterAPI *twitter;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *verifier;
@property (nonatomic, strong) void (^loginCompletion)(NSError *error);

@end

@implementation TWRLoginManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static TWRLoginManager *sharedInstance;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        if (sharedInstance) {
            sharedInstance.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:twitterApiKey consumerSecret:twitterApiSecret];
        }
    });
    return sharedInstance;
}

- (void)loginWithOpenRequestBlock:(void (^)(NSURLRequest *request))requestBlock completion:(void (^)(NSError *error))completion {
    
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

- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier {
    
    self.token = token;
    self.verifier = verifier;
    __weak typeof(self) weakSelf = self;
    
    [self.twitter postAccessTokenRequestWithPIN:verifier successBlock:^(NSString *oauthToken, NSString *oauthTokenSecret, NSString *userID, NSString *screenName) {
        weakSelf.loginCompletion(nil);
        
    } errorBlock:^(NSError *error) {
        weakSelf.loginCompletion(error);
    }];
}

@end
