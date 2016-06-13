//
//  TWRLoginWebVC.m
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRLoginWebViewController.h"

@interface TWRLoginWebViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation TWRLoginWebViewController

+ (NSString *)identifier {
    return @"TWRLoginWebViewController";
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.eventHandler handleViewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return [self.eventHandler shouldStartLoadRequest:request];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - TWRLoginWebViewProtocol

- (void)loadURLRequest:(NSURLRequest *)request {
    [self.webView loadRequest:request];
}

#pragma mark - Actions

- (IBAction)cancelClicked:(id)sender {
    [self.eventHandler handleCancelAction];    
}

@end
