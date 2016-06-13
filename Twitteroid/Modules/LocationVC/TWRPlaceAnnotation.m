//
//  TWRPlaceAnnotation.m
//  Twitteroid
//
//  Created by Andrey Kravchenko on 7/27/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRPlaceAnnotation.h"

@implementation TWRPlaceAnnotation

- (instancetype)initWithTitle:(NSString *)title coordinates:(CLLocationCoordinate2D)coordinate {
    self = [super init];
    
    if (self) {
        _title = title;
        _coordinate = coordinate;
    }
    return self;
}

@end
