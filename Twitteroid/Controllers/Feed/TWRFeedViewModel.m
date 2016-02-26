//
//  TWRFeedViewModel.m
//  Twitteroid
//
//  Created by Andrii Kravchenko on 2/14/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "TWRCoreDataManager.h"
#import "TWRFeedViewModel.h"
#import "Reachability.h"
#import "TWRTwitterAPIManager+TWRFeed.h"
#import "TWRTwitterAPIManager+TWRLogin.h"
#import "TWRTweet.h"
#import "TWRHashtag.h"
#import "TWRMedia.h"
#import "TWRPlace.h"
#import "NSDateFormatter+LocaleAdditions.h"

static NSUInteger const kTweetsLoadingPortion = 20;
static NSString *const kAppErrorDomain = @"com.kievkao.Twitteroid";

@interface TWRFeedViewModel() <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSString *hashTag;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation TWRFeedViewModel

- (instancetype)initWithHashtag:(NSString *)hashtag delegate:(UIViewController<TWRFeedViewModelDelegate> *)delegate {
    self = [super init];
    if (self) {
        _hashTag = hashtag;
        _delegate = delegate;
    }
    return self;
}

- (NSUInteger)numberOfDataSections {
    return [[self.fetchedResultsController sections] count];
}

- (NSUInteger)numberOfObjectsInSection:(NSUInteger)section {
    NSArray *sections = [self.fetchedResultsController sections];
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];

    return [sectionInfo numberOfObjects];
}

- (id)dataObjectAtIndexPath:(NSIndexPath *)indexPath {
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

#pragma mark - NSFetchedResultsController
- (void)startFetching {
    
    [self checkEnvironmentAndLoadFromTweetID:nil withCompletion:^(NSError *error) {
        if (!error) {
            [self.delegate needToReloadData];
        }
    }];
    
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    
    if (error) {
        [self.delegate showAlertWithTitle:NSLocalizedString(@"Error", @"Error title") text:error.localizedDescription];
    }
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.delegate viewModelWillChangeContent];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.delegate viewModelDidChangeContent];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.delegate rowNeedToBeInserted:newIndexPath];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self.delegate rowNeedToBeDeleted:newIndexPath];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            [self.delegate rowNeedToBeUpdated:indexPath];
            break;
        }
        case NSFetchedResultsChangeMove: {
            [self.delegate rowNeedToBeMoved:indexPath newIndexPath:newIndexPath];
            break;
        }
    }
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (!_fetchedResultsController) {
        _fetchedResultsController = [[TWRCoreDataManager sharedInstance] fetchedResultsControllerForTweetsHashtag:self.hashTag];
        _fetchedResultsController.delegate = self;
    }
    return _fetchedResultsController;
}


- (void)checkEnvironmentAndLoadFromTweetID:(NSString *)tweetID withCompletion:(void (^)(NSError *error))loadingCompletion {
    
    BOOL isSessionLoginDone = [[TWRTwitterAPIManager sharedInstance] isSessionLoginDone];
    BOOL isInternetActive = [self isInternetActive];
    
    if (!isInternetActive) {
        [self.delegate showAlertWithTitle:NSLocalizedString(@"Connection Failed", @"Connection Failed") text:NSLocalizedString(@"Please check your internet connection", @"Please check your internet connection")];
        loadingCompletion([NSError new]);
    }
    else if (!isSessionLoginDone) {
        [[TWRTwitterAPIManager sharedInstance] reloginWithCompletion:^(NSError *error) {
            if (!error) {
                [self loadFromTweetID:tweetID withCompletion:loadingCompletion];
            }
            else {
                [self.delegate showAlertWithTitle:NSLocalizedString(@"Error", @"Error title") text:error.localizedDescription];
            }
        }];
    }
    else {
        [self loadFromTweetID:tweetID withCompletion:loadingCompletion];
    }
}

- (void)loadFromTweetID:(NSString *)tweetID withCompletion:(void (^)(NSError *error))loadingCompletion {
    
    [[TWRTwitterAPIManager sharedInstance] getFeedOlderThatTwitID:tweetID count:kTweetsLoadingPortion completion:^(NSError *error, NSArray *items) {
        if (!error) {
            [self parseTweetsArray:items forHashtag:self.hashTag];
            [[TWRCoreDataManager sharedInstance] saveContext];
        }
        else {
            NSLog(@"Loading error");
        }
        
        loadingCompletion(error);
    }];
}

#pragma mark - CoreData
- (void)parseTweetsArray:(NSArray *)items forHashtag:(NSString *)hashtag {
    
    for (NSDictionary *oneItem in items) {
        NSDate *tweetDate = [self.dateFormatter dateFromString:oneItem[@"created_at"]];
        
        if ([[TWRCoreDataManager sharedInstance] isExistsTweetWithID:oneItem[@"id_str"] forHashtag:hashtag] ||
            ![[TWRCoreDataManager sharedInstance] isTweetDateIsAllowed:tweetDate]) {
            continue;
        }
        
        TWRTweet *tweet = (TWRTweet *)[[TWRCoreDataManager sharedInstance] insertNewEntity:[TWRTweet class]];
        
        tweet.createdAt = tweetDate;
        tweet.tweetId = oneItem[@"id_str"];
        
        if (hashtag) {
            tweet.hashtag = hashtag;
        }
        
        NSDictionary *bodyDict = nil;
        
        if (oneItem[@"retweeted_status"]) {
            
            bodyDict = oneItem[@"retweeted_status"];
            tweet.isRetwitted = @(YES);
            
            NSArray *mentions = oneItem[@"entities"][@"user_mentions"];
            NSDictionary *userMention = [mentions firstObject];
            tweet.userName = userMention[@"name"];
            tweet.userNickname = userMention[@"screen_name"];
            
            NSDictionary *userInfoDict = oneItem[@"retweeted_status"][@"user"];
            tweet.userAvatarURL = userInfoDict[@"profile_image_url"];
            
            NSDictionary *whoRetweeted = oneItem[@"user"];
            tweet.retwittedBy = whoRetweeted[@"screen_name"];
        }
        else {
            bodyDict = oneItem;
            tweet.isRetwitted = @(NO);
            NSDictionary *userInfoDict = oneItem[@"user"];
            tweet.userAvatarURL = userInfoDict[@"profile_image_url"];
            tweet.userName = userInfoDict[@"name"];
            tweet.userNickname = userInfoDict[@"screen_name"];
        }
        
        if (![bodyDict[@"place"] isKindOfClass:[NSNull class]]) {
            NSDictionary *placeDict = bodyDict[@"place"];
            NSDictionary *boundingBoxDict = placeDict[@"bounding_box"];
            NSArray *coordinates = boundingBoxDict[@"coordinates"][0];
            
            double lattitude = 0;
            double longitude = 0;
            
            for (NSArray *latLongPair in coordinates) {
                lattitude += [[latLongPair lastObject] doubleValue];
                longitude += [[latLongPair firstObject] doubleValue];
            }
            
            lattitude /= coordinates.count;
            longitude /= coordinates.count;
            
            TWRPlace *place = (TWRPlace *)[[TWRCoreDataManager sharedInstance] insertNewEntity:[TWRPlace class]];
            place.lattitude = lattitude;
            place.longitude = longitude;
            place.tweet = tweet;
            
            tweet.place = place;
        }
        
        tweet.text = bodyDict[@"text"];
        
        if (![oneItem[@"entities"] isKindOfClass:[NSNull class]]) {
            NSDictionary *entitiesDict = oneItem[@"entities"];
            
            if (![entitiesDict[@"hashtags"] isKindOfClass:[NSNull class]]) {
                NSArray *hastagsArray = entitiesDict[@"hashtags"];
                
                NSMutableSet *hashtags = [NSMutableSet set];
                
                for (NSDictionary *hash in hastagsArray) {
                    NSArray *indicies = hash[@"indicies"];
                    TWRHashtag *hashtag = (TWRHashtag *)[[TWRCoreDataManager sharedInstance] insertNewEntity:[TWRHashtag class]];
                    hashtag.startIndex = [[indicies firstObject] intValue];
                    hashtag.endIndex = [[indicies lastObject] intValue];
                    hashtag.text = hash[@"text"];
                    hashtag.tweet = tweet;
                    
                    [hashtags addObject:hashtag];
                }
                tweet.hashtags = hashtags;
            }
            
        }
        
        if (oneItem[@"extended_entities"]) {
            NSDictionary *extEntities = oneItem[@"extended_entities"];
            NSArray *mediaArray = extEntities[@"media"];
            NSMutableSet *tweetMedias = [NSMutableSet new];
            
            for (NSDictionary *mediaDict in mediaArray) {
                TWRMedia *media = (TWRMedia *)[[TWRCoreDataManager sharedInstance] insertNewEntity:[TWRMedia class]];
                media.mediaURL = mediaDict[@"media_url"];
                media.tweet = tweet;
                media.isPhoto = YES;
                
                [tweetMedias addObject:media];
            }
            
            tweet.medias = tweetMedias;
        }
        else if (oneItem[@"entities"]) {
            NSDictionary *entitiesDict = oneItem[@"entities"];
            NSArray *urls = entitiesDict[@"urls"];
            NSMutableSet *tweetUrls = [NSMutableSet new];
            
            if (![urls isKindOfClass:[NSNull class]]) {
                for (NSDictionary *urlDict in urls) {
                    if ([self isYoutubeLink:urlDict[@"expanded_url"]]) {
                        TWRMedia *media = (TWRMedia *)[[TWRCoreDataManager sharedInstance] insertNewEntity:[TWRMedia class]];
                        media.mediaURL = urlDict[@"expanded_url"];
                        media.tweet = tweet;
                        media.isPhoto = NO;
                        
                        [tweetUrls addObject:media];
                    }
                }
                
                tweet.medias = tweetUrls;
            }
        }
    }
}

- (BOOL)isYoutubeLink:(NSString *)urlStr {
    //@"www.youtube.com"
    //@"youtu.be"
    //@"m.youtube.com"
    return [urlStr containsString:@"youtu"];
}

- (BOOL)isInternetActive {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    return !(networkStatus == NotReachable);
}

@end
