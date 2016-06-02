//
//  TWRManualDeleteSettingsInteractor.m
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/2/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import "TWRManualSettingsInteractor.h"
#import "TWRCoreDataManager.h"

@implementation TWRManualSettingsInteractor

- (void)deleteTweetsOlderThanDate:(NSDate *)date {
    [[TWRCoreDataManager sharedInstance] deleteTweetsOlderThanDate:date];
}

@end
