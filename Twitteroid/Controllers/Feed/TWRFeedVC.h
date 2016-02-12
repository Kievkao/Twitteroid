//
//  TWRFeedVC.h
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRCoreDataManager.h"
#import "TWRTweet.h"
#import "TWRHashtag.h"
#import "TWRMedia.h"
#import "TWRPlace.h"

extern NSUInteger const kTweetsLoadingPortion;

@interface TWRFeedVC : UIViewController

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

- (void)checkEnvirAndLoadFromTweetID:(NSString *)tweetID withCompletion:(void (^)(NSError *error))loadingCompletion;

@end
