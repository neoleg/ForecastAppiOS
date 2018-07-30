//
//  ForecastOnMapViewController.m
//  apiTest
//
//  Created by DeveloperMB on 7/30/18.
//  Copyright © 2018 DeveloperMB. All rights reserved.
//

#import "ForecastOnMapViewController.h"
#import "ServerManager.h"
#import "UIImageView+ImageWithUrl.h"
#import "MBProgressHUD.h"

@interface ForecastOnMapViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;

@property (strong, nonatomic) NSArray* forecast;

@end

@implementation ForecastOnMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    
}


- (void) loadForecast:(NSString *) cityName {
    __weak __typeof(self) weakSelf = self;
    [[ServerManager sharedManager] getForecastFor:cityName onSuccess:^(NSArray *forecast) {
        weakSelf.forecast = forecast;
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[self.forecast lastObject] objectForKey:@"cityName"]) {
                self.cityNameLabel.text = [[self.forecast lastObject] objectForKey:@"cityName"];
                self.temperatureLabel.text = [self.forecast[0] objectForKey:@"temp"];
                [self.weatherIcon setupImageNamed:[self.forecast[0] objectForKey:@"icon"]];
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
