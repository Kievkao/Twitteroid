//
//  BHRRoundedImageView.m
//  Behere
//
//  Created by Andrey Kravchenko on 7/1/15.
//  Copyright (c) 2015 Behere. All rights reserved.
//

#import "BHRRoundedImageView.h"

@implementation BHRRoundedImageView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clipsToBounds = YES;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    self.clipsToBounds = YES;
}

@end
