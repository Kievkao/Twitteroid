//
//  TWRFeedWireframe.m
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/30/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import "TWRFeedWireframe.h"
#import "TWRSettingsVC.h"
#import "TWRLocationVC.h"
#import "TWRYoutubeVideoVC.h"
#import "TWRGalleryDelegate.h"
#import "EBPhotoPagesController.h"
#import <MapKit/MapKit.h>

#import "TWRFeedInteractor.h"
#import "TWRFeedPresenter.h"
#import "TWRFeedViewController.h"
#import "TWRTweetsDAO.h"

@interface TWRFeedWireframe()

@property (weak, nonatomic) TWRFeedViewController *feedViewController;

@end

@implementation TWRFeedWireframe

- (void)presentFeedScreenFromViewController:(UIViewController*)viewController withHashtag:(NSString *)hashtag {
    self.feedViewController = [self createFeedViewWithHashtag:hashtag];

    [viewController presentViewController:self.feedViewController animated:YES completion:nil];
}

- (void)setFeedScreenInsteadViewController:(UIViewController*)viewController withHashtag:(NSString *)hashtag {

    self.feedViewController = [self createFeedViewWithHashtag:hashtag];
    [viewController.navigationController setViewControllers:@[self.feedViewController] animated:YES];
}

- (TWRFeedViewController *)createFeedViewWithHashtag:(NSString *)hashtag {
    TWRFeedViewController *feedViewController = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"TWRFeedVC"];

    TWRFeedInteractor* interactor = [[TWRFeedInteractor alloc] initWithHashtag:hashtag tweetsDAO:[TWRTweetsDAO new]];
    TWRFeedPresenter* presenter = [TWRFeedPresenter new];

    presenter.wireframe = self;
    presenter.interactor = interactor;
    presenter.view = feedViewController;

    interactor.presenter = presenter;
    feedViewController.eventHandler = presenter;

    return feedViewController;
}

- (void)presentSettingsScreen {
    [self.feedViewController presentViewController:[[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:[TWRSettingsVC identifier]] animated:YES completion:nil];
}

- (void)presentWebViewForURL:(NSURL *)url {
    [[UIApplication sharedApplication] openURL:url];
}

- (void)presentTweetsScreenForHashtag:(NSString *)hashtag {
    TWRFeedViewController *feedVC = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:[TWRFeedViewController identifier]];
    feedVC.hashTag = hashtag;
    [self.feedViewController presentViewController:feedVC animated:YES completion:nil];
}

- (void)presentLocationScreenWithLatitude:(double)latitude longitude:(double)longitude {
    TWRLocationVC *locationVC = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:[TWRLocationVC identifier]];
    locationVC.coordinates = CLLocationCoordinate2DMake(latitude, longitude);
    [self.feedViewController presentViewController:locationVC animated:YES completion:nil];
}

- (void)presentYoutubeVideoFromLink:(NSString *)youtubeLink {
    UINavigationController *videoRootNavC = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:[TWRYoutubeVideoVC rootNavigationIdentifier]];
    TWRYoutubeVideoVC *videoVC = [[videoRootNavC childViewControllers] firstObject];
    videoVC.youtubeLinkStr = youtubeLink;
    [self.feedViewController presentViewController:videoRootNavC animated:YES completion:nil];
}

- (void)presentGalleryScreenWithImagesURLs:(NSArray <NSURL *>*)imagesURLs {
    TWRGalleryDelegate *galleryDelegate = [[TWRGalleryDelegate alloc] initWithImagesURLs:imagesURLs];
    EBPhotoPagesController *photoPagesController = [[EBPhotoPagesController alloc] initWithDataSource:galleryDelegate delegate:galleryDelegate];
    [self.feedViewController presentViewController:photoPagesController animated:YES completion:nil];
}

@end
