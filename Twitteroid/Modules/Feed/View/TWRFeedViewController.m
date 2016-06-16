//
//  TWRFeedVC.m
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRFeedViewController.h"
#import "TWRTwitCell.h"
#import "UIScrollView+INSPullToRefresh.h"
#import "INSDefaultPullToRefresh.h"
#import "INSDefaultInfiniteIndicator.h"
#import "TWRLocationVC.h"
#import "EBPhotoPagesController.h"
#import "TWRGalleryDelegate.h"
#import "TWRSettingsViewController.h"
#import "TWRYoutubeVideoViewController.h"
#import "NSDate+NVTimeAgo.h"
#import "TWRStorageManagerProtocol.h"
#import "TWRTweet.h"
#import "TWRPlace.h"
#import "TWRMedia.h"

static CGFloat const kEstimatedCellHeight = 95.0;

static CGFloat const kPullRefreshHeight = 60.0;
static CGFloat const kPullRefreshIndicatorDiameter = 24.0;

static CGFloat const kInfinitiveScrollHeight = 60.0;
static CGFloat const kInfinitiveScrollIndicatorDiameter = 24.0;

@interface TWRFeedViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TWRFeedViewController

+ (NSString *)identifier {
    return @"TWRFeedVC";
}

#pragma mark - UIViewController lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.eventHandler handleViewDidLoadAction];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - UI Setup

- (void)setupUI {
    [self setupNavigationBar];
    [self pullToRefreshSetup];
    [self infinitiveScrollSetup];
}

- (void)setupNavigationBar {
    UIBarButtonItem *settingsBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settingsIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(settingsBtnClicked)];
    [self.navigationItem setRightBarButtonItem:settingsBarItem animated:YES];
    self.title = self.hashTag ? self.hashTag : @"Feed";
}

#pragma mark - TWRFeedViewProtocol

- (void)reloadTweets {
    [self.tableView reloadData];
}

- (void)beginTweetsUpdate {
    [self.tableView beginUpdates];
}

- (void)finishTweetsUpdate {
    [self.tableView endUpdates];
}

- (void)insertTweetAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)removeTweetAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)updateTweetAtIndexPath:(NSIndexPath *)indexPath {
    [self configureCell:(TWRTwitCell *)[self.tableView cellForRowAtIndexPath:indexPath] forIndexPath:indexPath];
}

- (void)moveTweetAtIndexPath:(NSIndexPath *)oldIndexPath toNewIndexPath:(NSIndexPath *)toNewIndexPath {
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:oldIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:toNewIndexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* alertAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"Alert button title") style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:alertAction];

    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)setProgressIndicatorVisible:(BOOL)visible {
    if (visible) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    else {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}

#pragma mark - Actions

- (void)settingsBtnClicked {
    [self.eventHandler handleSettingsAction];    
}

#pragma mark - Infinitive scroll && PullToRefresh

- (void)pullToRefreshSetup {
    __typeof(self) __weak weakSelf = self;

    [self.tableView ins_addPullToRefreshWithHeight:kPullRefreshHeight handler:^(UIScrollView *scrollView) {
        [weakSelf.eventHandler handlePullToRefreshAction];
    }];
    
    UIView <INSPullToRefreshBackgroundViewDelegate> *pullToRefresh = [self pullToRefreshViewFromCurrentStyle];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.ins_pullToRefreshBackgroundView.delegate = pullToRefresh;
    [self.tableView.ins_pullToRefreshBackgroundView addSubview:pullToRefresh];
}

- (void)releasePullToRefresh {
    [self.tableView ins_endPullToRefresh];
}

- (void)infinitiveScrollSetup {
    __typeof(self) __weak weakSelf = self;

    [self.tableView ins_addInfinityScrollWithHeight:kInfinitiveScrollHeight handler:^(UIScrollView *scrollView) {
        [weakSelf.eventHandler handleScrollToLastIndexPath:[[weakSelf.tableView indexPathsForVisibleRows] lastObject]];
    }];
    
    UIView <INSAnimatable> *infinityIndicator = [self infinityIndicatorViewFromCurrentStyle];
    [self.tableView.ins_infiniteScrollBackgroundView addSubview:infinityIndicator];
    [infinityIndicator startAnimating];
}

- (void)stopInfinitiveScrollWaitingIndicator {
    [self.tableView ins_endInfinityScrollWithStoppingContentOffset:NO];
}

- (UIView <INSAnimatable> *)infinityIndicatorViewFromCurrentStyle {
    return [[INSDefaultInfiniteIndicator alloc] initWithFrame:CGRectMake(0, 0, kInfinitiveScrollIndicatorDiameter, kInfinitiveScrollIndicatorDiameter)];
}

- (UIView <INSPullToRefreshBackgroundViewDelegate> *)pullToRefreshViewFromCurrentStyle {
    return [[INSDefaultPullToRefresh alloc] initWithFrame:CGRectMake(0, 0, kPullRefreshIndicatorDiameter, kPullRefreshIndicatorDiameter) backImage:[UIImage imageNamed:@"circleLight"] frontImage:[UIImage imageNamed:@"circleDark"]];
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.eventHandler numberOfDataSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.eventHandler numberOfObjectsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kEstimatedCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TWRTweet *tweet = [self.eventHandler tweetForIndexPath:indexPath];
    
    BOOL isMedia = tweet.medias.count > 0;
    BOOL isRetwitted = tweet.isRetwitted;
    
    return [TWRTwitCell cellHeightForTableViewWidth:CGRectGetWidth(tableView.frame) tweetText:tweet.text mediaPresent:isMedia retwitted:isRetwitted];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TWRTwitCell *cell = [tableView dequeueReusableCellWithIdentifier:[TWRTwitCell identifier] forIndexPath:indexPath];
    
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
}
            
#pragma mark - Cells configuring

- (void)configureCell:(TWRTwitCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    TWRTweet *tweet = [self.eventHandler tweetForIndexPath:indexPath];
    
    [cell setAuthorName:tweet.userName];
    [cell setAuthorNickname:tweet.userNickname];
    [cell setTweetText:tweet.text];
    [cell setAuthorAvatarFromURLString:tweet.userAvatarURL];
    [cell setLocationButtonVisible:(tweet.place) ? YES : NO];
    [cell setTweetTime:[tweet.createdAt formattedAsTimeAgo]];
    
    if (tweet.isRetwitted) {
        [cell setRetwittedViewVisible:YES withRetweetAuthor:tweet.retwittedBy];
    }
    else {
        [cell setRetwittedViewVisible:NO withRetweetAuthor:nil];
    }
    
    [self setActionsHandlersForCell:cell tweet:tweet];
}

- (void)setActionsHandlersForCell:(TWRTwitCell *)cell tweet:(TWRTweet *)tweet {
    __weak typeof(self)weakSelf = self;
    
    cell.webLinkClickBlock = ^(NSURL *url) {
        [weakSelf tweet:tweet clickedURL:url];
    };
    
    cell.hashtagClickBlock = ^(NSString *hashtag) {
        [weakSelf tweet:tweet clickedHashtag:hashtag];
    };
    
    cell.locationButtonClickBlock = ^() {
        [weakSelf tweet:tweet clickedLocation:CLLocationCoordinate2DMake(tweet.place.lattitude, tweet.place.longitude)];
    };
    
    cell.mediaClickBlock = ^(BOOL isVideo, NSUInteger index) {
        NSMutableArray *mediasURLs = [NSMutableArray new];
        
        for (TWRMedia *media in tweet.medias) {
            [mediasURLs addObject:media.mediaURL];
        }
        
        if (isVideo) {
            [weakSelf tweet:tweet clickedYoutubeVideoPath:mediasURLs[index]];
        }
        else {
            [mediasURLs replaceObjectAtIndex:0 withObject:[mediasURLs objectAtIndex:index]];
            [weakSelf tweet:tweet clickedImages:mediasURLs];
        }
    };
    
    if (tweet.medias.count) {
        NSMutableArray *mediaUrlsArray = [NSMutableArray new];
        
        for (TWRMedia *media in tweet.medias) {
            [mediaUrlsArray addObject:media.mediaURL];
        }
        
        TWRMedia *media = [tweet.medias anyObject];
        
        if (media.isPhoto) {
            [cell setImagesURLs:mediaUrlsArray];
        }
        else {
            [cell setVideoURLs:@[[mediaUrlsArray firstObject]]];
        }
    }
    else {
        [cell hideMediaFrame];
    }
}

#pragma mark - Tweet cell actions
- (void)tweet:(TWRTweet *)tweet clickedURL:(NSURL *)url {
    [self.eventHandler handleTweetURLAction:url];    
}

- (void)tweet:(nullable TWRTweet *)tweet clickedHashtag:(NSString *)hashtag {
    [self.eventHandler handleTweetHashtagAction:hashtag];
}

- (void)tweet:(TWRTweet *)tweet clickedLocation:(CLLocationCoordinate2D)location {
    [self.eventHandler handleTweetLocationActionWithLatitude:location.latitude longitude:location.longitude];
}

- (void)tweet:(TWRTweet *)tweet clickedYoutubeVideoPath:(NSString *)videoPath {
    [self.eventHandler handleTweetYoutubeLinkAction:videoPath];
}

- (void)tweet:(TWRTweet *)tweet clickedImages:(NSArray *)imagesURLs {
    [self.eventHandler handleTweetImagesClicked:imagesURLs];
}

@end
