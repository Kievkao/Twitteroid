//
//  TWRYoutubeVideoVC.m
//  Twitteroid
//
//  Created by Andrey Kravchenko on 7/29/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRYoutubeVideoViewController.h"
#import "YTPlayerView.h"

@interface TWRYoutubeVideoViewController ()

@property (weak, nonatomic) IBOutlet YTPlayerView *playerView;

@end

@implementation TWRYoutubeVideoViewController

+ (NSString *)identifier {
    return @"TWRYoutubeRootNavC";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.youtubeLinkStr) {
        NSString *lastPath = [self.youtubeLinkStr lastPathComponent];
        [self.playerView loadWithVideoId:lastPath];
    }    
}

- (IBAction)doneClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
