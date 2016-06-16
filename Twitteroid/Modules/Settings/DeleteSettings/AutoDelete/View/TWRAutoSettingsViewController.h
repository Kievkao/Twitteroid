//
//  TWRSettingsAutoVC.h
//  Twitteroid
//
//  Created by Andrey Kravchenko on 7/28/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWRAutoSettingsViewProtocol.h"
#import "TWRAutoSettingsEventHandlerProtocol.h"

@interface TWRAutoSettingsViewController : UIViewController <TWRViewControllerIdentifier, TWRAutoSettingsViewProtocol>

@property (nonatomic) id<TWRAutoSettingsEventHandlerProtocol> eventHandler;

@end
