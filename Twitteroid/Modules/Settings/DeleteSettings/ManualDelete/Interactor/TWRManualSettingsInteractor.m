//
//  TWRManualDeleteSettingsInteractor.m
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/2/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import "TWRManualSettingsInteractor.h"
#import "TWRCoreDataDAO.h"

@implementation TWRManualSettingsInteractor

- (void)deleteTweetsOlderThanDate:(NSDate *)date {
    [[TWRCoreDataDAO sharedInstance] deleteTweetsOlderThanDate:date];
}

@end
