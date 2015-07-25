//
//  UIColor+BHRUtils.h.m
//  TestMyLibs
//
//  Created by Andrey Kravchenko on 9/3/14.
//  Copyright (c) 2014 kievkao. All rights reserved.
//

#import "UIColor+BHRUtils.h"

@implementation UIColor (BHRUtils)

- (UIColor *)darkerColor
{
    CGFloat r, g, b, a;
    if ([self getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.4, 0.0)
                               green:MAX(g - 0.4, 0.0)
                                blue:MAX(b - 0.4, 0.0)
                               alpha:a];
    return nil;
}

+ (UIColor *)colorWithHTMLColor:(NSString *)HTMLColor
{
    unsigned rgb = 0;
    NSScanner *scanner = [NSScanner scannerWithString:HTMLColor];
    
    if ([HTMLColor hasPrefix:@"#"])
        scanner.scanLocation = 1;
    
    if (![scanner scanHexInt:&rgb])
        return nil;
    
    return [UIColor colorWithRed:((rgb & 0xFF0000) >> 0x10) / 255.0 green:((rgb & 0xFF00) >> 0x8) / 255.0 blue:(rgb & 0xFF) / 255.0 alpha:1.0];
}

+ (UIColor *)randomColor {
	return [UIColor colorWithRed:random() / (CGFloat)RAND_MAX
						   green:random() / (CGFloat)RAND_MAX
							blue:random() / (CGFloat)RAND_MAX
						   alpha:1.0f];
}

+ (UIColor *)colorWithRGBHex:(UInt32)hex {
	int r = (hex >> 16) & 0xFF;
	int g = (hex >> 8) & 0xFF;
	int b = (hex) & 0xFF;
    
	return [UIColor colorWithRed:r / 255.0f
						   green:g / 255.0f
							blue:b / 255.0f
						   alpha:1.0f];
}

- (BOOL)isEqualToColor:(UIColor *)otherColor {
    CGColorSpaceRef colorSpaceRGB = CGColorSpaceCreateDeviceRGB();
    
    UIColor *(^convertColorToRGBSpace)(UIColor*) = ^(UIColor *color) {
        if(CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) == kCGColorSpaceModelMonochrome) {
            const CGFloat *oldComponents = CGColorGetComponents(color.CGColor);
            CGFloat components[4] = {oldComponents[0], oldComponents[0], oldComponents[0], oldComponents[1]};
            CGColorRef colorRef = CGColorCreate( colorSpaceRGB, components );
            
            UIColor *color = [UIColor colorWithCGColor:colorRef];
            CGColorRelease(colorRef);
            return color;
        } else
            return color;
    };
    
    UIColor *selfColor = convertColorToRGBSpace(self);
    otherColor = convertColorToRGBSpace(otherColor);
    CGColorSpaceRelease(colorSpaceRGB);
    
    return [selfColor isEqual:otherColor];
}


@end
