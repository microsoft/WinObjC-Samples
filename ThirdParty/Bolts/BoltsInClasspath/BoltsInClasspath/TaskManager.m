//
//  TaskManager.m
//  WinObjcBoltsTest
//
//  Created by siva kongara on 1/13/17.
//  Copyright © 2017 venkat kongaraSiva. All rights reserved.
//

#import "TaskManager.h"
#import <Bolts/Bolts.h>
#import "Constants.h"

@interface TaskManager() {
    @private
    NSURLSession *session;
}
@end

@implementation TaskManager

+ (id)sharedManager {
    static TaskManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        sharedMyManager->session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    });
    return sharedMyManager;
}

// only a few city names are supported by weather.com API
- (BFTask *)fetchCurrentWeatherAsyncFromAPIFor: (NSString*)city  andCountry: (NSString*) country{
    NSURLComponents *components = [NSURLComponents componentsWithString:@"http://api.openweathermap.org/data/2.5/weather"];
    NSMutableString *Searchstring = [[NSMutableString alloc] initWithFormat:@"%@,%@",city,country];
    NSURLQueryItem *search = [NSURLQueryItem queryItemWithName:@"q" value:Searchstring];
    NSURLQueryItem *appid = [NSURLQueryItem queryItemWithName:@"appid" value:apiKey];
    components.queryItems = @[ search, appid ];
    NSURL *url = components.URL;
    
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url
                                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                if(error == nil && [(NSHTTPURLResponse*)response statusCode]== 200) {
                                                    [completion setResult:data];
                                                }
                                                else {
                                                    [completion setError:error];
                                                }
                                            }];
    [dataTask resume];
    return completion.task;
}

-(BFTask *)parseAndLogResponseDataAsync: (NSData*) data {
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    NSString *parsedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if ([parsedString length] > 0 && [parsedString rangeOfString:@"description"].location != NSNotFound && [parsedString rangeOfString:@"icon"].location != NSNotFound) {
        // This is a standard format how we are getting the json from Weather.com API at the time of writing this code.
        unsigned long start = [parsedString rangeOfString:@"\"description\""].location;
        unsigned long end = [parsedString rangeOfString:@"\"icon\""].location;
        
        NSString* smallForecastString = [parsedString substringWithRange:NSMakeRange(start + [@"\"description\":\"" length] , end - start - ([@"\"description\":" length] + [@"\",\"" length]))];
        [completion setResult:smallForecastString];
    }
    else {
        [completion setError:[NSError errorWithDomain:@"no data returned after a successful server communication." code:-1 userInfo:nil]];
    }
    return completion.task;
}

-(BFTask *)fetchCurrentWeatherAsyncFromAPIandparseResponseAsyncFor: (NSString*)city andCountry: (NSString*) country {
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    __weak __typeof__(self) weakSelf = self;
    __strong __typeof__(self) strongWeakSelf = weakSelf;
    
    // this continue block happens on default BFTaskExecutor
    [[weakSelf fetchCurrentWeatherAsyncFromAPIFor:city andCountry:country] continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (task.error == nil) {
            BFTask* nextTask = [strongWeakSelf parseAndLogResponseDataAsync:(NSData*)[task result]];
            if ([nextTask error] == nil) {
                [completion setResult:[nextTask result]];
            }
            else {
                [completion setError:[nextTask error]];
            }
        }else {
            [completion setError:task.error];
        }
        return nil;
    }];
    return completion.task;
}
@end
