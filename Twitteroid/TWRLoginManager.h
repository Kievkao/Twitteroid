//
//  TWRLoginManager.h
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWRLoginManager : NSObject

+ (instancetype)sharedInstance;
- (void)loginWithOpenRequestBlock:(void (^)(NSURLRequest *request))requestBlock completion:(void (^)(NSError *error))completion;
- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier;

@end
