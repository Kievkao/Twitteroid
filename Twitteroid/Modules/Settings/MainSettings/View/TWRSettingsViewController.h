//
//  TWRSettingsVC.h
//  Twitteroid
//
//  Created by Andrey Kravchenko on 7/28/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWRViewControllerIdentifier.h"
#import "TWRSettingsViewProtocol.h"
#import "TWRSettingsEventHandlerProtocol.h"

@interface TWRSettingsViewController : UITableViewController <TWRSettingsViewProtocol>

@property (nonatomic) id<TWRSettingsEventHandlerProtocol> eventHandler;

+ (NSString *)rootNavigationControllerIdentifier;

@end
