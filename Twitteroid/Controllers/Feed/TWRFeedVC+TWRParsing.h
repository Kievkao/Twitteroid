//
//  TWRFeedVC+TWRParsing.h
//  Twitteroid
//
//  Created by Andrey Kravchenko on 7/24/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRFeedVC.h"

@interface TWRFeedVC (TWRParsing)

- (void)parseTweetsArray:(NSArray *)items forHashtag:(NSString *)hashtag;

@end
