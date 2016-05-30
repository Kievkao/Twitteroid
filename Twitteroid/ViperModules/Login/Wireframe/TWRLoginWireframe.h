//
//  TWRLoginWireframe.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/28/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWRLoginWireframeProtocol.h"

@interface TWRLoginWireframe : NSObject <TWRLoginWireframeProtocol>

- (void)presentLoginScreenFromViewController:(UIViewController*)viewController;
- (UIViewController *)createLoginViewController;

@end
