//
//  ListCollectionViewCell.h
//  
//
//  Created by DeveloperMB on 7/20/18.
//

#import <UIKit/UIKit.h>

@interface ListCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;

+ (NSString *)cellId;

@end
