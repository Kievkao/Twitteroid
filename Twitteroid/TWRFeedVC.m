//
//  TWRFeedVC.m
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "TWRFeedVC.h"
#import "TWRTwitCell.h"
#import "TWRTwitterAPIManager+TWRFeed.h"
#import "TWRCoreDataManager.h"
#import "TWRTweet.h"
#import "TWRHashtag.h"
#import "TWRMedia.h"
#import "NSDateFormatter+LocaleAdditions.h"
#import "UIScrollView+INSPullToRefresh.h"
#import "INSTwitterPullToRefresh.h"
#import "INSCircleInfiniteIndicator.h"

static NSUInteger const kTweetsLoadingPortion = 20;

@interface TWRFeedVC () <NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation TWRFeedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self pullToRefreshSetup];
    [self infinitiveScrollSetup];
    [self startFetching];
    
    [[TWRTwitterAPIManager sharedInstance] getFeedSinceTwitID:nil count:kTweetsLoadingPortion completion:^(NSError *error, NSArray *items) {
        if (!error) {
            [self parseTweetsArray:items];
        }
        else {
            NSLog(@"Loading error");
        }
    }];
}

- (void)parseTweetsArray:(NSArray *)items {
    
    for (NSDictionary *oneItem in items) {
        
        TWRTweet *tweet = [TWRCoreDataManager insertNewTweetInContext:[TWRCoreDataManager mainContext]];
        
        tweet.createdAt = [self.dateFormatter dateFromString:oneItem[@"created_at"]];
        
        NSDictionary *userInfoDict = oneItem[@"user"];
        tweet.userAvatarURL = userInfoDict[@"profile_image_url"];
        tweet.userName = userInfoDict[@"name"];
        tweet.userNickname = userInfoDict[@"screen_name"];
        tweet.tweetId = oneItem[@"id_str"];
        tweet.text = oneItem[@"text"];
        
        if (![oneItem[@"place"] isKindOfClass:[NSNull class]]) {
            NSDictionary *placeDict = oneItem[@"place"];
            NSDictionary *boundingBoxDict = placeDict[@"bounding_box"];
            NSArray *coordinates = boundingBoxDict[@"coordinates"];
        }
        
        if (![oneItem[@"entities"] isKindOfClass:[NSNull class]]) {
            NSDictionary *entitiesDict = oneItem[@"entities"];
            
            if (![entitiesDict[@"hashtags"] isKindOfClass:[NSNull class]]) {
                NSArray *hastagsArray = entitiesDict[@"hashtags"];
                
                NSMutableSet *hashtags = [NSMutableSet set];
                
                for (NSDictionary *hash in hastagsArray) {
                    
                    NSArray *indicies = hash[@"indicies"];
                    TWRHashtag *hashtag = [TWRCoreDataManager insertNewHashtagInContext:[TWRCoreDataManager mainContext]];
                    hashtag.startIndex = [[indicies firstObject] intValue];
                    hashtag.endIndex = [[indicies lastObject] intValue];
                    hashtag.text = hash[@"text"];
                    hashtag.tweet = tweet;
                    
                    [hashtags addObject:hashtag];
                }
                
                tweet.hashtags = hashtags;
            }
            
            if (![entitiesDict[@"media"] isKindOfClass:[NSNull class]]) {
                NSArray *mediaArray = entitiesDict[@"media"];\
                NSDictionary *mediaDict = [mediaArray firstObject];
                
                TWRMedia *media = [TWRCoreDataManager insertNewMediaInContext:[TWRCoreDataManager mainContext]];
                media.mediaURL = mediaDict[@"media_url"];
                media.tweet = tweet;
                
                tweet.medias = [NSSet setWithObject:media];
            }
        }
    }
}

- (NSDateFormatter *)dateFormatter {
    
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] initWithSafeLocale];
        [_dateFormatter setDateFormat:@"eee MMM dd HH:mm:ss Z yyyy"];
    }
    
    return _dateFormatter;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - NSFetchedResultsController stuff
- (void)startFetching {
    
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    
    if (error) {
        [self showInfoAlertWithTitle:NSLocalizedString(@"Error", @"Error title") text:error.localizedDescription];
    }
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            [self configureCell:(TWRTwitCell *)[self.tableView cellForRowAtIndexPath:indexPath] forIndexPath:indexPath];
            break;
        }
        case NSFetchedResultsChangeMove: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (!_fetchedResultsController) {
        _fetchedResultsController = [TWRCoreDataManager fetchedResultsControllerForTweetsFeed];
        _fetchedResultsController.delegate = self;
    }
    
    return _fetchedResultsController;
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sections = [self.fetchedResultsController sections];
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    TWRTwitCell* cell = [tableView dequeueReusableCellWithIdentifier:[TWRTwitCell identifier] forIndexPath:indexPath];
    
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(TWRTwitCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    
    TWRTweet *tweet = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [cell setTwitText:tweet.text];
}

+ (NSString *)identifier {
    return @"TWRFeedVC";
}

@end
