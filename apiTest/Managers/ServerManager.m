//
//  NSObject+ServerManager.m
//  apiTest
//
//  Created by DeveloperMB on 7/17/18.
//  Copyright © 2018 DeveloperMB. All rights reserved.
//

#import "ServerManager.h"
#import "AFNetworking.h"

@implementation ServerManager

+ (ServerManager*) sharedManager {   //singletone
    
    static ServerManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ServerManager alloc] init];
    });
    
    return manager;
}


- (void) getForecastFor: (NSString *) cityName
              onSuccess:(void(^)(NSArray *forecast)) success {
    NSURL* url = [ServerManager prepareURL:cityName];
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *parseError = nil;
        if (data != nil) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&parseError];
            NSArray *parsedArray = [NSArray array];
            if ([responseDict objectForKey:@"city"]) {
                parsedArray = [self parseResponse:responseDict];
                success(parsedArray);
            } else {
                NSLog(@"%@", responseDict);
                success(parsedArray);
            }
        } else {
            NSLog(@"server error");
        }
        
    }];
    [downloadTask resume];
}


+ (NSURL *) prepareURL:(NSString *) cityName {
    cityName = [cityName stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString* baseUrl = @"https://api.openweathermap.org/data/2.5/forecast";
    NSString* apiKey = @"3e593b0d5a6c511ae11d069ed5c42860";
    NSString* requestString= [NSString stringWithFormat:@"%@?APPID=%@&q=%@&units=metric",baseUrl, apiKey, cityName];
    NSURL* url =[[NSURL alloc] initWithString:requestString];
    return url;
}


- (NSArray *) parseResponse:(NSDictionary *)forecast {
    
    NSMutableArray *array = [NSMutableArray new];
    
    NSArray *list = [forecast objectForKey:@"list"];
    
    if (list.count != 0) {
        
        NSString *cityName = [[forecast objectForKey:@"city"] objectForKey:@"name"];
        cityName = nil != cityName ? cityName : @"No city";
        
        NSString *windSpeed = nil;
        id speedValue = [[list[0] objectForKey:@"wind"] objectForKey:@"speed"];
    
        BOOL isCorrectSpeed = YES;
        if ([speedValue isKindOfClass:[NSNumber class]]) {
            windSpeed = [speedValue stringValue];
        } else if ([speedValue isKindOfClass:[NSString class]]) {
            windSpeed = speedValue;
        } else {
            isCorrectSpeed = NO;
        }
        if (isCorrectSpeed) {
            windSpeed = [windSpeed substringToIndex:3];
        } else {
            windSpeed = @"No wind speed";
        }
        NSDictionary *infoDict = @{@"cityName":cityName,
                                   @"windSpeed":windSpeed
                                   };

        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        
        for (int i = 0; i < list.count; i++) {
            
            NSMutableDictionary *dict = [NSMutableDictionary new];
            NSDictionary *listItem = list[i];
            NSString *temperatureValue = [[listItem objectForKey:@"main"] objectForKey:@"temp"];
            NSString *temperature = [NSString stringWithFormat:@"%ld°", [temperatureValue integerValue]];
           
            NSString* dateString = [list[i] objectForKey:@"dt_txt"];
            NSDate *date = [dateFormat dateFromString:dateString];
            
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:date];
            
            NSString* formatedTime = [NSString stringWithFormat:@"%02ld.%02ld",components.hour, components.minute];
            NSString* formatedDate = [NSString stringWithFormat:@"%02ld.%02ld",components.day, components.month];
            
            [dict setObject:temperature forKey:@"temp"];
            [dict setObject:formatedDate forKey:@"date"];
            [dict setObject:formatedTime forKey:@"time"];
            
            NSArray *weather = [listItem objectForKey:@"weather"];
            NSDictionary *weatherItem = weather.firstObject;
            NSString *icon = [weatherItem valueForKeyPath:@"main"];
            if (nil == icon) {
                icon = @"";
            }
            [dict setObject:icon forKey:@"icon"];
            
            [array addObject:dict];
        }
        
        [array addObject:infoDict];
    }
    
    return array;
}


@end
