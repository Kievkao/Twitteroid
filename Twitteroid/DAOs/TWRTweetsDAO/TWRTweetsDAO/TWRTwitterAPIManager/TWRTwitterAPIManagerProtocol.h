//
//  TWRTwitterAPIManagerProtocol.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/3/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TWRTwitterAPIManagerProtocol <NSObject>

+ (instancetype)sharedInstance;
- (void)resetKeychain;
- (void)fillUserProfile;

- (BOOL)isUserAlreadyLogged;
- (void)loginWithOpenRequestBlock:(void (^)(NSURLRequest *request))requestBlock completion:(void (^)(NSError *error))completion;
- (void)reloginWithCompletion:(void (^)(NSError *error))completion;
- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier;
- (BOOL)isSessionLoginDone;

- (void)getFeedOlderThatTwitID:(NSString *)twitID
                    forHashtag:(NSString *)hashtag
                         count:(NSUInteger)count
                    completion:(void(^)(NSError *error, NSArray *items))completion;

@end
