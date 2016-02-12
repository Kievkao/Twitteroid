//
//  TWRGalleryDelegate.m
//  Twitteroid
//
//  Created by Andrey Kravchenko on 7/27/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRGalleryDelegate.h"
#import "SDWebImageDownloader.h"

@interface TWRGalleryDelegate()

@property (nonatomic, strong) NSArray *images;

@end

@implementation TWRGalleryDelegate

- (instancetype)initWithImagesURLs:(NSArray *)images {
    self = [super init];
    if (self) {
        _images = images;
    }
    return self;
}

- (BOOL)photoPagesController:(EBPhotoPagesController *)photoPagesController shouldExpectPhotoAtIndex:(NSInteger)index {
    return (self.images.count > index);
}

- (void)photoPagesController:(EBPhotoPagesController *)controller imageAtIndex:(NSInteger)index completionHandler:(void(^)(UIImage *image))handler {
    
    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:self.images[index]] options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if (image && finished) {
             handler(image);
         }
     }];
}

- (BOOL)photoPagesController:(EBPhotoPagesController *)photoPagesController shouldAllowMiscActionsForPhotoAtIndex:(NSInteger)index {
    return NO;
}

- (BOOL)photoPagesController:(EBPhotoPagesController *)photoPagesController shouldShowCommentsForPhotoAtIndex:(NSInteger)index {
    return NO;
}

@end
