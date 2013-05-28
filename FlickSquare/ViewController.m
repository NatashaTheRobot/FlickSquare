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

-(void)showCurrentLocation:(CLLocation *)location;
- (void)addPinToLocation:(CLLocationCoordinate2D)location;

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

-(void)showCurrentLocation:(CLLocation *)location
{
    MKCoordinateSpan span;
    span.latitudeDelta = 0.015;
    span.longitudeDelta = 0.015;
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    
    MKCoordinateRegion region;
    region.span = span;
    region.center=center;
    
    [mapView setRegion:region animated:TRUE];
    [mapView regionThatFits:region];
    
    [self addPinToLocation:center];
}

- (void)addPinToLocation:(CLLocationCoordinate2D)location
{
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:location];
    [mapView addAnnotation:annotation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = locations[0];

    [self showCurrentLocation:location];
    
    [self getFoursquareVenuesWithLatitude:(CGFloat)location.coordinate.latitude
                             andLongitude:(CGFloat)location.coordinate.longitude];
    
    [locationMananger stopUpdatingLocation];
}

@end
