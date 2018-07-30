//
//  NSObject+Gradient.h
//  apiTest
//
//  Created by DeveloperMB on 7/17/18.
//  Copyright © 2018 DeveloperMB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Gradient : NSObject

+ (CAGradientLayer*) whiteToGreen;
+ (void) setupGradient: (UIView*) view;

@end
