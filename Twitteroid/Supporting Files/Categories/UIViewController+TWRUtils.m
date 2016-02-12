//
//  UIViewController+TWRUtils.m
//  Twitteroid
//
//  Created by Andrii Kravchenko on 2/12/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import "UIViewController+TWRUtils.h"

@implementation UIViewController (TWRUtils)

+ (NSString *)identifier {
    return nil;
}

- (void)showInfoAlertWithTitle:(NSString *)title text:(NSString *)text {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:text preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showSureAlertWithTitle:(NSString *)title text:(NSString *)text okCompletionBlock:(void(^)(UIAlertAction *action))block {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:text preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:block]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
