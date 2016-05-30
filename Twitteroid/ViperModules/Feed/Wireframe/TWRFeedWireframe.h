//
//  TWRFeedWireframe.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/30/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWRFeedWireframeProtocol.h"

@interface TWRFeedWireframe : NSObject <TWRFeedWireframeProtocol>

- (void)presentFeedScreenFromViewController:(UIViewController*)viewController withHashtag:(NSString *)hashtag;
- (void)setFeedScreenInsteadViewController:(UIViewController*)viewController withHashtag:(NSString *)hashtag;

@end
