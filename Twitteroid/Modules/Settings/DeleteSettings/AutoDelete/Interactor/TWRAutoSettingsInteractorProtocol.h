//
//  TWRAutoSettingsInteractorProtocol.h
//  Twitteroid
//
//  Created by Andrii Kravchenko on 6/2/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TWRAutoSettingsInteractorProtocol <NSObject>

- (void)retrieveSavedWeeksNumber;
- (void)deleteTweetsOlderThanDate:(NSDate *)date;
- (void)saveTweetsAutoDeleteDate:(NSDate *)date;

@end
