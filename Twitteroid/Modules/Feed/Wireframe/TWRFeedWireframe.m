//
//  TWRFeedWireframe.m
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/30/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import "TWRFeedWireframe.h"
#import "TWRSettingsViewController.h"
#import "TWRLocationVC.h"
#import "TWRYoutubeVideoVC.h"
#import "TWRGalleryDelegate.h"
#import "EBPhotoPagesController.h"
#import <MapKit/MapKit.h>
#import "TWRCoreDataDAO.h"

#import "TWRFeedInteractor.h"
#import "TWRFeedPresenter.h"
#import "TWRFeedViewController.h"
#import "TWRTweetsDAO.h"
#import "TWRTweetParser.h"
#import "TWRSettingsWireframe.h"

@interface TWRFeedWireframe()

@property (weak, nonatomic) TWRFeedViewController *feedViewController;
@property (strong, nonatomic) TWRFeedWireframe *childFeedWireframe;
@property (strong, nonatomic) TWRSettingsWireframe *settingsWireframe;

@end

@implementation TWRFeedWireframe

- (void)presentFeedScreenFromViewController:(UIViewController*)viewController withHashtag:(NSString *)hashtag {
    self.feedViewController = [self createFeedViewWithHashtag:hashtag];

    [viewController.navigationController pushViewController:self.feedViewController animated:YES];
}

- (void)setFeedScreenInsteadViewController:(UIViewController*)viewController withHashtag:(NSString *)hashtag {

    self.feedViewController = [self createFeedViewWithHashtag:hashtag];
    [viewController.navigationController setViewControllers:@[self.feedViewController] animated:YES];
}

- (TWRFeedViewController *)createFeedViewWithHashtag:(NSString *)hashtag {
    TWRFeedViewController *feedViewController = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"TWRFeedVC"];

    TWRFeedInteractor* interactor = [[TWRFeedInteractor alloc] initWithHashtag:hashtag tweetsDAO:[[TWRTweetsDAO alloc] initWithTweetParser:[TWRTweetParser new]] coreDataDAO:[TWRCoreDataDAO sharedInstance]];
    TWRFeedPresenter* presenter = [TWRFeedPresenter new];

    presenter.wireframe = self;
    presenter.interactor = interactor;
    presenter.view = feedViewController;

    interactor.presenter = presenter;
    feedViewController.eventHandler = presenter;

    return feedViewController;
}

- (void)presentSettingsScreen {
    self.settingsWireframe = [TWRSettingsWireframe new];
    [self.settingsWireframe presentSettingsScreenFromViewController:self.feedViewController];
}

- (void)presentWebViewForURL:(NSURL *)url {
    [[UIApplication sharedApplication] openURL:url];
}

- (void)presentTweetsScreenForHashtag:(NSString *)hashtag {
    self.childFeedWireframe = [TWRFeedWireframe new];
    [self.childFeedWireframe presentFeedScreenFromViewController:self.feedViewController withHashtag:hashtag];
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
