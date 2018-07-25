//
//  ListViewController.m
//  apiTest
//
//  Created by DeveloperMB on 7/20/18.
//  Copyright © 2018 DeveloperMB. All rights reserved.
//

#import "ListViewController.h"
#import "ListCollectionViewCell.h"
#import "ViewController.h"
#import "DataManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+ImageWithUrl.h"
#import "Model+CoreDataModel.h"

@interface ListViewController () <UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSMutableSet *namesSet;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)backButtonClicked:(UIButton *)sender {
    
    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"navigationController"];

    if ([self.navigationController viewControllers]){
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self showViewController:navigationController sender:sender];
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ListCollectionViewCell cellId] forIndexPath:indexPath];
    
    Forecast *forecast = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.cityNameLabel.text = forecast.name.description;
    cell.temperatureLabel.text = forecast.temperature.description;
    [cell.weatherIcon setupImageNamed:forecast.icon.description];
     
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


#pragma mark - Fetched results controller


- (NSFetchedResultsController<Forecast *> *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest<Forecast *> *fetchRequest = Forecast.fetchRequest;
    [fetchRequest setFetchBatchSize:7];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    NSFetchedResultsController<Forecast *> *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[DataManager dataManager] managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    
    if ([[[aFetchedResultsController fetchedObjects] valueForKey:@"name"] count] != 0) {
        self.namesSet = [NSMutableSet setWithArray:[[aFetchedResultsController fetchedObjects] valueForKey:@"name"]];
    }
    _fetchedResultsController = aFetchedResultsController;
    return _fetchedResultsController;
}


- (void) insertNewForecastFor:(NSString *) cityName
                     withIcon:(NSString *) icon
               andTemperature:(NSString *) temperature {
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    
    if (![self.namesSet containsObject:cityName]) {
        NSLog(@"added");
        Forecast *newForecast = [[Forecast alloc] initWithContext:context];
        newForecast.name = cityName;
        newForecast.temperature = temperature;
        newForecast.icon = icon;
        [self.namesSet addObject:cityName];
    }
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    [self.collectionView reloadData];
}

@end
