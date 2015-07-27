//
//  BHRProfileImageView.h
//  Behere
//
//  Created by Andrey Kravchenko on 7/14/15.
//  Copyright (c) 2015 Behere. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface BHRProfileImageView : UIImageView

@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic, copy) void (^clickProcessBlock)();

@end
