//
//  TWRLoginWebVC.m
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRLoginWebVC.h"
#import "TWRLoginManager.h"

@interface TWRLoginWebVC () <UIWebViewDelegate>

@end

@implementation TWRLoginWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (NSString *)identifier {
    return @"TWRLoginWebVC";
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@", request.URL.absoluteString);
    if ([request.URL.absoluteString containsString:@"myapp.here.com"]) {
        
        NSDictionary *d = [self parametersDictionaryFromQueryString:[request.URL query]];
        
        NSString *token = d[@"oauth_token"];
        NSString *verifier = d[@"oauth_verifier"];
        [[TWRLoginManager sharedInstance] setOAuthToken:token oauthVerifier:verifier];
        
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
