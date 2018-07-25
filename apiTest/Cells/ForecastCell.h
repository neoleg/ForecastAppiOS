//
//  ForecastCell.h
//  apiTest
//
//  Created by DeveloperMB on 7/19/18.
//  Copyright © 2018 DeveloperMB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForecastCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *image;
@property (nonatomic, weak) IBOutlet UILabel *temperatureLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

+ (NSString *)cellId;

@end
