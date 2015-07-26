//
//  TWRCellMediaView.m
//  Twitteroid
//
//  Created by Mac on 25/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRCellMediaView.h"

@interface TWRCellMediaView()

@property (nonatomic, strong) NSMutableArray *imageViews;

@end

@implementation TWRCellMediaView

- (void)setImagesCount:(NSUInteger)count {
    
    switch (count) {
        case 1:
            [self setupOneImage];
            break;
            
        case 2:
            [self setupTwoImages];
            break;
            
        case 3:
            [self setupThreeImages];
            break;
            
        case 4:
            [self setupFourImages];
            break;
            
        default:
            break;
    }
}

- (void)removeAllImages {
    
    for (UIImageView *imageView in self.imageViews) {
        [imageView removeFromSuperview];
    }
    
    [self.imageViews removeAllObjects];
}

- (UIImageView *)createImageViewWithTag:(NSUInteger)tag {
    
    UIImageView *imageView = [[UIImageView alloc] initForAutoLayout];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = YES;
    imageView.tag = tag;
    imageView.image = [UIImage imageNamed:@"mozart"];
    UITapGestureRecognizer *gestureRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageTapFrom:)];
    [imageView addGestureRecognizer:gestureRec];
    
    [self addSubview:imageView];
    [self.imageViews addObject:imageView];
    
    
    return imageView;
}

- (void)handleImageTapFrom:(UITapGestureRecognizer *)recognizer
{
    UIImageView *tappedView = (UIImageView *)recognizer.view;
    NSLog(@"Tapped UIImageView with tag: %d", tappedView.tag);
}

- (void)setupOneImage {
    
    UIImageView *imageView = [self createImageViewWithTag:1];
    [imageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}

- (void)setupTwoImages {

    UIImageView *imageView1 = [self createImageViewWithTag:1];
    UIImageView *imageView2 = [self createImageViewWithTag:2];
    
    [imageView1 autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [imageView1 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [imageView1 autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [imageView1 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.5];
    
    [imageView2 autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [imageView2 autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [imageView2 autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [imageView2 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:imageView1];
}

- (void)setupThreeImages {
    
    UIImageView *imageView1 = [self createImageViewWithTag:1];
    UIImageView *imageView2 = [self createImageViewWithTag:2];
    UIImageView *imageView3 = [self createImageViewWithTag:3];
    
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

- (void)setupFourImages {
    
    UIImageView *imageView1 = [self createImageViewWithTag:1];
    UIImageView *imageView2 = [self createImageViewWithTag:2];
    UIImageView *imageView3 = [self createImageViewWithTag:3];
    UIImageView *imageView4 = [self createImageViewWithTag:4];
    
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

- (NSMutableArray *)imageViews {
    
    if (!_imageViews) {
        _imageViews = [NSMutableArray new];
    }
    
    return _imageViews;
}

@end
