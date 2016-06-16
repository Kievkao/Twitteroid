//
//  TWRSettingsPresenterProtocol.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/2/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TWRUserProfile;

NS_ASSUME_NONNULL_BEGIN

@protocol TWRSettingsPresenterProtocol <NSObject>

- (void)retrieveUserProfileDidLoad:(TWRUserProfile *)userProfile;
- (void)retrieveUserProfileDidStartAsync;
- (void)retrieveUserProfileDidFinishWithError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
