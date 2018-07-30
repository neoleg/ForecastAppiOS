//
//  NSObject+ServerManager.h
//  apiTest
//
//  Created by DeveloperMB on 7/17/18.
//  Copyright © 2018 DeveloperMB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServerManager : NSObject

//@property (strong, nonatomic) NSDictionary* forecast;

+ (ServerManager*) sharedManager;


//- (void) getForecastWithAFNetworkingFor:(NSString *) cityName
//                              onSuccess:(void(^)(NSDictionary *forecast)) success
//                              onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getForecastFor: (NSString *) cityName
    onSuccess:(void(^)(NSArray *forecast)) success;


@end
