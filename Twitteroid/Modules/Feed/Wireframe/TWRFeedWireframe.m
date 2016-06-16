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
#import "TWRYoutubeVideoViewController.h"
#import "TWRGalleryDelegate.h"
#import "EBPhotoPagesController.h"
#import <MapKit/MapKit.h>
#import "TWRStorageManagerProtocol.h"
#import "TWRTwitterFeedService.h"

#import "TWRFeedInteractor.h"
#import "TWRFeedPresenter.h"
#import "TWRFeedViewController.h"
#import "TWRSettingsWireframe.h"

@interface TWRFeedWireframe()

@property (weak, nonatomic) TWRFeedViewController *feedViewController;

@property (strong, nonatomic) TWRFeedWireframe *childFeedWireframe;
@property (strong, nonatomic) TWRSettingsWireframe *settingsWireframe;

@property (strong, nonatomic) TWRTwitterFeedService *feedService;
@property (strong, nonatomic) id<TWRStorageManagerProtocol> storageManager;

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
    feedViewController.hashTag = hashtag;

    TWRFeedInteractor* interactor = [[TWRFeedInteractor alloc] initWithHashtag:hashtag feedService:self.feedService storageManager:self.storageManager];
    TWRFeedPresenter* presenter = [TWRFeedPresenter new];

    presenter.wireframe = self;
    presenter.interactor = interactor;
    presenter.view = feedViewController;

    interactor.presenter = presenter;
    feedViewController.eventHandler = presenter;

    return feedViewController;
}

#pragma mark - TWRFeedWireframeProtocol

- (void)presentSettingsScreen {
    [self.settingsWireframe presentSettingsScreenFromViewController:self.feedViewController];
}

- (void)presentWebViewForURL:(NSURL *)url {
    [[UIApplication sharedApplication] openURL:url];
}

- (void)presentTweetsScreenForHashtag:(NSString *)hashtag {
    [self.childFeedWireframe presentFeedScreenFromViewController:self.feedViewController withHashtag:hashtag];
}

- (void)presentLocationScreenWithLatitude:(double)latitude longitude:(double)longitude {
    TWRLocationVC *locationVC = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:[TWRLocationVC identifier]];
    locationVC.coordinates = CLLocationCoordinate2DMake(latitude, longitude);
    [self.feedViewController presentViewController:locationVC animated:YES completion:nil];
}

- (void)presentYoutubeVideoFromLink:(NSString *)youtubeLink {
    UINavigationController *videoRootNavC = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:[TWRYoutubeVideoViewController identifier]];
    TWRYoutubeVideoViewController *videoVC = [[videoRootNavC childViewControllers] firstObject];
    videoVC.youtubeLinkStr = youtubeLink;
    [self.feedViewController presentViewController:videoRootNavC animated:YES completion:nil];
}

- (void)presentGalleryScreenWithImagesURLs:(NSArray <NSURL *>*)imagesURLs {
    TWRGalleryDelegate *galleryDelegate = [[TWRGalleryDelegate alloc] initWithImagesURLs:imagesURLs];
    EBPhotoPagesController *photoPagesController = [[EBPhotoPagesController alloc] initWithDataSource:galleryDelegate delegate:galleryDelegate];
    [self.feedViewController presentViewController:photoPagesController animated:YES completion:nil];
}

@end
