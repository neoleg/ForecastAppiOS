//
//  ViewController.m
//  apiTest
//
//  Created by DeveloperMB on 7/17/18.
//  Copyright © 2018 DeveloperMB. All rights reserved.
//

#import "ViewController.h"
#import "Gradient.h"
#import "ServerManager.h"
#import "ForecastCell.h"
#import "AFNetworking.h"
#import "ListViewController.h"
#import "DataManager.h"
#import "UIImageView+ImageWithUrl.h"
@import GoogleMobileAds;

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *cityNameField;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *windSpeedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *forecastCollection;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cityNameLabelHeight;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

@property (strong, nonatomic) NSArray* forecast;

@end


@implementation ViewController

@synthesize forecastCollection;


- (void)viewDidLoad {
    [super viewDidLoad];
    //[[DataManager dataManager] clearCore];
    [self loadForecast:nil];
    [self addBanner];

}


- (IBAction)searchAction:(UIButton *)sender {
    
    NSString *cityName = self.cityNameField.text;
    [self.searchButton setEnabled:false];
    [self loadForecast:cityName];
}


- (void) setupData {
    
    if ([[self.forecast lastObject] objectForKey:@"cityName"]) {
        
        NSString *cityName = [[self.forecast lastObject] objectForKey:@"cityName"];
        NSString *temperature = [self.forecast[0] objectForKey:@"temp"];
        NSString *windSpeed = [[self.forecast lastObject] objectForKey:@"windSpeed"];
        //windSpeed = [windSpeed substringToIndex:3];
        NSString* weatherIconName = [self.forecast[0] objectForKey:@"icon"];
        
        // setup text data
        
        self.cityNameLabel.text = cityName;
        self.temperatureLabel.text = temperature;
        self.windSpeedLabel.text = windSpeed;
        
        //setup images
        
        [self.weatherImage setupImageNamed:weatherIconName];
        
        // reload table
        
        [self.forecastCollection reloadData];
        [self.searchButton setEnabled:true];
        
        //save to core data

        [[DataManager dataManager] insertNewForecastFor:cityName withIcon:weatherIconName andTemperature:temperature];
        
        
    } else {
        UIAlertController* errorAlert = [UIAlertController alertControllerWithTitle:@"Something gone wrong..." message:@"City not found" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.cityNameField setText:@""];
        }];
        
        [self.searchButton setEnabled:true];
        [errorAlert addAction:defaultAction];
        [self presentViewController:errorAlert animated:YES completion:nil];
    }
}


#pragma mark - loading data


- (void)loadForecast:(NSString *)cityName {
    
    if (cityName == nil) {
        
        cityName = [[DataManager dataManager] lastRequestedCityName];
        if (nil == cityName) {
            cityName = @"London";
        }
    }
    __weak __typeof(self) weakSelf = self;
    [[ServerManager sharedManager] getForecastFor:cityName onSuccess:^(NSArray *forecast) {
        weakSelf.forecast = forecast;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf setupData];
        });
    }];
}


#pragma mark - collectionView


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.forecast.count - 1;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ForecastCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ForecastCell cellId] forIndexPath:indexPath];
    
    NSString* weatherIconName = [self.forecast[indexPath.row] objectForKey:@"icon"];
    NSString* temperature = [self.forecast[indexPath.row] objectForKey:@"temp"];
    NSString* date = [self.forecast[indexPath.row] objectForKey:@"date"];
    NSString* time = [self.forecast[indexPath.row] objectForKey:@"time"];
    
    [cell.image setupImageNamed:weatherIconName];
    cell.temperatureLabel.text = temperature;
    cell.dateLabel.text = date;
    cell.timeLabel.text = time;
    
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


/*
- (IBAction)present:(UIBarButtonItem *)sender {
     ListViewController *listViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"listViewController"];
    [self presentViewController:listViewController animated:YES completion:nil];
}

- (IBAction)show:(UIBarButtonItem *)sender {
    ListViewController *listViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"listViewController"];
    [self.navigationController showViewController:listViewController sender:sender];
    
}
*/


#pragma mark - advertising


- (void) addBanner {
    self.bannerView.adUnitID = @"ca-app-pub-2355698657310174/5553214788";
    self.bannerView.rootViewController = self;
    GADRequest *request = [GADRequest request];
    request.testDevices = @[ kGADSimulatorID ];
    [self.bannerView loadRequest:request];
}

@end
