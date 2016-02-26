//
//  TWRLoginWebVC.m
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRLoginWebVC.h"
#import "TWRTwitterAPIManager+TWRLogin.h"

@interface TWRLoginWebVC () <UIWebViewDelegate>

@end

@implementation TWRLoginWebVC

+ (NSString *)identifier {
    return @"TWRLoginWebVC";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.URL.absoluteString containsString:@"myapp.here.com"]) {
        
        NSDictionary *oauthResponseDict = [self parametersDictionaryFromQueryString:[request.URL query]];
        
        NSString *token = oauthResponseDict[@"oauth_token"];
        NSString *verifier = oauthResponseDict[@"oauth_verifier"];
        [[TWRTwitterAPIManager sharedInstance] setOAuthToken:token oauthVerifier:verifier];
        
        return NO;
    }
    else {
        return YES;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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

- (IBAction)cancelClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
