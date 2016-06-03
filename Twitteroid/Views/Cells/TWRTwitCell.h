//
//  TWRTwitCell.h
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWRTwitCell : UITableViewCell<TWRCellIdentifier>

@property (nonatomic, strong) void (^hashtagClickBlock)(NSString *hashtag);
@property (nonatomic, strong) void (^webLinkClickBlock)(NSURL *clickedUrl);
@property (nonatomic, strong) void (^locationButtonClickBlock)();
@property (nonatomic, strong) void (^mediaClickBlock)(BOOL isVideo, NSUInteger index);

+ (CGFloat)cellHeightForTableViewWidth:(CGFloat)tableViewWidth
                             tweetText:(NSString *)text
                          mediaPresent:(BOOL)isMediaPresent
                             retwitted:(BOOL)isRetwitted;

- (void)setTweetText:(NSString *)text;
- (void)setAuthorName:(NSString *)name;
- (void)setAuthorNickname:(NSString *)nickname;
- (void)setAuthorAvatarFromURLString:(NSString *)avatarUrl;

- (void)setImagesURLs:(NSArray *)imagesURLs;
- (void)setVideoURLs:(NSArray *)linksURLs;
- (void)hideMediaFrame;
- (void)setLocationButtonVisible:(BOOL)visible;
- (void)setRetwittedViewVisible:(BOOL)visible withRetweetAuthor:(NSString *)author;
- (void)setTweetTime:(NSString *)timeString;

@end
