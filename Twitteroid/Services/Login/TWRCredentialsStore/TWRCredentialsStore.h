//
//  TWRCredentialsStore.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/3/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWRCredentialsStore : NSObject

@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *tokenSecret;

@property (strong, nonatomic, readonly) NSString *twitterAPIKey;
@property (strong, nonatomic, readonly) NSString *twitterAPISecret;

@end
