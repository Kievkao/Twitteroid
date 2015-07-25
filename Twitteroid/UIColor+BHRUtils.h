//
//  UIColor+BHRUtils.h
//  TestMyLibs
//
//  Created by Andrey Kravchenko on 9/3/14.
//  Copyright (c) 2014 kievkao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (BHRUtils)

+ (UIColor *)colorWithHTMLColor:(NSString *)HTMLColor;  // Convert HTML color notation ("#RRGGBB") to UIColor.
+ (UIColor *)randomColor;
+ (UIColor *)colorWithRGBHex:(UInt32)hex;
- (BOOL)isEqualToColor:(UIColor *)otherColor;
- (UIColor *)darkerColor;

@end
