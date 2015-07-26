//
//  TWRCellMediaView.m
//  Twitteroid
//
//  Created by Mac on 25/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRCellMediaView.h"
#import "UIImageView+WebCache.h"

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
            [self setupOneWebView:links];
            break;
            
        case 2:
            [self setupTwoWebViews:links];
            break;
            
        case 3:
            [self setupThreeWebViews:links];
            break;
            
        case 4:
            [self setupFourWebViews:links];
            break;
            
        default:
            break;
    }
}

- (void)setupOneWebView:(NSArray *)links {
    
    UIWebView *webView = [self createWebViewWithTag:1];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[links firstObject]]]];
    
    [webView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}

- (void)setupTwoWebViews:(NSArray *)links {
    
    UIWebView *webView1 = [self createWebViewWithTag:1];
    UIWebView *webView2 = [self createWebViewWithTag:2];
    
    [webView1 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[links firstObject]]]];
    [webView2 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[links lastObject]]]];
    
    [webView1 autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [webView1 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [webView1 autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [webView1 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.5];
    
    [webView2 autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [webView2 autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [webView2 autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [webView2 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:webView1];
}

- (void)setupThreeWebViews:(NSArray *)links {
    
    UIWebView *webView1 = [self createWebViewWithTag:1];
    UIWebView *webView2 = [self createWebViewWithTag:2];
    UIWebView *webView3 = [self createWebViewWithTag:3];
    
    [webView1 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:links[0]]]];
    [webView2 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:links[1]]]];
    [webView3 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:links[2]]]];
    
    [webView1 autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [webView1 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [webView1 autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [webView1 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.5];
    
    [webView2 autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [webView2 autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [webView2 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:webView1];
    [webView2 autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:webView1 withMultiplier:0.5];
    
    [webView3 autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [webView3 autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [webView3 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:webView1];
    [webView3 autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:webView1 withMultiplier:0.5];
}

- (void)setupFourWebViews:(NSArray *)links {
    
    UIWebView *webView1 = [self createWebViewWithTag:1];
    UIWebView *webView2 = [self createWebViewWithTag:2];
    UIWebView *webView3 = [self createWebViewWithTag:3];
    UIWebView *webView4 = [self createWebViewWithTag:4];
    
    [webView1 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:links[0]]]];
    [webView2 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:links[1]]]];
    [webView3 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:links[2]]]];
    [webView4 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:links[3]]]];
    
    [webView1 autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [webView1 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [webView1 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.5];
    [webView1 autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self withMultiplier:0.5];
    
    [webView2 autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [webView2 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [webView2 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.5];
    [webView2 autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self withMultiplier:0.5];
    
    [webView3 autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [webView3 autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [webView3 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.5];
    [webView3 autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self withMultiplier:0.5];
    
    [webView4 autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [webView4 autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [webView4 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.5];
    [webView4 autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self withMultiplier:0.5];
}

- (void)removeAllFrames {
    
    for (UIImageView *imageView in self.mediaFrames) {
        [imageView removeFromSuperview];
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

- (UIWebView *)createWebViewWithTag:(NSUInteger)tag {
    
    UIWebView *webView = [[UIWebView alloc] initForAutoLayout];
    webView.contentMode = UIViewContentModeScaleAspectFit;
    webView.scrollView.scrollEnabled = NO;
    webView.tag = tag;
    
    [self addSubview:webView];
    [self.mediaFrames addObject:webView];
    
    return webView;
}

- (void)handleImageTapFrom:(UITapGestureRecognizer *)recognizer
{
    UIImageView *tappedView = (UIImageView *)recognizer.view;
    NSLog(@"Tapped UIImageView with tag: %ld", (long)tappedView.tag);
}

- (void)setupOneImage:(NSArray *)images {
    
    UIImageView *imageView = [self createImageViewWithTag:1];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:[images firstObject]] placeholderImage:[UIImage mediaImagePlaceholder]];
    [imageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}

- (void)setupTwoImages:(NSArray *)images {

    UIImageView *imageView1 = [self createImageViewWithTag:1];
    UIImageView *imageView2 = [self createImageViewWithTag:2];
    
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
    
    UIImageView *imageView1 = [self createImageViewWithTag:1];
    UIImageView *imageView2 = [self createImageViewWithTag:2];
    UIImageView *imageView3 = [self createImageViewWithTag:3];
    
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
    
    UIImageView *imageView1 = [self createImageViewWithTag:1];
    UIImageView *imageView2 = [self createImageViewWithTag:2];
    UIImageView *imageView3 = [self createImageViewWithTag:3];
    UIImageView *imageView4 = [self createImageViewWithTag:4];
    
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
