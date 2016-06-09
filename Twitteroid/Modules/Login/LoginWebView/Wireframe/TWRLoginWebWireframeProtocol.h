//
//  TWRLoginWebWireframeProtocol.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/30/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TWRLoginWebWireframeProtocol <NSObject>

- (void)dismissLoginWebScreen;

- (void)notifyLoginSuccess;
- (void)notifyLoginError:(NSError *)error;

@end
