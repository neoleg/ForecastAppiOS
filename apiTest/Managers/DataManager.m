//
//  DataManager.m
//  apiTest
//
//  Created by DeveloperMB on 7/20/18.
//  Copyright © 2018 DeveloperMB. All rights reserved.
//

#import "DataManager.h"
#import "Model+CoreDataModel.h"

@interface DataManager () <NSFetchedResultsControllerDelegate>

@end

@implementation DataManager

+ (DataManager *) dataManager {
    static DataManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DataManager alloc] init];
    });
    return manager;
}


- (void) clearCore {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Forecast"];
    NSError *error ;
    NSArray *resultArray= [context executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *object in resultArray) {
        [context deleteObject:object];
    }
    
    [self saveContext];
    NSLog(@"core data cleared");
}


- (NSManagedObjectContext *) managedObjectContext {
    return self.persistentContainer.viewContext;
}


- (void) insertNewForecastFor:(NSString *) cityName
                     withIcon:(NSString *) icon
               andTemperature:(NSString *) temperature {
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Forecast" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", cityName];
    [fetchRequest setPredicate:predicate];
    fetchRequest.fetchLimit = 1;
    
    NSError *error = nil;
    NSInteger count = [self.managedObjectContext countForFetchRequest:fetchRequest error:&error];
    
    if (count == 0) {
        NSLog(@"added");
        Forecast *newForecast = [[Forecast alloc] initWithContext:self.managedObjectContext];
        newForecast.name = cityName;
        newForecast.temperature = temperature;
        newForecast.icon = icon;
    }
    // Save the context.
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

- (NSString *)lastRequestedCityName {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Forecast" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
//    fetchRequest.fetchLimit = 1;
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects.count != 0) {
        return [fetchedObjects.firstObject valueForKey:@"name"];
    }
    return nil;
}
 
#pragma mark - Core Data


@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Model"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}






@end
