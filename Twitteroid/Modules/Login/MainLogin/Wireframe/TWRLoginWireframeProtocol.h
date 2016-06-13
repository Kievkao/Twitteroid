//
//  TWRLoginWireframeProtocol.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/28/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TWRLoginWebModuleDelegate;

@protocol TWRLoginWireframeProtocol <NSObject>

- (void)presentFeedScreen;
- (void)processWebLoginWithRequest:(NSURLRequest *)request moduleDelegate:(id<TWRLoginWebModuleDelegate>)moduleDelegate;
- (void)dismissWebLoginScreen;

@end
