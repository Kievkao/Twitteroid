//
//  TWRLoginWebInteractor.m
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/30/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import "TWRLoginWebInteractor.h"
#import "TWRTwitterLoginServiceProtocol.h"

@interface TWRLoginWebInteractor()

@property (strong, nonatomic) id<TWRTwitterLoginServiceProtocol> loginService;

@end

@implementation TWRLoginWebInteractor

- (instancetype)initWithLoginService:(id<TWRTwitterLoginServiceProtocol>)loginService
{
    self = [super init];
    if (self) {
        _loginService = loginService;
    }
    return self;
}

- (BOOL)shouldStartLoadRequest:(NSURLRequest *)request {
    if ([request.URL.absoluteString containsString:@"myapp.here.com"]) {

        NSDictionary *oauthResponseDict = [self parametersDictionaryFromQueryString:[request.URL query]];

        NSString *token = oauthResponseDict[@"oauth_token"];
        NSString *verifier = oauthResponseDict[@"oauth_verifier"];

        __typeof(self) __weak weakSelf = self;
        [self.loginService sendOAuthToken:token oauthVerifier:verifier completion:^(NSError *error) {
            if (error == nil) {
                [weakSelf.presenter webLoginDidSuccess];
            }
            else {
                [weakSelf.presenter webLoginDidFinishWithError:error];
            }
        }];

        return NO;
    }
    else {
        return YES;
    }
}

- (NSDictionary *)parametersDictionaryFromQueryString:(NSString *)queryString {
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    NSArray *queryComponents = [queryString componentsSeparatedByString:@"&"];

    for(NSString *s in queryComponents) {
        NSArray *pair = [s componentsSeparatedByString:@"="];
        if([pair count] != 2) continue;

        NSString *key = pair[0];
        NSString *value = pair[1];

        md[key] = value;
    }

    return md;
}

@end
