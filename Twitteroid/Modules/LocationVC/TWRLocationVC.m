//
//  TWRLocationVC.m
//  Twitteroid
//
//  Created by Mac on 26/07/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "TWRLocationVC.h"
#import "TWRPlaceAnnotation.h"

static CGFloat kLocationRegionRadius = 500000.0;

@interface TWRLocationVC ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation TWRLocationVC

+ (NSString *)identifier {
    return @"TWRLocationVC";
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self showPlace];
}

- (void)showPlace {
    
    if (CLLocationCoordinate2DIsValid(self.coordinates)) {
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.coordinates, kLocationRegionRadius, kLocationRegionRadius);
        MKCoordinateRegion userRegion = [self.mapView regionThatFits:viewRegion];
        [self.mapView setRegion:userRegion animated:YES];
        
        TWRPlaceAnnotation *placeAnnotation = [[TWRPlaceAnnotation alloc] initWithTitle:NSLocalizedString(@"Tweet place", @"Tweet place annotation title") coordinates:self.coordinates];
        
        [self.mapView addAnnotation:placeAnnotation];
    }
}

@end
