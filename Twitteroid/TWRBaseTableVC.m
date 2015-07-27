//
//  TWRBaseTableVC.m
//  Twitteroid
//
//  Created by Andrey Kravchenko on 7/27/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRBaseTableVC.h"

@interface TWRBaseTableVC ()

@end

@implementation TWRBaseTableVC

+ (NSString *)identifier {
    return nil;
}

- (void)showInfoAlertWithTitle:(NSString *)title text:(NSString *)text {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:text preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
