//
//  TWRFeedVC.m
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRFeedVC.h"
#import "TWRTwitCell.h"
#import "UIScrollView+INSPullToRefresh.h"
#import "INSTwitterPullToRefresh.h"
#import "INSCircleInfiniteIndicator.h"
#import "TWRLocationVC.h"
#import "EBPhotoPagesController.h"
#import "TWRGalleryDelegate.h"
#import "TWRSettingsVC.h"
#import "TWRYoutubeVideoVC.h"
#import "NSDate+NVTimeAgo.h"
#import "TWRCoreDataManager.h"
#import "TWRFeedViewModel.h"

static CGFloat const kEstimatedCellHeight = 95.0;

static CGFloat const kPullRefreshHeight = 60.0;
static CGFloat const kPullRefreshIndicatorDiameter = 24.0;

static CGFloat const kInfinitiveScrollHeight = 60.0;
static CGFloat const kInfinitiveScrollIndicatorDiameter = 24.0;

@interface TWRFeedVC () <TWRFeedViewModelDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) TWRFeedViewModel *viewModel;

@end

@implementation TWRFeedVC

+ (NSString *)identifier {
    return @"TWRFeedVC";
}

#pragma mark - UIViewController lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    
    self.viewModel = [[TWRFeedViewModel alloc] initWithHashtag:self.hashTag delegate:self];
    [self.viewModel startFetching];
}

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)needToReloadData {
    [self.tableView reloadData];
}

- (void)settingsBtnClicked {
    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:[TWRSettingsVC rootNavControllerIdentifier]] animated:YES completion:nil];
}

#pragma mark - View model delegate
- (void)viewModelWillChangeContent {
    [self.tableView beginUpdates];    
}

- (void)viewModelDidChangeContent {
    [self.tableView endUpdates];    
}

- (void)rowNeedToBeInserted:(NSIndexPath *)indexPath {
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];    
}

- (void)rowNeedToBeDeleted:(NSIndexPath *)indexPath {
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];    
}

- (void)rowNeedToBeUpdated:(NSIndexPath *)indexPath {
    [self configureCell:(TWRTwitCell *)[self.tableView cellForRowAtIndexPath:indexPath] forIndexPath:indexPath];
}

- (void)rowNeedToBeMoved:(NSIndexPath *)oldIndexPath newIndexPath:(NSIndexPath *)newIndexPath {
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:oldIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)showAlertWithTitle:(NSString *)title text:(NSString *)text {
    [self showInfoAlertWithTitle:title text:text];
}

#pragma mark - Infinitive scroll && PullToRefresh
- (void)pullToRefreshSetup {
    [self.tableView ins_addPullToRefreshWithHeight:kPullRefreshHeight handler:^(UIScrollView *scrollView) {
        [self.viewModel checkEnvironmentAndLoadFromTweetID:nil withCompletion:^(NSError *error) {
            [scrollView ins_endPullToRefresh];
        }];
    }];
    
    UIView <INSPullToRefreshBackgroundViewDelegate> *pullToRefresh = [self pullToRefreshViewFromCurrentStyle];
    self.tableView.ins_pullToRefreshBackgroundView.delegate = pullToRefresh;
    [self.tableView.ins_pullToRefreshBackgroundView addSubview:pullToRefresh];
}

- (void)infinitiveScrollSetup {
    [self.tableView ins_addInfinityScrollWithHeight:kInfinitiveScrollHeight handler:^(UIScrollView *scrollView) {
        TWRTweet *lastTweet = [self.viewModel dataObjectAtIndexPath:[[self.tableView indexPathsForVisibleRows] lastObject]];
        NSString *lastTweetID = lastTweet.tweetId;
        
        [self.viewModel checkEnvironmentAndLoadFromTweetID:lastTweetID withCompletion:^(NSError *error) {
            if (error) {
                NSLog(@"Loading error");
            }
            [scrollView ins_endInfinityScrollWithStoppingContentOffset:NO];
        }];
    }];
    
    UIView <INSAnimatable> *infinityIndicator = [self infinityIndicatorViewFromCurrentStyle];
    [self.tableView.ins_infiniteScrollBackgroundView addSubview:infinityIndicator];
    [infinityIndicator startAnimating];
}

- (UIView <INSAnimatable> *)infinityIndicatorViewFromCurrentStyle {
    return [[INSCircleInfiniteIndicator alloc] initWithFrame:CGRectMake(0, 0, kInfinitiveScrollIndicatorDiameter, kInfinitiveScrollIndicatorDiameter)];
}

- (UIView <INSPullToRefreshBackgroundViewDelegate> *)pullToRefreshViewFromCurrentStyle {
    return [[INSTwitterPullToRefresh alloc] initWithFrame:CGRectMake(0, 0, kPullRefreshIndicatorDiameter, kPullRefreshIndicatorDiameter)];
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewModel numberOfDataSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfObjectsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kEstimatedCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TWRTweet *tweet = [self.viewModel dataObjectAtIndexPath:indexPath];
    
    BOOL isMedia = tweet.medias.count > 0;
    BOOL isRetwitted = tweet.isRetwitted.boolValue;
    
    return [TWRTwitCell cellHeightForTableViewWidth:CGRectGetWidth(tableView.frame) tweetText:tweet.text mediaPresent:isMedia retwitted:isRetwitted];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TWRTwitCell *cell = [tableView dequeueReusableCellWithIdentifier:[TWRTwitCell identifier] forIndexPath:indexPath];
    
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Cells configuring

- (void)configureCell:(TWRTwitCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    TWRTweet *tweet = [self.viewModel dataObjectAtIndexPath:indexPath];
    
    [cell setAuthorName:tweet.userName];
    [cell setAuthorNickname:tweet.userNickname];
    [cell setTwitText:tweet.text];
    [cell setAuthorAvatarByURLStr:tweet.userAvatarURL];
    [cell setLocationBtnVisible:(tweet.place) ? YES : NO];
    [cell setTweetTime:[tweet.createdAt formattedAsTimeAgo]];
    
    if (tweet.isRetwitted.boolValue) {
        [cell setRetwittedViewVisible:YES withRetweetAuthor:tweet.retwittedBy];
    }
    else {
        [cell setRetwittedViewVisible:NO withRetweetAuthor:nil];
    }
    
    [self setActionsHandlersForCell:cell tweet:tweet];
}

- (void)setActionsHandlersForCell:(TWRTwitCell *)cell tweet:(TWRTweet *)tweet {
    __weak typeof(self)weakSelf = self;
    
    cell.webLinkClickedBlock = ^(NSURL *url) {
        [weakSelf tweet:tweet clickedURL:url];
    };
    
    cell.hashtagClickedBlock = ^(NSString *hashtag) {
        [weakSelf tweet:tweet clickedHashtag:hashtag];
    };
    
    cell.locationBtnClickedBlock = ^() {
        [weakSelf tweet:tweet clickedLocation:CLLocationCoordinate2DMake(tweet.place.lattitude, tweet.place.longitude)];
    };
    
    cell.mediaClickedBlock = ^(BOOL isVideo, NSUInteger index) {
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
    [[UIApplication sharedApplication] openURL:url];
}

- (void)tweet:(nullable TWRTweet *)tweet clickedHashtag:(NSString *)hashtag {
    TWRFeedVC *feedVC = [self.storyboard instantiateViewControllerWithIdentifier:[TWRFeedVC identifier]];
    feedVC.hashTag = hashtag;
    [self.navigationController pushViewController:feedVC animated:YES];
}

- (void)tweet:(TWRTweet *)tweet clickedLocation:(CLLocationCoordinate2D)location {
    TWRLocationVC *locationVC = [self.storyboard instantiateViewControllerWithIdentifier:[TWRLocationVC identifier]];
    locationVC.coordinates = location;
    [self.navigationController pushViewController:locationVC animated:YES];
}

- (void)tweet:(TWRTweet *)tweet clickedYoutubeVideoPath:(NSString *)videoPath {
    UINavigationController *videoRootNavC = [self.storyboard instantiateViewControllerWithIdentifier:[TWRYoutubeVideoVC rootNavigationIdentifier]];
    TWRYoutubeVideoVC *videoVC = [[videoRootNavC childViewControllers] firstObject];
    videoVC.youtubeLinkStr = videoPath;
    [self presentViewController:videoRootNavC animated:YES completion:nil];
}

- (void)tweet:(TWRTweet *)tweet clickedImages:(NSArray *)imagesURLs {
    TWRGalleryDelegate *galleryDelegate = [[TWRGalleryDelegate alloc] initWithImagesURLs:imagesURLs];
    EBPhotoPagesController *photoPagesController = [[EBPhotoPagesController alloc] initWithDataSource:galleryDelegate delegate:galleryDelegate];
    [self presentViewController:photoPagesController animated:YES completion:nil];
}

@end
