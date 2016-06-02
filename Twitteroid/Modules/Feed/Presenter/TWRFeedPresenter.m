//
//  TWRFeedPresenter.m
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/30/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import "TWRFeedPresenter.h"

@implementation TWRFeedPresenter

- (void)tweetsLoadSuccess {
    [self.view releasePullToRefresh];
    [self.view stopInfinitiveScrollWaitingIndicator];
    [self.view reloadTweets];
}

- (void)fetchCachedTweetsDidFinishWithError:(NSError *)error {
    [self.view releasePullToRefresh];
    [self.view stopInfinitiveScrollWaitingIndicator];
    [self.view showAlertWithTitle:NSLocalizedString(@"Error", @"Error title") text:error.localizedDescription];
}

- (void)tweetsLoadDidFinishWithError:(NSError *)error {

    if (error.domain == NSURLErrorDomain && error.code == NSURLErrorNotConnectedToInternet) {
        [self.view showAlertWithTitle:NSLocalizedString(@"Connection Failed", @"Connection Failed") text:NSLocalizedString(@"Please check your internet connection", @"Please check your internet connection")];
    }
    else {
        [self.view showAlertWithTitle:NSLocalizedString(@"Error", @"Error title") text:error.localizedDescription];
    }
}

- (void)beginTweetsUpdate {
    [self.view beginTweetsUpdate];
}

- (void)finishTweetsUpdate {
    [self.view finishTweetsUpdate];
}

- (void)insertTweetAtIndexPath:(NSIndexPath *)indexPath {
    [self.view insertTweetAtIndexPath:indexPath];
}

- (void)removeTweetAtIndexPath:(NSIndexPath *)indexPath {
    [self.view removeTweetAtIndexPath:indexPath];
}

- (void)updateTweetAtIndexPath:(NSIndexPath *)indexPath {
    [self.view updateTweetAtIndexPath:indexPath];
}

- (void)moveTweetAtIndexPath:(NSIndexPath *)oldIndexPath toNewIndexPath:(NSIndexPath *)toNewIndexPath {
    [self.view moveTweetAtIndexPath:oldIndexPath toNewIndexPath:toNewIndexPath];
}

#pragma mark - TWRFeedEventHandlerProtocol

- (void)handleViewDidLoadAction {
    [self.interactor retrieveTweetsFromID:nil];
}

- (void)handlePullToRefreshAction {
    [self.interactor retrieveTweetsFromID:nil];
}

- (void)handleScrollToLastIndexPath:(NSIndexPath *)lastIndexPath {
    [self.interactor retrieveTweetsFromIndexPath:lastIndexPath];
}

- (void)handleSettingsAction {
    [self.wireframe presentSettingsScreen];
}

- (void)handleTweetURLAction:(NSURL *)url {
    [self.wireframe presentWebViewForURL:url];
}

- (void)handleTweetHashtagAction:(NSString *)hashtag {
    [self.wireframe presentTweetsScreenForHashtag:hashtag];
}

- (void)handleTweetLocationActionWithLatitude:(double)latitude longitude:(double)longitude {
    [self.wireframe presentLocationScreenWithLatitude:latitude longitude:longitude];
}

- (void)handleTweetYoutubeLinkAction:(NSString *)youtubeLink {
    [self.wireframe presentYoutubeVideoFromLink:youtubeLink];
}

- (void)handleTweetImagesClicked:(NSArray <NSURL *>*)imagesURLs {
    [self.wireframe presentGalleryScreenWithImagesURLs:imagesURLs];
}

- (NSUInteger)numberOfDataSections {
    return [self.interactor numberOfDataSections];
}

- (NSUInteger)numberOfObjectsInSection:(NSUInteger)section {
    return [self.interactor numberOfObjectsInSection:section];
}

- (TWRTweet *)tweetForIndexPath:(NSIndexPath *)indexPath {
    return [self.interactor dataObjectAtIndexPath:indexPath];
}

@end
