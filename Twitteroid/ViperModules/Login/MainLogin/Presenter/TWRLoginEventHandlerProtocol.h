//
//  TWRLoginEventHandlerProtocol.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/28/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TWRLoginEventHandlerProtocol <NSObject>

- (void)handleViewDidLoad;
- (void)handleLoginClicked;

@end
