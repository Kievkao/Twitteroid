//
//  TWRBaseTableVC.h
//  Twitteroid
//
//  Created by Andrey Kravchenko on 7/27/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWRBaseTableVC : UITableViewController

+ (NSString *)identifier;
- (void)showInfoAlertWithTitle:(NSString *)title text:(NSString *)text;

@end
