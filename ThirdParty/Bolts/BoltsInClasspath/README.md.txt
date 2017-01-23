The sample uses weather.com free subscription rest API to demonstrate the Bolts usage. Please register for free and use the token generated from Weather.com and replace it 
with apiKey placeholder in the Constants.m file

Note: Make sure this folder and Winobjc release folders exist in the same directory. otherwise it may not run.

In the BoltsInClassPath sample app to make this app run on WINOBJC I have found two issues in the app build phase.
 
1) When you start building app you may encounter
 Bolts.lib (BFExecutor_F456FB2F.obj) : error LNK 2019: unresolved external symbol _pthread_get_stackaddr_np referenced in function remaining_stack_size
 Bolts.lib (BFExecutor_F456FB2F.obj) : error LNK 2019: unresolved external symbol _pthread_get_stacksize_np referenced in function remaining_stack_size

This happens because I see a different implementations for pThread on Winobjc. so my temp workaround is

go to your Bolts dependency in the solution and navigate to Bolts/Bolts/Common/BFExecutor.m file. change the below method implementation like this.

__attribute__((noinline)) static size_t remaining_stack_size(size_t *restrict totalSize) {

    pthread_t currentThread = pthread_self();

    
	// NOTE: We must store stack pointers as uint8_t so that the pointer math is well-defined
    
	uint8_t *endStack = 0;//pthread_get_stackaddr_np(currentThread);
    
	*totalSize = 0;//pthread_get_stacksize_np(currentThread);

    
	// NOTE: If the function is inlined, this value could be incorrect
    
	uint8_t *frameAddr = __builtin_frame_address(0);

    
	return (*totalSize) - (endStack - frameAddr);

}


2) go to your Bolts dependency in the solution and navigate to Bolts/Public Headers/Bolts.h file. change the line in import statements like this.
	#if __has_include(<Bolts/BFAppLink.h>) && WINOBJC && !TARGET_OS_WATCH && !TARGET_OS_TV


Now Build and run the sample on to simulator.

Note: APPLinks part of BoltsAPI was not yet implemented.

All the methods listed below are used in sample and are tested on both iOS and Windows environment.

BFExecutor mainThreadExecutor
BFExecutor defaultExecutor
BFExecutor executorWithDispatchQueue:
BFExecutor executorWithBlock:


BFTaskCompletionSource taskCompletionSource
BFTaskCompletionSource setResult:
BFTaskCompletionSource completion setError:


BFTask continueWithBlock:
BFTask taskForCompletionOfAllTasksWithResults:
BFTask continueWithExecutor:   withBlock:
BFTask continueWithSuccessBlock:  cancellationToken:


BFCancellationTokenSource cancellationTokenSource
BFCancellationTokenSource cancel


BFCancellationToken registerCancellationObserverWithBlock:
BFCancellationToken cancelationRequested


BFCancellationTokenRegistration dispose