//
//  TWRLoginWebEventHandlerProtocol.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/30/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TWRLoginWebEventHandlerProtocol <NSObject>

- (BOOL)shouldStartLoadRequest:(NSURLRequest *)request;
- (void)handleViewDidLoad;
- (void)handleCancelAction;

@end
