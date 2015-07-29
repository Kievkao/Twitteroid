//
//  TWRYoutubeVideoVC.m
//  Twitteroid
//
//  Created by Andrey Kravchenko on 7/29/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRYoutubeVideoVC.h"
#import "YTPlayerView.h"

@interface TWRYoutubeVideoVC ()

@property (weak, nonatomic) IBOutlet YTPlayerView *playerView;

@end

@implementation TWRYoutubeVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.youtubeLinkStr) {
        NSString *lastPath = [self.youtubeLinkStr lastPathComponent];
        [self.playerView loadWithVideoId:lastPath];
    }
    
}

+ (NSString *)rootNavigationIdentifier {
    return @"TWRYoutubeRootNavC";
}

- (IBAction)doneClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
