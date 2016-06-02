//
//  TWRManualSettingsEventHandlerProtocol.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/2/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TWRManualSettingsEventHandlerProtocol <NSObject>

- (void)handleDeleteNowAction;
- (void)handleDeleteConfirmationActionWithDate:(NSDate *)date;

@end
