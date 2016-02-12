//
//  UIViewController+TWRUtils.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 2/12/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (TWRUtils)

+ (NSString *)identifier;
- (void)showInfoAlertWithTitle:(NSString *)title text:(NSString *)text;
- (void)showSureAlertWithTitle:(NSString *)title text:(NSString *)text okCompletionBlock:(void(^)(UIAlertAction *action))block;

@end
