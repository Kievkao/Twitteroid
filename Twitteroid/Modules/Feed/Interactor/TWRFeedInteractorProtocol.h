//
//  TWRFeedInteractorProtocol.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/30/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TWRTweet;

@protocol TWRFeedInteractorProtocol <NSObject>

- (void)retrieveTweetsFromID:(NSString *)tweetID;
- (void)retrieveTweetsFromIndexPath:(NSIndexPath *)indexPath;

- (NSUInteger)numberOfDataSections;
- (NSUInteger)numberOfObjectsInSection:(NSUInteger)section;
- (TWRTweet *)dataObjectAtIndexPath:(NSIndexPath *)indexPath;

@end
