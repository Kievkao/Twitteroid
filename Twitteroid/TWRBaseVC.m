//
//  TWRBaseVC.m
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRBaseVC.h"

@interface TWRBaseVC ()

@end

@implementation TWRBaseVC

+ (NSString *)identifier {
    return nil;
}

- (void)showInfoAlertWithTitle:(NSString *)title text:(NSString *)text {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:text preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
