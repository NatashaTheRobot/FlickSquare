//
//  ViewController.m
//  FlickSquare
//
//  Created by Natasha Murashev on 5/28/13.
//  Copyright (c) 2013 Natasha Murashev. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    __weak IBOutlet MKMapView *mapView;
    CLLocationManager *locationMananger;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    locationMananger = [[CLLocationManager alloc] init];
    locationMananger.delegate = self;
    
    [locationMananger startUpdatingLocation];
}

- (void)getFoursquareVenuesWithLatitude:(CGFloat)latitude andLongitude:(CGFloat)longitude
{
    NSLog(@"%f", latitude);
    NSLog(@"%f", longitude);
    // get api
}

#pragma mark - Location manager

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = locations[0];

    [self getFoursquareVenuesWithLatitude:(CGFloat)location.coordinate.latitude
                             andLongitude:(CGFloat)location.coordinate.longitude];
    
    [locationMananger stopUpdatingLocation];
}

@end
