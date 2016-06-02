//
//  TWRFeedViewProtocol.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/30/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TWRFeedViewProtocol <NSObject>

- (void)reloadTweets;
- (void)beginTweetsUpdate;
- (void)finishTweetsUpdate;
- (void)insertTweetAtIndexPath:(NSIndexPath *)indexPath;
- (void)removeTweetAtIndexPath:(NSIndexPath *)indexPath;
- (void)updateTweetAtIndexPath:(NSIndexPath *)indexPath;
- (void)moveTweetAtIndexPath:(NSIndexPath *)oldIndexPath toNewIndexPath:(NSIndexPath *)toNewIndexPath;

- (void)showAlertWithTitle:(NSString *)title text:(NSString *)text;
- (void)releasePullToRefresh;
- (void)stopInfinitiveScrollWaitingIndicator;

@end
