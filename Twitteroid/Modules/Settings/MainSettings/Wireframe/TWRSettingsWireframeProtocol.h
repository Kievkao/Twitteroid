//
//  TWRSettingsWireframeProtocol.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/2/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TWRSettingsWireframeProtocol <NSObject>

- (void)dismissSettingsScreen;

- (void)presentAutoSettingsScreen;
- (void)presentManualSettingsScreen;

@end
