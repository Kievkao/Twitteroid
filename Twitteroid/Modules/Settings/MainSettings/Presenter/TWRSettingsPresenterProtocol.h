//
//  TWRSettingsPresenterProtocol.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/2/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TWRUserProfile;

@protocol TWRSettingsPresenterProtocol <NSObject>

- (void)retrieveUserProfileDidLoad:(TWRUserProfile *)userProfile;
- (void)retrieveUserProfileDidStartAsync;
- (void)retrieveUserProfileDidFinishWithError:(NSError *)error;

@end
