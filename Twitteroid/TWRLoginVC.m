//
//  TWRLoginVC.m
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRLoginVC.h"
#import "TWRLoginWebVC.h"
#import "TWRLoginManager.h"

@interface TWRLoginVC ()

@end

@implementation TWRLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)loginBtnClicked:(id)sender {

    TWRLoginWebVC *webVC = [self.storyboard instantiateViewControllerWithIdentifier:[TWRLoginWebVC identifier]];
    
    [[TWRLoginManager sharedInstance] loginWithOpenRequestBlock:^(NSURLRequest *request) {

        [self presentViewController:webVC animated:YES completion:^{
            [webVC.webView loadRequest:request];
        }];
        
    } completion:^(NSError *error) {
        [webVC dismissViewControllerAnimated:YES completion:nil];
    }];
}

@end
