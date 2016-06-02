//
//  TWRFeedVC.h
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRFeedEventHandlerProtocol.h"
#import "TWRFeedViewProtocol.h"

@interface TWRFeedViewController : UIViewController <TWRViewControllerIdentifier, TWRFeedViewProtocol>

@property (nonatomic) id<TWRFeedEventHandlerProtocol> eventHandler;

@property (nonatomic, strong) NSString *hashTag;

@end
