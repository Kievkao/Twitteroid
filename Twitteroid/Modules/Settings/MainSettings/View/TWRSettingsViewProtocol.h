//
//  TWRSettingsViewProtocol.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/2/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TWRSettingsViewProtocol <NSObject>

- (void)setUserName:(NSString *)userName;
- (void)setUserNickname:(NSString *)nickname;
- (void)setUserAvatar:(UIImage *)avatar;

- (void)setProgressIndicatorVisible:(BOOL)visible;
- (void)showAlertWithTitle:(NSString * _Nullable)title message:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
