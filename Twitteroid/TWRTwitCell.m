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

@end

@implementation TWRTwitCell

+ (NSString *)identifier {
    return @"TWRTwitCell";
}

+ (CGFloat)cellHeightForTableViewWidth:(CGFloat)tableViewWidth tweetText:(NSString *)text mediaPresent:(BOOL)isMediaPresent {
    
    // TODO: PROCESS MEDIA FLAG
    CGFloat fixedSpaces = kBackViewSideSpace + kBackViewSideSpace + kTweetTextTopToBackViewSpace + kTweetTextBottomSpace + kMediaViewBottomSpace;
    
    CGFloat tweetTextLabelWidth = tableViewWidth - kCellContentSideSpace*5 - kAuthorAvatarImageViewWidth;
    CGSize maxTweetTextLabelSize = CGSizeMake(tweetTextLabelWidth, MAXFLOAT);
    
    CGRect rectForTweetText = [text boundingRectWithSize:maxTweetTextLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont tweetTextFont]} context:nil];
    
    CGFloat calculedCellHeight = rectForTweetText.size.height + fixedSpaces;
    
    return MAX(calculedCellHeight, kMinimumCellHeight);
}

- (void)awakeFromNib {
    
    [self.twitTextLabel setDetectionBlock:^(STTweetHotWord hotWordType, NSString *string, NSString *protocol, NSRange range) {
        NSLog(@"Something was clicked");
    }];
}

- (void)setTwitText:(NSString *)text {
    
    self.twitTextLabel.text = text;
}

@end
