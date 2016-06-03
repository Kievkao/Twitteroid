//
//  TWRLoginVC.m
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRLoginViewController.h"
#import "RQShineLabel.h"

@interface TWRLoginViewController ()

@property (weak, nonatomic) IBOutlet RQShineLabel *welcomeShineLabel;

@end

@implementation TWRLoginViewController

#pragma mark - ViewController lifecycle

+ (NSString *)identifier {
    return @"loginVC";
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.eventHandler handleViewDidLoad];
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

#pragma mark - TWRLoginViewProtocol

- (void)setProgressIndicatorVisible:(BOOL)visible {
    if (visible) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    else {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}

- (void)showAlertWithTitle:(NSString*)title message:(NSString*)message {
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* alertAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"Alert button title") style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:alertAction];

    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Actions

- (IBAction)loginBtnClicked:(id)sender {
    [self.eventHandler handleLoginClicked];
}

@end
