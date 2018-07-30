//
//  MapViewController.m
//  apiTest
//
//  Created by DeveloperMB on 7/30/18.
//  Copyright © 2018 DeveloperMB. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ForecastOnMapViewController.h"
#import "MBProgressHUD.h"

@interface MapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
//@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [self showCurrentPosition];
}


- (IBAction)longPressHandler:(UILongPressGestureRecognizer *)sender {
    
    if (sender.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [sender locationInView:self.mapView];
    CLLocationCoordinate2D location2D = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:location2D.latitude longitude:location2D.longitude];
    
    ForecastOnMapViewController *forecastViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ForecastOnMapViewController"];
    
    [self presentViewController:forecastViewController animated:YES completion:nil];
    
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *myPlacemark = [placemarks objectAtIndex:0];
        NSString *cityName = myPlacemark.locality;
        NSLog(@"------->%@",cityName);
        [forecastViewController loadForecast:cityName];
    }];
}


- (IBAction)homeButtonAction:(UIButton *)sender {
    [self showCurrentPosition];
}


- (void) showCurrentPosition {
    MKCoordinateRegion mapRegion;
    mapRegion.center = self.mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.2;
    mapRegion.span.longitudeDelta = 0.2;
    
    [self.mapView setRegion:mapRegion animated: YES];
}

@end
