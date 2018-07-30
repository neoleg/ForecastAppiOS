//
//  NSObject+Gradient.m
//  apiTest
//
//  Created by DeveloperMB on 7/17/18.
//  Copyright © 2018 DeveloperMB. All rights reserved.
//

#import "Gradient.h"

@implementation Gradient

+ (CAGradientLayer*) whiteToGreen {
    
    UIColor* fromColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:0.1];
    UIColor* toColor = [UIColor colorWithRed:(70/255.0) green:(130/255.0) blue:(180/255.0) alpha:0.9];
    
    NSArray* colors = [NSArray arrayWithObjects:(id)fromColor.CGColor, toColor.CGColor, nil];
    
    NSNumber* stepOne = [NSNumber numberWithFloat:0.0];
    NSNumber* stepTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray* locations = @[stepOne, stepTwo];
    CAGradientLayer *backgroundLayer = [CAGradientLayer layer];
    backgroundLayer.colors = colors;
    backgroundLayer.locations = locations;
    
    return backgroundLayer;
}

+ (void) setupGradient: (UIView*) view{
    CAGradientLayer* gradientLayer = [Gradient whiteToGreen];
    gradientLayer.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    [view.layer insertSublayer:gradientLayer atIndex:0];
}

@end
