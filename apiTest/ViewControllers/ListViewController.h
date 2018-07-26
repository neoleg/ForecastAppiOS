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

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end
