//
//  TWRTwitCell.m
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRTwitCell.h"
#import "TWRCellMediaView.h"
#import "STTweetLabel.h"

#import "UIImageView+WebCache.h"

static CGFloat const kIPhoneMediaHeight = 200.0;
static CGFloat const kIPadMediaHeight = 300.0;
static CGFloat const kMinimumCellHeight = 75.0;

static CGFloat const kCellSideSpace = 8.0;
static CGFloat const kTweetTextTopToBackViewSpace = 32.0;
static CGFloat const kAuthorAvatarImageViewWidth = 43.0;

static CGFloat const kCellBottomSpace = 4.0;

static CGFloat const kRetweetViewFullHeight = 25.0;

@interface TWRTwitCell()

@property (weak, nonatomic) IBOutlet STTweetLabel *twitTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *authorAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorNickNameLabel;
@property (weak, nonatomic) IBOutlet TWRCellMediaView *mediaView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mediaViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retwitViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *retweetAuthorLabel;

@end

@implementation TWRTwitCell

+ (NSString *)identifier {
    return @"TWRTwitCell";
}

+ (CGFloat)cellHeightForTableViewWidth:(CGFloat)tableViewWidth
                             tweetText:(NSString *)text
                          mediaPresent:(BOOL)isMediaPresent
                             retwitted:(BOOL)isRetwitted {
    
    CGFloat fixedSpaces = kCellSideSpace*2 + kTweetTextTopToBackViewSpace + kCellBottomSpace*2;
    
    if (isMediaPresent) {
        fixedSpaces += IS_IPHONE ? kIPhoneMediaHeight : kIPadMediaHeight;
    }
    
    if (isRetwitted) {
        fixedSpaces += kRetweetViewFullHeight;
    }
    
    CGFloat tweetTextLabelWidth = tableViewWidth - kCellBottomSpace*5 - kAuthorAvatarImageViewWidth;
    CGSize maxTweetTextLabelSize = CGSizeMake(tweetTextLabelWidth, MAXFLOAT);
    
    CGRect rectForTweetText = [text boundingRectWithSize:maxTweetTextLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont tweetTextFont]} context:nil];
    
    CGFloat calculedCellHeight = rectForTweetText.size.height + fixedSpaces;
    
    return MAX(calculedCellHeight, kMinimumCellHeight);
}

- (void)awakeFromNib {
    
    __weak typeof(self)weakSelf = self;
    
    [self.twitTextLabel setDetectionBlock:^(STTweetHotWord hotWordType, NSString *string, NSString *protocol, NSRange range) {
        switch (hotWordType) {
            case STTweetLink:
                if (weakSelf.webLinkClickedBlock) {
                    weakSelf.webLinkClickedBlock([NSURL URLWithString:string]);
                }
                break;
                
            case STTweetHashtag:
                if (weakSelf.hashtagClickedBlock) {
                    weakSelf.hashtagClickedBlock(string);
                }
                break;
                
            default:
                break;
        }
    }];
    
    
    [self.mediaView setMediaClickedBlock:^(BOOL isVideo, NSUInteger index) {
        if (weakSelf.mediaClickedBlock) {
            weakSelf.mediaClickedBlock(isVideo, index);
        }
    }];
}

- (void)setLocationBtnVisible:(BOOL)visible {
    self.locationBtn.hidden = !visible;
}

- (IBAction)locationBtnClicked:(id)sender {
    
    if (self.locationBtnClickedBlock) {
        self.locationBtnClickedBlock();
    }
}

- (void)hideMediaFrame {
    [self.mediaView removeAllFrames];
    self.mediaViewHeight.constant = 0;
}

- (void)setRetwittedViewVisible:(BOOL)visible withRetweetAuthor:(NSString *)author {
    
    if (visible) {
        self.retwitViewHeight.constant = kRetweetViewFullHeight;
        self.retweetAuthorLabel.text = [NSString stringWithFormat:@"@%@ retweeted", author];
    }
    else {
        self.retwitViewHeight.constant = 0;
    }    
}

- (void)setImagesURLs:(NSArray *)imagesURLs {
    self.mediaViewHeight.constant = IS_IPHONE ? kIPhoneMediaHeight : kIPadMediaHeight;
    [self.mediaView setLinksToMedia:imagesURLs isForVideo:NO];
}

- (void)setVideoURLs:(NSArray *)linksURLs {
    self.mediaViewHeight.constant = IS_IPHONE ? kIPhoneMediaHeight : kIPadMediaHeight;
    [self.mediaView setLinksToMedia:linksURLs isForVideo:YES];
}

- (void)setAuthorName:(NSString *)name {
    self.authorNameLabel.text = name;
}

- (void)setAuthorNickname:(NSString *)nickname {
    self.authorNickNameLabel.text = [NSString stringWithFormat:@"@%@", nickname];
}

- (void)setAuthorAvatarByURLStr:(NSString *)avatarUrl {
    [self.authorAvatarImageView sd_setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:nil];
}

- (void)setTwitText:(NSString *)text {
    self.twitTextLabel.text = text;
}

@end
