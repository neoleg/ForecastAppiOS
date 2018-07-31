//
//  ForecastOnMapViewController.m
//  apiTest
//
//  Created by DeveloperMB on 7/30/18.
//  Copyright © 2018 DeveloperMB. All rights reserved.
//

#import "ForecastOnMapViewController.h"
#import "MapViewController.h"
#import <MapKit/MKPointAnnotation.h>
#import "ServerManager.h"
#import "UIImageView+ImageWithUrl.h"
#import "MBProgressHUD.h"

@interface ForecastOnMapViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;

@end

@implementation ForecastOnMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}


- (void) loadForecast:(NSString *) cityName withPin:(MKPointAnnotation *) pin{
    __weak __typeof(self) weakSelf = self;
    [[ServerManager sharedManager] getForecastFor:cityName onSuccess:^(NSArray *forecast) {
        weakSelf.forecast = forecast;
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[self.forecast lastObject] objectForKey:@"cityName"]) {
                
                //set info to view
                
                NSString *temperature = [self.forecast[0] objectForKey:@"temp"];
                NSString *weatherDescription = [self.forecast[0] objectForKey:@"icon"];
                
                self.cityNameLabel.text = [[self.forecast lastObject] objectForKey:@"cityName"];
                self.temperatureLabel.text = temperature;
                [self.weatherIcon setupImageNamed:weatherDescription];
                
                //set info to pin

                [pin setTitle: cityName];
                [pin setSubtitle: [NSString stringWithFormat:@"%@, %@", weatherDescription, temperature]];
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            } else {
                [self dismissViewControllerAnimated:YES completion:nil];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
        });
    }];
}



- (IBAction)closeAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
