//******************************************************************************
//
// Copyright (c) 2017 Microsoft Corporation. All rights reserved.
//
// This code is licensed under the MIT License (MIT).
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//******************************************************************************

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
