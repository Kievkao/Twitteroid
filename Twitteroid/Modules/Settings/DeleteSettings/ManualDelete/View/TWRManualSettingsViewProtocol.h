//
//  TWRManualSettingsViewProtocol.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/2/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TWRManualSettingsViewProtocol <NSObject>

- (void)showAlertWithTitle:(NSString * _Nullable)title message:(NSString *)message;
- (void)showDeleteAlertWithTitle:(NSString * _Nullable)title message:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
