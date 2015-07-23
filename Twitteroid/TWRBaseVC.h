//
//  TWRBaseVC.h
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWRBaseVC : UIViewController

+ (NSString *)identifier;
- (void)showInfoAlertWithTitle:(NSString *)title text:(NSString *)text;

@end
