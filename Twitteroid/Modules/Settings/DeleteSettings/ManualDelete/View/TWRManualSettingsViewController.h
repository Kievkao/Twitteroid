//
//  TWRSettingsManualVC.h
//  Twitteroid
//
//  Created by Andrey Kravchenko on 7/28/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWRManualSettingsViewProtocol.h"
#import "TWRManualSettingsEventHandlerProtocol.h"

@interface TWRManualSettingsViewController : UIViewController <TWRViewControllerIdentifier, TWRManualSettingsViewProtocol>

@property (nonatomic) id<TWRManualSettingsEventHandlerProtocol> eventHandler;

@end
