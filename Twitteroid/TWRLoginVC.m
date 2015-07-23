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

    __block TWRLoginWebVC *webVC = nil;
    
    [[TWRLoginManager sharedInstance] loginWithOpenRequestBlock:^(NSURLRequest *request) {

        webVC = [self.storyboard instantiateViewControllerWithIdentifier:[TWRLoginWebVC identifier]];
        [self presentViewController:webVC animated:YES completion:^{
            [webVC.webView loadRequest:request];
        }];
        
    } completion:^(NSError *error) {
        if (webVC) {
            [webVC dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

@end
