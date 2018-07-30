//
//  DataManager.h
//  apiTest
//
//  Created by DeveloperMB on 7/20/18.
//  Copyright © 2018 DeveloperMB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DataManager : NSObject

+ (DataManager *) dataManager;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;
- (void) clearCore;
- (NSManagedObjectContext *) managedObjectContext;
- (void) insertNewForecastFor:(NSString *) cityName
                     withIcon:(NSString *) icon
               andTemperature:(NSString *) temperature;

- (NSString *)lastRequestedCityName;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
