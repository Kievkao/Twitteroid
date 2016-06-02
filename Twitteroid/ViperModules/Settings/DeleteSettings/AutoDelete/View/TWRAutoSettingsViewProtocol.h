//
//  TWRAutoSettingsViewProtocol.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/2/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TWRAutoSettingsViewProtocol <NSObject>

- (void)setWeeksNumber:(NSUInteger)weeksNumber;

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;
- (void)showApplyRuleAlertWithTitle:(NSString *)title message:(NSString *)message;

@end
