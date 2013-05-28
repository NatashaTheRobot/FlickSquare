//
//  ViewController.m
//  FlickSquare
//
//  Created by Natasha Murashev on 5/28/13.
//  Copyright (c) 2013 Natasha Murashev. All rights reserved.
//

#import "ViewController.h"
#import "Foursquare2.h"
#import "Venue.h"

@interface ViewController ()
{
    __weak IBOutlet MKMapView *mapView;
    
    __weak IBOutlet UIActivityIndicatorView *activityIndicator;
    CLLocationManager *locationMananger;
    
    NSMutableArray *venuesArray;
}

-(void)showCurrentLocation:(CLLocation *)location;
- (void)addPinToLocation:(CLLocationCoordinate2D)location;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [activityIndicator startAnimating];
    
    venuesArray = [NSMutableArray array];
    
    locationMananger = [[CLLocationManager alloc] init];
    locationMananger.delegate = self;
    
    [locationMananger startUpdatingLocation];
}

- (void)getFoursquareVenuesWithLatitude:(CGFloat)latitude andLongitude:(CGFloat)longitude
{
    NSLog(@"worked");
    
    [Foursquare2 searchVenuesNearByLatitude:[NSNumber numberWithFloat:latitude]
                                  longitude:[NSNumber numberWithFloat:longitude]
                                 accuracyLL:nil
                                   altitude:nil
                                accuracyAlt:nil
                                      query:nil
                                      limit:[NSNumber numberWithInt:100]
                                     intent:0
                                     radius:[NSNumber numberWithInt:800]
                                 categoryId:nil
                                   callback:^(BOOL success, id result) {
                                       
                                       if (success) {
                                           
                                           NSArray *apiVenuesArray = [result valueForKeyPath:@"response.venues"];
                                           
                                           for (NSDictionary *venue in apiVenuesArray) {
                                               
                                               Venue *newVenue = [[Venue alloc] init];
                                               
                                               newVenue.name = [venue objectForKey:@"name"];
                                               newVenue.latitude = [[venue valueForKeyPath:@"location.lat"] floatValue];
                                               newVenue.longitude = [[venue valueForKeyPath:@"location.lng"] floatValue];
                                               
                                               [venuesArray addObject:newVenue];
                                            }
                                       
                                        } else {
                                            
                                            NSLog(@"ERROR: %@", result);
         
                                        }
                                        [activityIndicator stopAnimating];
                                   }];
    
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
