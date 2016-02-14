//
//  TWRCellMediaView.m
//  Twitteroid
//
//  Created by Mac on 25/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRCellMediaView.h"
#import "UIImageView+WebCache.h"

static CGFloat const kMediaFrameDistanceMultiplier = 0.49;

@interface TWRCellMediaView()

@property (nonatomic, strong) NSMutableArray *mediaFrames;

@end

@implementation TWRCellMediaView

- (void)setLinksToMedia:(NSArray *)links isForVideo:(BOOL)isForVideo {
    
    switch (links.count) {
        case 1:
            [self setupOneMedia:links isForVideo:isForVideo];
            break;
            
        case 2:
            [self setupTwoMedias:links isForVideo:isForVideo];
            break;
            
        case 3:
            [self setupThreeMedias:links isForVideo:isForVideo];
            break;
            
        case 4:
            [self setupFourMedias:links isForVideo:isForVideo];
            break;
            
        default:
            break;
    }
}

- (void)removeAllFrames {
    for (UIView *view in self.mediaFrames) {
        [view removeFromSuperview];
    }
    [self.mediaFrames removeAllObjects];
}

- (UIImageView *)createImageViewWithTag:(NSUInteger)tag isForVideo:(BOOL)isForVideo {
    
    UIImageView *imageView = [[UIImageView alloc] initForAutoLayout];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = YES;
    imageView.tag = tag;
    UITapGestureRecognizer *gestureRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:(isForVideo) ? @selector(handleVideoTapFrom:) : @selector(handleImageTapFrom:)];
    [imageView addGestureRecognizer:gestureRec];
    
    [self addSubview:imageView];
    [self.mediaFrames addObject:imageView];
    
    return imageView;
}

- (void)handleImageTapFrom:(UITapGestureRecognizer *)recognizer {
    UIImageView *tappedView = (UIImageView *)recognizer.view;
    
    if (self.mediaClickedBlock) {
        self.mediaClickedBlock(NO, tappedView.tag);
    }
}

- (void)handleVideoTapFrom:(UITapGestureRecognizer *)recognizer {
    UIImageView *tappedView = (UIImageView *)recognizer.view;
    
    if (self.mediaClickedBlock) {
        self.mediaClickedBlock(YES, tappedView.tag);
    }
}

- (void)setupOneMedia:(NSArray *)images isForVideo:(BOOL)isForVideo {
    
    UIImageView *imageView = [self createImageViewWithTag:0 isForVideo:isForVideo];
    
    if (isForVideo) {
        [imageView setImage:[UIImage videoPlaceholder]];
    }
    else {
        [imageView sd_setImageWithURL:[NSURL URLWithString:[images firstObject]] placeholderImage:[UIImage mediaImagePlaceholder]];
    }
    
    [imageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}

- (void)setupTwoMedias:(NSArray *)links isForVideo:(BOOL)isForVideo {

    UIImageView *imageView1 = [self createImageViewWithTag:0 isForVideo:isForVideo];
    UIImageView *imageView2 = [self createImageViewWithTag:1 isForVideo:isForVideo];
    
    if (isForVideo) {
        [imageView1 setImage:[UIImage videoPlaceholder]];
        [imageView2 setImage:[UIImage videoPlaceholder]];
    }
    else {
        [imageView1 sd_setImageWithURL:[NSURL URLWithString:[links firstObject]] placeholderImage:[UIImage mediaImagePlaceholder]];
        [imageView2 sd_setImageWithURL:[NSURL URLWithString:[links lastObject]] placeholderImage:[UIImage mediaImagePlaceholder]];
    }
    
    [imageView1 autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [imageView1 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [imageView1 autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [imageView1 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:kMediaFrameDistanceMultiplier];
    
    [imageView2 autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [imageView2 autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [imageView2 autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [imageView2 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:imageView1];
}

- (void)setupThreeMedias:(NSArray *)links isForVideo:(BOOL)isForVideo {
    
    UIImageView *imageView1 = [self createImageViewWithTag:0 isForVideo:isForVideo];
    UIImageView *imageView2 = [self createImageViewWithTag:1 isForVideo:isForVideo];
    UIImageView *imageView3 = [self createImageViewWithTag:2 isForVideo:isForVideo];
    
    if (isForVideo) {
        [imageView1 setImage:[UIImage videoPlaceholder]];
        [imageView2 setImage:[UIImage videoPlaceholder]];
        [imageView3 setImage:[UIImage videoPlaceholder]];
    }
    else {
        [imageView1 sd_setImageWithURL:[NSURL URLWithString:links[0]] placeholderImage:[UIImage mediaImagePlaceholder]];
        [imageView2 sd_setImageWithURL:[NSURL URLWithString:links[1]] placeholderImage:[UIImage mediaImagePlaceholder]];
        [imageView3 sd_setImageWithURL:[NSURL URLWithString:links[2]] placeholderImage:[UIImage mediaImagePlaceholder]];
    }
    
    [imageView1 autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [imageView1 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [imageView1 autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [imageView1 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:kMediaFrameDistanceMultiplier];
    
    [imageView2 autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [imageView2 autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [imageView2 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:imageView1];
    [imageView2 autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:imageView1 withMultiplier:kMediaFrameDistanceMultiplier];
    
    [imageView3 autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [imageView3 autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [imageView3 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:imageView1];
    [imageView3 autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:imageView1 withMultiplier:kMediaFrameDistanceMultiplier];
}

- (void)setupFourMedias:(NSArray *)links isForVideo:(BOOL)isForVideo {
    
    UIImageView *imageView1 = [self createImageViewWithTag:0 isForVideo:isForVideo];
    UIImageView *imageView2 = [self createImageViewWithTag:1 isForVideo:isForVideo];
    UIImageView *imageView3 = [self createImageViewWithTag:2 isForVideo:isForVideo];
    UIImageView *imageView4 = [self createImageViewWithTag:3 isForVideo:isForVideo];
    
    if (isForVideo) {
        [imageView1 setImage:[UIImage videoPlaceholder]];
        [imageView2 setImage:[UIImage videoPlaceholder]];
        [imageView3 setImage:[UIImage videoPlaceholder]];
        [imageView4 setImage:[UIImage videoPlaceholder]];
    }
    else {
        [imageView1 sd_setImageWithURL:[NSURL URLWithString:links[0]] placeholderImage:[UIImage mediaImagePlaceholder]];
        [imageView2 sd_setImageWithURL:[NSURL URLWithString:links[1]] placeholderImage:[UIImage mediaImagePlaceholder]];
        [imageView3 sd_setImageWithURL:[NSURL URLWithString:links[2]] placeholderImage:[UIImage mediaImagePlaceholder]];
        [imageView4 sd_setImageWithURL:[NSURL URLWithString:links[3]] placeholderImage:[UIImage mediaImagePlaceholder]];
    }
    
    [imageView1 autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [imageView1 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [imageView1 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:kMediaFrameDistanceMultiplier];
    [imageView1 autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self withMultiplier:kMediaFrameDistanceMultiplier];
    
    [imageView2 autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [imageView2 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [imageView2 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:kMediaFrameDistanceMultiplier];
    [imageView2 autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self withMultiplier:kMediaFrameDistanceMultiplier];

    [imageView3 autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [imageView3 autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [imageView3 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:kMediaFrameDistanceMultiplier];
    [imageView3 autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self withMultiplier:kMediaFrameDistanceMultiplier];

    [imageView4 autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [imageView4 autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [imageView4 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:kMediaFrameDistanceMultiplier];
    [imageView4 autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self withMultiplier:kMediaFrameDistanceMultiplier];

}

- (NSMutableArray *)mediaFrames {
    
    if (!_mediaFrames) {
        _mediaFrames = [NSMutableArray new];
    }
    
    return _mediaFrames;
}

@end
