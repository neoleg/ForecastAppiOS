//
//  ListViewController.h
//  apiTest
//
//  Created by DeveloperMB on 7/20/18.
//  Copyright © 2018 DeveloperMB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ListViewController : UIViewController

@property (strong, nonatomic) NSDictionary *storedData;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;


- (void) insertNewForecastFor:(NSString *) cityName
                     withIcon:(NSString *) icon
               andTemperature:(NSString *) temperature;

@end
