//
//  TWRSettingsPresenter.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/2/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWRSettingsPresenterProtocol.h"
#import "TWRSettingsEventHandlerProtocol.h"
#import "TWRSettingsViewProtocol.h"
#import "TWRSettingsWireframeProtocol.h"

@interface TWRSettingsPresenter : NSObject <TWRSettingsPresenterProtocol, TWRSettingsEventHandlerProtocol>

@property (nonatomic, weak) id<TWRSettingsViewProtocol> view;
@property (nonatomic, weak) id<TWRSettingsWireframeProtocol> wireframe;

@end
