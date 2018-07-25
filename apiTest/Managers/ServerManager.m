//
//  NSObject+ServerManager.m
//  apiTest
//
//  Created by DeveloperMB on 7/17/18.
//  Copyright © 2018 DeveloperMB. All rights reserved.
//

#import "ServerManager.h"
#import "AFNetworking.h"
#import "ViewController.h"

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
    
    //NSLog(@"%@",forecast);
    
    NSString *cityName = [NSString stringWithFormat:@"%@", [[forecast objectForKey:@"city"] objectForKey:@"name"]];
    NSString* date = [[forecast objectForKey:@"list"][0] objectForKey:@"dt_txt"];
    NSString *windSpeed = [NSString stringWithFormat:@"%@", [[[forecast objectForKey:@"list"][0] objectForKey:@"wind"] objectForKey:@"speed"]];
    windSpeed = [windSpeed substringToIndex:3];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSDictionary *infoDict = @{@"cityName":cityName,
                               @"windSpeed":windSpeed
                               };
    
    //prepare date and time
    
    NSRange dayRange = NSMakeRange(8, 2);
    NSRange monthRange = NSMakeRange(5, 2);
    NSRange timeRange = NSMakeRange(11, 5);
    
    NSString* dayString = [date substringWithRange:dayRange];
    NSString* monthString = [date substringWithRange:monthRange];
    NSString* timeString = [date substringWithRange:timeRange];
    
    NSString* formatedDate = [NSString stringWithFormat:@"%@.%@",dayString,monthString];
    NSString *temperature = @"";
    
    NSInteger responceDictSize = [[forecast objectForKey:@"list"] count];
    
    for (int i = 0; i < responceDictSize; i++) {
        
        temperature = [NSString stringWithFormat:@"%@",[[[forecast objectForKey:@"list"][i] objectForKey:@"main"] objectForKey:@"temp"]];
        NSInteger x = [temperature integerValue];
        temperature = [NSString stringWithFormat:@"%ld°", x];
        
        date = [[forecast objectForKey:@"list"][i] objectForKey:@"dt_txt"];
        dayString = [date substringWithRange:dayRange];
        monthString = [date substringWithRange:monthRange];
        timeString = [date substringWithRange:timeRange];
        formatedDate = [NSString stringWithFormat:@"%@.%@",dayString,monthString];
         
        [dict setObject:temperature forKey:@"temp"];                                                                                //temp
        [dict setObject:[[[forecast objectForKey:@"list"][i] objectForKey:@"weather"][0] objectForKey:@"main"] forKey:@"icon"];     //icon
        [dict setObject:formatedDate forKey:@"date"];                                                                               //date
        [dict setObject:timeString forKey:@"time"];                                                                                 //time
        
        [array addObject:[dict copy]];
    }
    
    [array addObject:infoDict];
    
    return array;
}


@end
