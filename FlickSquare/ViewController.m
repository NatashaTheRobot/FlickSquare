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
#import "VenueAnnotation.h"
#import "VenueAnnotationView.h"

@interface ViewController ()
{
    __weak IBOutlet MKMapView *mapView;
    
    __weak IBOutlet UIActivityIndicatorView *activityIndicator;
    CLLocationManager *locationMananger;
    
    NSMutableArray *venuesArray;
}

-(void)showCurrentLocation:(CLLocation *)location;
-(void)addPinToLocation:(CLLocationCoordinate2D)location;
-(void)addVenueAnnotation:(Venue*)venue;

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
                                               
                                               [self addVenueAnnotation:newVenue];
                                            }
                                       
                                        } else {
                                            
                                            NSLog(@"ERROR: %@", result);
         
                                        }
                                        [activityIndicator stopAnimating];
                                   }];
    
}

-(void)addVenueAnnotation:(Venue*)venue
{
    
    VenueAnnotation* vennueAnnotation = [[VenueAnnotation alloc] init];
    
    vennueAnnotation.coordinate = CLLocationCoordinate2DMake(venue.latitude, venue.longitude);
    vennueAnnotation.title = venue.name;
    
    [mapView addAnnotation:vennueAnnotation];
    
    
}

#pragma mark - Location manager

-(void)showCurrentLocation:(CLLocation *)location
{
    MKCoordinateSpan span;
    span.latitudeDelta = 0.001;
    span.longitudeDelta = 0.001;
    
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

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation
{
    NSString* venueIdentifier = @"venue";
    NSString* pinIdentifier = @"pin";
    
    
    MKAnnotationView* annotationView;
    
    if ([annotation isKindOfClass:[VenueAnnotation class]]) {
        annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:venueIdentifier];
        
    } else {
        annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:pinIdentifier];
        
        
    }
    
    if(!annotationView) {
        if ([annotation isKindOfClass:[VenueAnnotation class]]) {
            annotationView = [[VenueAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:venueIdentifier];
        
        } else {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinIdentifier];
            ((MKPinAnnotationView*)annotationView).animatesDrop = YES;
        }
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
    } else {
        
        annotationView.annotation = annotation;
        
    }
        
    return  annotationView;
    
}

@end
