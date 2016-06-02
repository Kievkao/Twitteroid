//
//  TWRSettingsPresenter.m
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/2/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import "TWRSettingsPresenter.h"

@implementation TWRSettingsPresenter

- (void)handleDoneAction {
    [self.wireframe dismissSettingsScreen];
}

- (void)handleAutoSettingsAction {
    [self.wireframe presentAutoSettingsScreen];
}

- (void)handleManualSettingsAction {
    [self.wireframe presentManualSettingsScreen];
}

@end
