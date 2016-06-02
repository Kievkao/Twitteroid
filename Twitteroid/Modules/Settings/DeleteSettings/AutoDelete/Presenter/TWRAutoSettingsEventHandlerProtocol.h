//
//  TWRAutoSettingsEventHandlerProtocol.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/2/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TWRAutoSettingsEventHandlerProtocol <NSObject>

- (void)handleViewDidLoad;
- (void)handleApplyDeleteRuleAction;
- (void)handleConfirmDeleteRuleActionWithWeeksNumber:(NSUInteger)weeksNumber;

@end
