//
//  TWRLoginWebInteractorProtocol.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/30/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TWRLoginWebInteractorProtocol <NSObject>

- (BOOL)shouldStartLoadRequest:(NSURLRequest *)request;

@end
