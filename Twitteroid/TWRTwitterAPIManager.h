//
//  TWRTwitterAPIManager.h
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWRBaseSingletonNSObject.h"
#import "STTwitter.h"

extern NSString *const kTwitterApiKey;
extern NSString *const kTwitterApiSecret;

@interface TWRTwitterAPIManager : TWRBaseSingletonNSObject

@property (nonatomic, strong) STTwitterAPI *twitter;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *tokenSecret;
@property (nonatomic, strong) void (^loginCompletion)(NSError *error);

@property (nonatomic) BOOL sessionLoginDone;

- (void)resetKeychain;

@end
