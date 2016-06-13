//
//  TWRSettingsEventHandlerProtocol.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/2/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TWRSettingsEventHandlerProtocol <NSObject>

- (void)handleViewDidLoad;
- (void)handleDoneAction;
- (void)handleAutoSettingsAction;
- (void)handleManualSettingsAction;

@end
