//
//  TWRFeedVC.m
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRFeedVC.h"
#import "TWRTwitCell.h"
#import "TWRTwitterAPIManager+TWRFeed.h"
#import "UIScrollView+INSPullToRefresh.h"
#import "INSAnimatable.h"
#import "INSTwitterPullToRefresh.h"
#import "INSPullToRefreshBackgroundView.h"
#import "INSCircleInfiniteIndicator.h"

@interface TWRFeedVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TWRFeedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self pullToRefreshSetup];
    [self infinitiveScrollSetup];
    
//    [[TWRTwitterAPIManager sharedInstance] getFeedSinceTwitID:nil count:20 completion:^(NSError *error, NSArray *items) {
//        NSLog(@"hello");
//    }];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - Infinitive scroll && PullToRefresh
- (void)pullToRefreshSetup {
    [self.tableView ins_addPullToRefreshWithHeight:60.0 handler:^(UIScrollView *scrollView) {
        int64_t delayInSeconds = 1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [scrollView ins_endPullToRefresh];
        });
    }];
    
    UIView <INSPullToRefreshBackgroundViewDelegate> *pullToRefresh = [self pullToRefreshViewFromCurrentStyle];
    self.tableView.ins_pullToRefreshBackgroundView.delegate = pullToRefresh;
    [self.tableView.ins_pullToRefreshBackgroundView addSubview:pullToRefresh];
}

- (void)infinitiveScrollSetup {
    [self.tableView ins_addInfinityScrollWithHeight:60 handler:^(UIScrollView *scrollView) {
        
        int64_t delayInSeconds = 1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [scrollView ins_endInfinityScrollWithStoppingContentOffset:YES];
        });
    }];
    
    UIView <INSAnimatable> *infinityIndicator = [self infinityIndicatorViewFromCurrentStyle];
    [self.tableView.ins_infiniteScrollBackgroundView addSubview:infinityIndicator];
    [infinityIndicator startAnimating];
}

- (UIView <INSAnimatable> *)infinityIndicatorViewFromCurrentStyle {
    return [[INSCircleInfiniteIndicator alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
}

- (UIView <INSPullToRefreshBackgroundViewDelegate> *)pullToRefreshViewFromCurrentStyle {
    return [[INSTwitterPullToRefresh alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
}

#pragma mark - UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    TWRTwitCell* cell = [tableView dequeueReusableCellWithIdentifier:[TWRTwitCell identifier] forIndexPath:indexPath];
    
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(TWRTwitCell *)cell forIndexPath:(NSIndexPath *)indePath {
    
}

+ (NSString *)identifier {
    return @"TWRFeedVC";
}

@end
