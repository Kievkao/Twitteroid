//
//  TWRLocationVC.h
//  Twitteroid
//
//  Created by Mac on 26/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface TWRLocationVC : UIViewController <TWRViewControllerIdentifier>

@property (nonatomic) CLLocationCoordinate2D coordinates;

@end
