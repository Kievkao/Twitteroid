//
//  TWRManualSettingsViewProtocol.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/2/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TWRManualSettingsViewProtocol <NSObject>

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;
- (void)showDeleteAlertWithTitle:(NSString *)title message:(NSString *)message;

@end
