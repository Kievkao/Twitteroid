//
//  NSDateFormatter+LocaleAdditions.m
//  SandP
//
//  Created by Andrey Kravchenko on 2/23/15.
//  Copyright (c) 2015 Luxoft LLC. All rights reserved.
//

#import "NSDateFormatter+LocaleAdditions.h"

@implementation NSDateFormatter (LocaleAdditions)

- (id)initWithSafeLocale {
    static NSLocale* en_US_POSIX = nil;
    self = [self init];
    if (en_US_POSIX == nil) {
        en_US_POSIX = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    }
    [self setLocale:en_US_POSIX];
    return self;
}

@end
