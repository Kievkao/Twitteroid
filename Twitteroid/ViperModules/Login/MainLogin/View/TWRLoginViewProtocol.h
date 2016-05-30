//
//  TWRLoginViewProtocol.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/28/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TWRLoginViewProtocol <NSObject>

- (void)showAlertWithTitle:(NSString*)title message:(NSString*)message;
- (void)setProgressIndicatorVisible:(BOOL)visible;

@end
