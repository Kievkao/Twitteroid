//
//  TWRFeedPresenterProtocol.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/30/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TWRFeedPresenterProtocol <NSObject>

- (void)tweetsLoadSuccess;
- (void)fetchCachedTweetsDidFinishWithError:(NSError *)error;
- (void)tweetsLoadDidFinishWithError:(NSError *)error;

- (void)beginTweetsUpdate;
- (void)finishTweetsUpdate;
- (void)insertTweetAtIndexPath:(NSIndexPath *)indexPath;
- (void)removeTweetAtIndexPath:(NSIndexPath *)indexPath;
- (void)updateTweetAtIndexPath:(NSIndexPath *)indexPath;
- (void)moveTweetAtIndexPath:(NSIndexPath *)oldIndexPath toNewIndexPath:(NSIndexPath *)toNewIndexPath;

@end
