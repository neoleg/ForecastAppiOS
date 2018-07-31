//
//  ForecastOnMapViewController.h
//  apiTest
//
//  Created by DeveloperMB on 7/30/18.
//  Copyright © 2018 DeveloperMB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKPointAnnotation;

@interface ForecastOnMapViewController : UIViewController

@property (strong, nonatomic) NSArray* forecast;

- (void) loadForecast:(NSString *) cityName withPin:(MKPointAnnotation *) pin;

@end
