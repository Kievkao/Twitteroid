//
//  TWRTwitCell.h
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRBaseTableViewCell.h"

@interface TWRTwitCell : TWRBaseTableViewCell

@property (nonatomic, strong) void (^webLinkClickedBlock)(NSURL *clickedUrl);

+ (CGFloat)cellHeightForTableViewWidth:(CGFloat)tableViewWidth tweetText:(NSString *)text mediaPresent:(BOOL)isMediaPresent;

- (void)setTwitText:(NSString *)text;
- (void)setAuthorName:(NSString *)name;
- (void)setAuthorNickname:(NSString *)nickname;
- (void)setAuthorAvatarByURLStr:(NSString *)avatarUrl;

- (void)setImagesURLs:(NSArray *)imagesURLs;
- (void)setLinksURLs:(NSArray *)linksURLs;
- (void)hideMediaFrame;

@end
