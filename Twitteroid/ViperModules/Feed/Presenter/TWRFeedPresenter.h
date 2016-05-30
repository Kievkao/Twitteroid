//
//  TWRFeedPresenter.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/30/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWRFeedPresenterProtocol.h"
#import "TWRFeedEventHandlerProtocol.h"
#import "TWRFeedInteractorProtocol.h"
#import "TWRFeedWireframeProtocol.h"
#import "TWRFeedViewProtocol.h"

@interface TWRFeedPresenter : NSObject <TWRFeedPresenterProtocol, TWRFeedEventHandlerProtocol>

@property (nonatomic, weak) id<TWRFeedViewProtocol> view;
@property (nonatomic) id<TWRFeedInteractorProtocol> interactor;
@property (nonatomic, weak) id<TWRFeedWireframeProtocol> wireframe;

@end
