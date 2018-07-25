//
//  UIImageView+ImageWithUrl.m
//  apiTest
//
//  Created by DeveloperMB on 7/23/18.
//  Copyright © 2018 DeveloperMB. All rights reserved.
//

#import "UIImageView+ImageWithUrl.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UIImageView (ImageWithUrl)

- (void) setupImageNamed:(NSString *) name {
    
    if ([name isEqualToString:@"Clouds"]) {
        [self sd_setImageWithURL:[NSURL URLWithString:@"https://cdn3.iconfinder.com/data/icons/tiny-weather-1/512/cloud-512.png"] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    } else if ([name isEqualToString:@"Clear"]) {
        [self sd_setImageWithURL:[NSURL URLWithString:@"https://cdn3.iconfinder.com/data/icons/tiny-weather-1/512/sun-512.png"] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    } else if ([name isEqualToString:@"Rain"]) {
        [self sd_setImageWithURL:[NSURL URLWithString:@"https://cdn3.iconfinder.com/data/icons/tiny-weather-1/512/rain-cloud-512.png"] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    } else if ([name isEqualToString:@"Drizzle"]) {
        [self sd_setImageWithURL:[NSURL URLWithString:@"https://cdn3.iconfinder.com/data/icons/tiny-weather-1/512/rain-cloud-512.png"] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    } else if ([name isEqualToString:@"Thunderstorm"]) {
        [self sd_setImageWithURL:[NSURL URLWithString:@"https://cdn3.iconfinder.com/data/icons/tiny-weather-1/512/flash-cloud-512.png"] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    } else if ([name isEqualToString:@"Snow"]) {
        [self sd_setImageWithURL:[NSURL URLWithString:@"https://cdn3.iconfinder.com/data/icons/tiny-weather-1/512/snow-512.png"] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    
}

@end
