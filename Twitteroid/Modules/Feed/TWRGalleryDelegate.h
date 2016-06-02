//
//  TWRGalleryDelegate.h
//  Twitteroid
//
//  Created by Andrey Kravchenko on 7/27/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EBPhotoPagesController.h"

@interface TWRGalleryDelegate : NSObject <EBPhotoPagesDataSource, EBPhotoPagesDelegate>

- (instancetype)initWithImagesURLs:(NSArray *)images;

@end
