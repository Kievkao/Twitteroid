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
#import "TWRHashTweetsVC.h"
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

@interface TWRFeedVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) TWRFeedViewModel *viewModel;

@end

// TODO: rework to MVMC
@implementation TWRFeedVC

#pragma mark - UIViewController lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.viewModel = [[TWRFeedViewModel alloc] initWithHashtag:nil];
    [self setupNavigationBar];
    [self pullToRefreshSetup];
    [self infinitiveScrollSetup];
    [self.viewModel startFetching];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)settingsBtnClicked {
    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:[TWRSettingsVC rootNavControllerIdentifier]] animated:YES completion:nil];
}

- (NSString *)tweetsHashtag {
    return nil;
}

#pragma mark - Data loading

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

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kEstimatedCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TWRTweet *tweet = [self.viewModel dataObjectAtIndexPath:indexPath];
    
    BOOL isMedia = NO;
    if (tweet.medias.count) {
        isMedia = YES;
    }
    
    BOOL isRetwitted = NO;
    if (tweet.isRetwitted.boolValue) {
        isRetwitted = YES;
    }
    
    return [TWRTwitCell cellHeightForTableViewWidth:CGRectGetWidth(tableView.frame) tweetText:tweet.text mediaPresent:isMedia retwitted:isRetwitted];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfObjectsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TWRTwitCell* cell = [tableView dequeueReusableCellWithIdentifier:[TWRTwitCell identifier] forIndexPath:indexPath];
    [self configureCell:cell forIndexPath:indexPath];
    return cell;
}

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
    
    __weak typeof(self)weakSelf = self;
    cell.webLinkClickedBlock = ^(NSURL *url) {
        [[UIApplication sharedApplication] openURL:url];
    };
    
    cell.hashtagClickedBlock = ^(NSString *hashtag) {
        TWRHashTweetsVC *hashVC = [weakSelf.storyboard instantiateViewControllerWithIdentifier:[TWRHashTweetsVC identifier]];
        hashVC.hashTag = hashtag;
        [weakSelf.navigationController pushViewController:hashVC animated:YES];
    };
    
    cell.locationBtnClickedBlock = ^() {
        TWRLocationVC *locationVC = [weakSelf.storyboard instantiateViewControllerWithIdentifier:[TWRLocationVC identifier]];
        locationVC.coordinates = CLLocationCoordinate2DMake(tweet.place.lattitude, tweet.place.longitude);
        [weakSelf.navigationController pushViewController:locationVC animated:YES];
    };
    
    cell.mediaClickedBlock = ^(BOOL isVideo, NSUInteger index) {
        
        NSMutableArray *mediasURLs = [NSMutableArray new];
        
        for (TWRMedia *media in tweet.medias) {
            [mediasURLs addObject:media.mediaURL];
        }
        
        if (isVideo) {
            UINavigationController *videoRootNavC = [weakSelf.storyboard instantiateViewControllerWithIdentifier:[TWRYoutubeVideoVC rootNavigationIdentifier]];
            TWRYoutubeVideoVC *videoVC = [[videoRootNavC childViewControllers] firstObject];
            videoVC.youtubeLinkStr = mediasURLs[index];
            [weakSelf presentViewController:videoRootNavC animated:YES completion:nil];
        }
        else {
            [mediasURLs replaceObjectAtIndex:0 withObject:[mediasURLs objectAtIndex:index]];

            TWRGalleryDelegate *galleryDelegate = [[TWRGalleryDelegate alloc] initWithImagesURLs:mediasURLs];
            EBPhotoPagesController *photoPagesController = [[EBPhotoPagesController alloc] initWithDataSource:galleryDelegate delegate:galleryDelegate];
            [weakSelf presentViewController:photoPagesController animated:YES completion:nil];
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

#pragma mark - Helpers
+ (NSString *)identifier {
    return @"TWRFeedVC";
}

- (void)setupNavigationBar {
    UIBarButtonItem *settingsBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settingsIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(settingsBtnClicked)];
    [self.navigationItem setRightBarButtonItem:settingsBarItem animated:YES];
}

@end
