//
//  TWRTwitterLoginService.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/3/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWRTwitterLoginServiceProtocol.h"

@class STTwitterAPI, TWRCredentialsStore;

@interface TWRTwitterLoginService : NSObject <TWRTwitterLoginServiceProtocol>

- (instancetype)initWithTwitterAPI:(STTwitterAPI *)twitterAPI credentialsStore:(TWRCredentialsStore *)credentialsStore;

@end
