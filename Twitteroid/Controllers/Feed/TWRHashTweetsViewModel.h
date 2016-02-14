//
//  TWRHashTweetsViewModel.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 2/14/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWRHashTweetsViewModel : NSObject

- (void)loadFromTweetID:(NSString *)tweetID withCompletion:(void (^)(NSError *error))loadingCompletion;

@end
