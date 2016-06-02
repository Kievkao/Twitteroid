//
//  TWRLoginWebInteractor.m
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/30/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import "TWRLoginWebInteractor.h"
#import "TWRTwitterManager+TWRLogin.h"

@interface TWRLoginWebInteractor()

@property (strong, nonatomic) TWRTwitterManager *twitterAPIManager;

@end

@implementation TWRLoginWebInteractor

- (instancetype)initWithTwitterAPIManager:(TWRTwitterManager *)twitterAPIManager
{
    self = [super init];
    if (self) {
        _twitterAPIManager = twitterAPIManager;
    }
    return self;
}

- (BOOL)shouldStartLoadRequest:(NSURLRequest *)request {
    if ([request.URL.absoluteString containsString:@"myapp.here.com"]) {

        NSDictionary *oauthResponseDict = [self parametersDictionaryFromQueryString:[request.URL query]];

        NSString *token = oauthResponseDict[@"oauth_token"];
        NSString *verifier = oauthResponseDict[@"oauth_verifier"];
        [self.twitterAPIManager setOAuthToken:token oauthVerifier:verifier];

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
