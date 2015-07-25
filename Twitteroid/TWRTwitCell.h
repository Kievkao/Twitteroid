//
//  TWRTwitCell.h
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRBaseTableViewCell.h"

@interface TWRTwitCell : TWRBaseTableViewCell

+ (CGFloat)cellHeightForTableViewWidth:(CGFloat)tableViewWidth tweetText:(NSString *)text mediaPresent:(BOOL)isMediaPresent;
- (void)setTwitText:(NSString *)text;

@end
