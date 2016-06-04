//
//  TWRLoginWebWireframeProtocol.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/30/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class STTwitterAPI;

@protocol TWRLoginWebWireframeProtocol <NSObject>

- (instancetype)initWithTwitterAPI:(STTwitterAPI *)twitterAPI;
- (void)dismissLoginWebScreen;

- (void)notifyLoginSuccess;
- (void)notifyLoginError:(NSError *)error;

@end
