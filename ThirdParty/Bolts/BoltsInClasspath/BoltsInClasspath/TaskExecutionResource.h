//
//  TaskExecutionResource.h
//  WinObjcBoltsTest
//
//  Created by siva kongara on 1/12/17.
//  Copyright © 2017 venkat kongaraSiva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bolts/Bolts.h>

@interface TaskExecutionResource : NSObject

+(BFExecutor*) mainThreadBFExecutor;
+(BFExecutor*) defaultGCDBFExecutor;
+(BFExecutor*) immediateBFThreadExecutor;
+(BFExecutor*) dispatchQueueBFThreadExecutor;
+(BFExecutor*) executeBFTaskOnBlock:(void (^)(void))block;

@end
