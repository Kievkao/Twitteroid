//
//  TWRAutoDeleteSettingsPresenter.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/2/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWRAutoSettingsPresenterProtocol.h"
#import "TWRAutoSettingsEventHandlerProtocol.h"
#import "TWRAutoSettingsViewProtocol.h"
#import "TWRAutoSettingsInteractorProtocol.h"
#import "TWRAutoSettingsWireframe.h"

@interface TWRAutoSettingsPresenter : NSObject <TWRAutoSettingsPresenterProtocol, TWRAutoSettingsEventHandlerProtocol>

@property (nonatomic, weak) id<TWRAutoSettingsViewProtocol> view;
@property (nonatomic) id<TWRAutoSettingsInteractorProtocol> interactor;
@property (nonatomic, weak) TWRAutoSettingsWireframe *wireframe;


@end
