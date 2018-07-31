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

@interface MapViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

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
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        //get coords
        
        CGPoint touchPoint = [sender locationInView:self.mapView];
        CLLocationCoordinate2D location2D = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        
        // init view with forecast
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:location2D.latitude longitude:location2D.longitude];
        
        __weak __typeof(self) weakSelf = self;
        CLGeocoder *geocoder = [CLGeocoder new];
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            CLPlacemark *myPlacemark = [placemarks objectAtIndex:0];
            NSString *cityName = myPlacemark.locality;
            
            if (cityName != nil) {
                
                // add empty pin
                
                MKPointAnnotation *pin = [MKPointAnnotation new];
                [pin setCoordinate:location2D];
                [weakSelf.mapView addAnnotation:pin];
                
                // show forecast view
                
                ForecastOnMapViewController *forecastViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ForecastOnMapViewController"];
                [weakSelf presentViewController:forecastViewController animated:YES completion:nil];
                [forecastViewController loadForecast:cityName withPin:pin];
                
            } else {
                
                //alert
                
                UIAlertController* errorAlert = [UIAlertController alertControllerWithTitle:@"Something gone wrong..." message:@"City not found" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                [errorAlert addAction:defaultAction];
                [weakSelf presentViewController:errorAlert animated:YES completion:nil];
            }
        }];
    }
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
