//
//  TaskManager.h
//  WinObjcBoltsTest
//
//  Created by siva kongara on 1/13/17.
//  Copyright © 2017 venkat kongaraSiva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bolts/Bolts.h>

@interface TaskManager : NSObject

+ (id)sharedManager;
-(BFTask *)fetchCurrentWeatherAsyncFromAPIandparseResponseAsyncFor: (NSString*)city andCountry: (NSString*) country ;

@end
