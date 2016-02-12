//
//  TWRTwitCell.h
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWRTwitCell : UITableViewCell<TWRCellIdentifier>

@property (nonatomic, strong) void (^hashtagClickedBlock)(NSString *hashtag);
@property (nonatomic, strong) void (^webLinkClickedBlock)(NSURL *clickedUrl);
@property (nonatomic, strong) void (^locationBtnClickedBlock)();
@property (nonatomic, strong) void (^mediaClickedBlock)(BOOL isVideo, NSUInteger index);

+ (CGFloat)cellHeightForTableViewWidth:(CGFloat)tableViewWidth
                             tweetText:(NSString *)text
                          mediaPresent:(BOOL)isMediaPresent
                             retwitted:(BOOL)isRetwitted;

- (void)setTwitText:(NSString *)text;
- (void)setAuthorName:(NSString *)name;
- (void)setAuthorNickname:(NSString *)nickname;
- (void)setAuthorAvatarByURLStr:(NSString *)avatarUrl;

- (void)setImagesURLs:(NSArray *)imagesURLs;
- (void)setVideoURLs:(NSArray *)linksURLs;
- (void)hideMediaFrame;
- (void)setLocationBtnVisible:(BOOL)visible;
- (void)setRetwittedViewVisible:(BOOL)visible withRetweetAuthor:(NSString *)author;
- (void)setTweetTime:(NSString *)timeStr;

@end