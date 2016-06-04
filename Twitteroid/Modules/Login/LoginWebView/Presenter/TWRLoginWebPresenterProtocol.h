//
//  TWRLoginWebPresenterProtocol.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/4/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TWRLoginWebPresenterProtocol <NSObject>

- (void)webLoginDidSuccess;
- (void)webLoginDidFinishWithError:(NSError *)error;

@end
