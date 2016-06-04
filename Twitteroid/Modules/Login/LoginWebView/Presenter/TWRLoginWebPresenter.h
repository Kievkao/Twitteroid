//
//  TWRLoginWebPresenter.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/30/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWRLoginWebPresenterProtocol.h"
#import "TWRLoginWebEventHandlerProtocol.h"
#import "TWRLoginWebViewProtocol.h"
#import "TWRLoginWebInteractorProtocol.h"
#import "TWRLoginWebWireframeProtocol.h"

@interface TWRLoginWebPresenter : NSObject <TWRLoginWebPresenterProtocol, TWRLoginWebEventHandlerProtocol>

@property (nonatomic, weak) id<TWRLoginWebViewProtocol> view;
@property (nonatomic) id<TWRLoginWebInteractorProtocol> interactor;
@property (nonatomic, weak) id<TWRLoginWebWireframeProtocol> wireframe;

- (instancetype)initWithURLRequest:(NSURLRequest *)request;

@end
