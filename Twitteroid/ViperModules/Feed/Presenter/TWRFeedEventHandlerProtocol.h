//
//  TWRFeedEventHandlerProtocol.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/30/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TWRTweet;

@protocol TWRFeedEventHandlerProtocol <NSObject>

- (void)handleViewDidLoadAction;
- (void)handleSettingsAction;

- (void)handlePullToRefreshAction;
- (void)handleScrollToLastIndexPath:(NSIndexPath *)lastIndexPath;

- (void)handleTweetURLAction:(NSURL *)url;
- (void)handleTweetHashtagAction:(NSString *)hashtag;
- (void)handleTweetLocationActionWithLatitude:(double)latitude longitude:(double)longitude;
- (void)handleTweetYoutubeLinkAction:(NSString *)youtubeLink;
- (void)handleTweetImagesClicked:(NSArray <NSURL *>*)imagesURLs;

- (NSUInteger)numberOfDataSections;
- (NSUInteger)numberOfObjectsInSection:(NSUInteger)section;
- (TWRTweet *)tweetForIndexPath:(NSIndexPath *)indexPath;

@end
