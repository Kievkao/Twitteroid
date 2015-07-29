//
//  UIImage+TWRImages.m
//  Twitteroid
//
//  Created by Mac on 26/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "UIImage+TWRImages.h"

@implementation UIImage (TWRImages)

+ (UIImage *)avatarPlaceholder {
    return [UIImage imageNamed:@"friendsIcon"];
}

+ (UIImage *)mediaImagePlaceholder {
    return [UIImage imageNamed:@"imagePlaceholder"];
}

+ (UIImage *)videoPlaceholder {
    return [UIImage imageNamed:@"videoPlaceholder"];
}

@end
