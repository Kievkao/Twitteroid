//
//  TWRLoginWebVC.h
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWRLoginWebVC : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;

+ (NSString *)identifier;

@end
