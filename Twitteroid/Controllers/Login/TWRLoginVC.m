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
#import "TWRLoginViewModel.h"
#import "RQShineLabel.h"

@interface TWRLoginVC ()

@property (weak, nonatomic) IBOutlet RQShineLabel *welcomeShineLabel;

@property (strong, nonatomic) TWRLoginViewModel *loginViewModel;
@end

@implementation TWRLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginViewModel = [TWRLoginViewModel new];
    [self tryToRelogin];
}

- (void)tryToRelogin {
    [self.loginViewModel reloginWithCompletion:^(BOOL userWasLoggedPreviously, NSError *error) {
        if (userWasLoggedPreviously) {
            if (error) {
                [self showInfoAlertWithTitle:NSLocalizedString(@"Login Error", @"Error title") text:error.localizedDescription];
            }
            else {
                [self openFeedViewController];
            }
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.welcomeShineLabel shine];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.navigationController.presentedViewController) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}

- (IBAction)loginBtnClicked:(id)sender {
    [self performLogin];
}

- (void)performLogin {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    TWRLoginWebVC *webVC = [self.storyboard instantiateViewControllerWithIdentifier:[TWRLoginWebVC identifier]];

    __typeof(self) __weak weakSelf = self;
    [self.loginViewModel loginWithWebRequestHandler:^(NSURLRequest *request) {
        [weakSelf presentViewController:webVC animated:YES completion:^{
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
