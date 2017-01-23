//
//  TaskExecutionResource.m
//  WinObjcBoltsTest
//
//  Created by siva kongara on 1/12/17.
//  Copyright © 2017 venkat kongaraSiva. All rights reserved.
//

#import "TaskExecutionResource.h"

@implementation TaskExecutionResource

+(BFExecutor*) mainThreadBFExecutor {
    return [BFExecutor mainThreadExecutor];
}

+(BFExecutor*) defaultGCDBFExecutor{
     return [BFExecutor defaultExecutor];
}

+(BFExecutor*) immediateBFThreadExecutor{
     return [BFExecutor immediateExecutor];
}

+(BFExecutor*) dispatchQueueBFThreadExecutor {
    NSString* dipatchQueueLabel = @"org.microsoft.Bolts.Winobjc.Test";
    dispatch_queue_t queue = dispatch_queue_create([dipatchQueueLabel cStringUsingEncoding:NSUTF8StringEncoding], DISPATCH_QUEUE_CONCURRENT);
    return [BFExecutor executorWithDispatchQueue: queue];
}

+(BFExecutor*) executeBFTaskOnBlock:(void (^)(void))block{
    return [BFExecutor executorWithBlock:^(void (^ _Nonnull block)()) {
        block();
    }];
}
@end
