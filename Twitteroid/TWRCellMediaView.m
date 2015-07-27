//
//  TWRCellMediaView.m
//  Twitteroid
//
//  Created by Mac on 25/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRCellMediaView.h"
#import "UIImageView+WebCache.h"
#import "YTPlayerView.h"

@interface TWRCellMediaView()

@property (nonatomic, strong) NSMutableArray *mediaFrames;

@end

@implementation TWRCellMediaView

- (void)setImages:(NSArray *)images {
    
    switch (images.count) {
        case 1:
            [self setupOneImage:images];
            break;
            
        case 2:
            [self setupTwoImages:images];
            break;
            
        case 3:
            [self setupThreeImages:images];
            break;
            
        case 4:
            [self setupFourImages:images];
            break;
            
        default:
            break;
    }
}

- (void)setLinks:(NSArray *)links {
    
    switch (links.count) {
        case 1:
            [self setupYoutubeWebView:links];
            break;
            
        default:
            break;
    }
}

- (void)setupYoutubeWebView:(NSArray *)links {
    
    YTPlayerView *playerView = [[YTPlayerView alloc] initForAutoLayout];
    NSString *lastPath = [[links firstObject] lastPathComponent];
    [self addSubview:playerView];
    [self.mediaFrames addObject:playerView];
    [playerView loadWithVideoId:lastPath];
    
    [playerView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}
- (void)removeAllFrames {
    
    for (UIView *view in self.mediaFrames) {
        [view removeFromSuperview];
    }
    
    [self.mediaFrames removeAllObjects];
}

- (UIImageView *)createImageViewWithTag:(NSUInteger)tag {
    
    UIImageView *imageView = [[UIImageView alloc] initForAutoLayout];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = YES;
    imageView.tag = tag;
    UITapGestureRecognizer *gestureRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageTapFrom:)];
    [imageView addGestureRecognizer:gestureRec];
    
    [self addSubview:imageView];
    [self.mediaFrames addObject:imageView];
    
    return imageView;
}

- (void)handleImageTapFrom:(UITapGestureRecognizer *)recognizer
{
    UIImageView *tappedView = (UIImageView *)recognizer.view;
    
    if (self.mediaClickedBlock) {
        self.mediaClickedBlock(tappedView.tag);
    }
}

- (void)setupOneImage:(NSArray *)images {
    
    UIImageView *imageView = [self createImageViewWithTag:0];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:[images firstObject]] placeholderImage:[UIImage mediaImagePlaceholder]];
    [imageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}

- (void)setupTwoImages:(NSArray *)images {

    UIImageView *imageView1 = [self createImageViewWithTag:0];
    UIImageView *imageView2 = [self createImageViewWithTag:1];
    
    [imageView1 sd_setImageWithURL:[NSURL URLWithString:[images firstObject]] placeholderImage:[UIImage mediaImagePlaceholder]];
    [imageView2 sd_setImageWithURL:[NSURL URLWithString:[images lastObject]] placeholderImage:[UIImage mediaImagePlaceholder]];
    
    [imageView1 autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [imageView1 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [imageView1 autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [imageView1 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.5];
    
    [imageView2 autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [imageView2 autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [imageView2 autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [imageView2 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:imageView1];
}

- (void)setupThreeImages:(NSArray *)images {
    
    UIImageView *imageView1 = [self createImageViewWithTag:0];
    UIImageView *imageView2 = [self createImageViewWithTag:1];
    UIImageView *imageView3 = [self createImageViewWithTag:2];
    
    [imageView1 sd_setImageWithURL:[NSURL URLWithString:images[0]] placeholderImage:[UIImage mediaImagePlaceholder]];
    [imageView2 sd_setImageWithURL:[NSURL URLWithString:images[1]] placeholderImage:[UIImage mediaImagePlaceholder]];
    [imageView3 sd_setImageWithURL:[NSURL URLWithString:images[2]] placeholderImage:[UIImage mediaImagePlaceholder]];
    
    [imageView1 autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [imageView1 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [imageView1 autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [imageView1 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.5];
    
    [imageView2 autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [imageView2 autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [imageView2 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:imageView1];
    [imageView2 autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:imageView1 withMultiplier:0.5];
    
    [imageView3 autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [imageView3 autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [imageView3 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:imageView1];
    [imageView3 autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:imageView1 withMultiplier:0.5];
}

- (void)setupFourImages:(NSArray *)images {
    
    UIImageView *imageView1 = [self createImageViewWithTag:0];
    UIImageView *imageView2 = [self createImageViewWithTag:1];
    UIImageView *imageView3 = [self createImageViewWithTag:2];
    UIImageView *imageView4 = [self createImageViewWithTag:3];
    
    [imageView1 sd_setImageWithURL:[NSURL URLWithString:images[0]] placeholderImage:[UIImage mediaImagePlaceholder]];
    [imageView2 sd_setImageWithURL:[NSURL URLWithString:images[1]] placeholderImage:[UIImage mediaImagePlaceholder]];
    [imageView3 sd_setImageWithURL:[NSURL URLWithString:images[2]] placeholderImage:[UIImage mediaImagePlaceholder]];
    [imageView4 sd_setImageWithURL:[NSURL URLWithString:images[3]] placeholderImage:[UIImage mediaImagePlaceholder]];
    
    [imageView1 autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [imageView1 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [imageView1 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.5];
    [imageView1 autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self withMultiplier:0.5];
    
    [imageView2 autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [imageView2 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [imageView2 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.5];
    [imageView2 autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self withMultiplier:0.5];

    [imageView3 autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [imageView3 autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [imageView3 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.5];
    [imageView3 autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self withMultiplier:0.5];

    [imageView4 autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [imageView4 autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [imageView4 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.5];
    [imageView4 autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self withMultiplier:0.5];

}

- (NSMutableArray *)mediaFrames {
    
    if (!_mediaFrames) {
        _mediaFrames = [NSMutableArray new];
    }
    
    return _mediaFrames;
}

@end
