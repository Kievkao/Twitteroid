//
//  KAOBorderedButton.h
//  Twitteroid
//
//  Created by Andrey Kravchenko on 7/27/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface KAOBorderedButton : UIButton

@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;

@end
