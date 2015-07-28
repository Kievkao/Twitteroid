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

static CGFloat const kCellContentSideSpace = 8.0;
static CGFloat const kBackViewSideSpace = 8.0;
static CGFloat const kTweetTextTopToBackViewSpace = 32.0;
static CGFloat const kAuthorAvatarImageViewWidth = 43.0;

static CGFloat const kTweetTextBottomSpace = 4.0;
static CGFloat const kMediaViewBottomSpace = 4.0;

@interface TWRTwitCell()

@property (weak, nonatomic) IBOutlet STTweetLabel *twitTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *authorAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorNickNameLabel;
@property (weak, nonatomic) IBOutlet TWRCellMediaView *mediaView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mediaViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;

@end

@implementation TWRTwitCell

+ (NSString *)identifier {
    return @"TWRTwitCell";
}

+ (CGFloat)cellHeightForTableViewWidth:(CGFloat)tableViewWidth tweetText:(NSString *)text mediaPresent:(BOOL)isMediaPresent {
    
    CGFloat fixedSpaces = kBackViewSideSpace + kBackViewSideSpace + kTweetTextTopToBackViewSpace + kTweetTextBottomSpace + kMediaViewBottomSpace;
    
    if (isMediaPresent) {
        fixedSpaces += IS_IPHONE ? kIPhoneMediaHeight : kIPadMediaHeight;
    }
    
    CGFloat tweetTextLabelWidth = tableViewWidth - kCellContentSideSpace*5 - kAuthorAvatarImageViewWidth;
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
    
    
    [self.mediaView setMediaClickedBlock:^(NSUInteger index) {
        if (weakSelf.imageClickedBlock) {
            weakSelf.imageClickedBlock(index);
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

- (void)setImagesURLs:(NSArray *)imagesURLs {
    self.mediaViewHeight.constant = IS_IPHONE ? kIPhoneMediaHeight : kIPadMediaHeight;
    [self.mediaView setImages:imagesURLs];
}

- (void)setLinksURLs:(NSArray *)linksURLs {
    self.mediaViewHeight.constant = IS_IPHONE ? kIPhoneMediaHeight : kIPadMediaHeight;
    [self.mediaView setLinks:linksURLs];
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
