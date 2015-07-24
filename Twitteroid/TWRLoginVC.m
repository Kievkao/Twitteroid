//
//  TWRLoginVC.m
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRLoginVC.h"
#import "TWRLoginWebVC.h"
#import "TWRFeedVC.h"
#import "TWRTwitterAPIManager+TWRLogin.h"

@interface TWRLoginVC ()

@end

@implementation TWRLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[TWRTwitterAPIManager sharedInstance] isUserAlreadyLogged]) {
        [self openFeedViewController];
    }
}

- (IBAction)loginBtnClicked:(id)sender {
    
    [self peformLogin];
}

- (void)peformLogin {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __block TWRLoginWebVC *webVC = nil;
    
    [[TWRTwitterAPIManager sharedInstance] loginWithOpenRequestBlock:^(NSURLRequest *request) {
        
        webVC = [self.storyboard instantiateViewControllerWithIdentifier:[TWRLoginWebVC identifier]];
        [self presentViewController:webVC animated:YES completion:^{
            [webVC.webView loadRequest:request];
        }];
        
    } completion:^(NSError *error) {
        if (webVC) {
            [webVC dismissViewControllerAnimated:YES completion:nil];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (!error) {
            [self openFeedViewController];
        }
        else {
            [self showInfoAlertWithTitle:NSLocalizedString(@"Error", @"Error title") text:error.localizedDescription];
        }
    }];
}

- (void)openFeedViewController {
    [self.navigationController setViewControllers:@[[self.storyboard instantiateViewControllerWithIdentifier:[TWRFeedVC identifier]]] animated:YES];
}

@end
