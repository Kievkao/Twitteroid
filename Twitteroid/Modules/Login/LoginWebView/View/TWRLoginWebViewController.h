//
//  TWRLoginWebVC.h
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWRLoginWebViewProtocol.h"
#import "TWRLoginWebEventHandlerProtocol.h"

@interface TWRLoginWebViewController : UIViewController <TWRViewControllerIdentifier, TWRLoginWebViewProtocol>

@property (nonatomic) id<TWRLoginWebEventHandlerProtocol> eventHandler;

@end
