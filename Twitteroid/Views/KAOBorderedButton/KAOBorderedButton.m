//
//  KAOBorderedButton.m
//  Twitteroid
//
//  Created by Andrey Kravchenko on 7/27/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "KAOBorderedButton.h"

@implementation KAOBorderedButton

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.masksToBounds = YES;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
}

@end
