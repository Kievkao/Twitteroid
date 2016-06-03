//
//  TWRFeedInteractor.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/30/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWRFeedInteractorProtocol.h"
#import "TWRFeedPresenterProtocol.h"

@protocol TWRTwitterDAOProtocol, TWRCoreDataDAOProtocol;

@interface TWRFeedInteractor : NSObject <TWRFeedInteractorProtocol>

@property (nonatomic, weak) id<TWRFeedPresenterProtocol> presenter;

- (instancetype)initWithHashtag:(NSString *)hashtag tweetsDAO:(id<TWRTwitterDAOProtocol>)tweetsDAO coreDataDAO:(id<TWRCoreDataDAOProtocol>)coreDataDAO;

@end
