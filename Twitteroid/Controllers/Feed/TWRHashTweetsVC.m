//
//  TWRHashTweetsVC.m
//  Twitteroid
//
//  Created by Andrey Kravchenko on 7/28/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRHashTweetsVC.h"
#import "TWRCoreDataManager.h"

@interface TWRHashTweetsVC ()

@end


// TODO: leave ONLY TWRFeedVC!!! Remove this one
@implementation TWRHashTweetsVC

+ (NSString *)identifier {
    return @"TWRHashTweetsVC";
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.hashTag;
}


- (NSString *)tweetsHashtag {
    return self.hashTag;
}

- (void)setupNavigationBar {

}

@end
