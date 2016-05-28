//
//  TWRLoginViewModel.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/27/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWRLoginViewModel : NSObject

- (void)reloginWithCompletion:(void (^)(BOOL userWasLoggedPreviously, NSError *error))completion;
- (void)loginWithWebRequestHandler:(void (^)(NSURLRequest *request))requestHandler completion:(void (^)(NSError *error))completion;

@end
