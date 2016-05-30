//
//  TWRLoginWireframeProtocol.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/28/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TWRLoginWireframeProtocol <NSObject>

- (void)presentFeedScreen;
- (void)presentWebLoginScreenWithRequest:(NSURLRequest *)request;
- (void)dismissWebLoginScreen;

@end
