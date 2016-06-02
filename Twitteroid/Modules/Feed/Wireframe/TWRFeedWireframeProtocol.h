//
//  TWRFeedWireframeProtocol.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 5/30/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TWRFeedWireframeProtocol <NSObject>

- (void)presentSettingsScreen;
- (void)presentWebViewForURL:(NSURL *)url;
- (void)presentTweetsScreenForHashtag:(NSString *)hashtag;
- (void)presentLocationScreenWithLatitude:(double)latitude longitude:(double)longitude;
- (void)presentYoutubeVideoFromLink:(NSString *)youtubeLink;
- (void)presentGalleryScreenWithImagesURLs:(NSArray <NSURL *>*)imagesURLs;

@end
