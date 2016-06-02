//
//  TWRLoginPresenter.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/28/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TWRLoginPresenterProtocol.h"
#import "TWRLoginEventHandlerProtocol.h"
#import "TWRLoginInteractorProtocol.h"
#import "TWRLoginWireframeProtocol.h"
#import "TWRLoginViewProtocol.h"

@interface TWRLoginPresenter : NSObject <TWRLoginPresenterProtocol, TWRLoginEventHandlerProtocol>

@property (nonatomic, weak) id<TWRLoginViewProtocol> view;
@property (nonatomic) id<TWRLoginInteractorProtocol> interactor;
@property (nonatomic, weak) id<TWRLoginWireframeProtocol> wireframe;

@end
