//
//  TWRHashTweetsVC.m
//  Twitteroid
//
//  Created by Andrey Kravchenko on 7/28/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRHashTweetsVC.h"
#import "TWRFeedVC+TWRParsing.h"
#import "TWRTwitterAPIManager+TWRFeed.h"

@interface TWRHashTweetsVC ()

@end

@implementation TWRHashTweetsVC

+ (NSString *)identifier {
    return @"TWRHashTweetsVC";
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.hashTag;
}

- (void)loadFromTweetID:(NSString *)tweetID withCompletion:(void (^)(NSError *error))loadingCompletion {
    
    [[TWRTwitterAPIManager sharedInstance] getTweetsByHashtag:self.hashTag olderThatTwitID:tweetID count:kTweetsLoadingPortion completion:^(NSError *error, NSArray *items) {
        if (!error) {
            [self parseTweetsArray:items forHashtag:[self tweetsHashtag]];
            [TWRCoreDataManager saveContext];
        }
        else {
            NSLog(@"Loading error");
        }
        
        loadingCompletion(error);
    }];
}

- (NSString *)tweetsHashtag {
    return self.hashTag;
}

- (void)setupNavigationBar {

}

@end
