//
//  TWRManualDeleteSettingsPresenter.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/2/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWRManualSettingsEventHandlerProtocol.h"
#import "TWRManualSettingsViewProtocol.h"
#import "TWRManualSettingsInteractorProtocol.h"
#import "TWRManualSettingsWireframe.h"

@interface TWRManualSettingsPresenter : NSObject <TWRManualSettingsEventHandlerProtocol>

@property (nonatomic, weak) id<TWRManualSettingsViewProtocol> view;
@property (nonatomic) id<TWRManualSettingsInteractorProtocol> interactor;
@property (nonatomic, weak) TWRManualSettingsWireframe *wireframe;

@end
