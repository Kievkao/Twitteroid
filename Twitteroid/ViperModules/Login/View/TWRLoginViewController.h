//
//  TWRLoginVC.h
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWRLoginViewProtocol.h"
#import "TWRLoginEventHandlerProtocol.h"

@interface TWRLoginViewController : UIViewController <TWRLoginViewProtocol>

@property (nonatomic) id<TWRLoginEventHandlerProtocol> eventHandler;

@end
