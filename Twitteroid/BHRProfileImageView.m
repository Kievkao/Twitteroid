//
//  BHRProfileImageView.m
//  Behere
//
//  Created by Andrey Kravchenko on 7/14/15.
//  Copyright (c) 2015 Behere. All rights reserved.
//

#import "BHRProfileImageView.h"

@implementation BHRProfileImageView

- (void)awakeFromNib {
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *gestureRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    [self addGestureRecognizer:gestureRec];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
}

- (void)tapped {
    if (self.clickProcessBlock) {
        self.clickProcessBlock();
    }
}

@end
