//
//  TWRTwitCell.m
//  Twitteroid
//
//  Created by Mac on 23/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRTwitCell.h"

@interface TWRTwitCell()

@property (weak, nonatomic) IBOutlet UILabel *twitTextLabel;

@end

@implementation TWRTwitCell

+ (NSString *)identifier {
    return @"TWRTwitCell";
}

- (void)setTwitText:(NSString *)text {
    
    self.twitTextLabel.text = text;
}

@end
