#BOLTS Sample Application

The sample uses openweathermap.org free subscription rest API to demonstrate the Bolts usage. Please register for free and use the token generated from https://home.openweathermap.org/users/sign_up and replace it with apiKey placeholder in the Constants.m file
This project uses bolts as a dependency. When you first clone the repo if you have included ‘--recursive’ skip the next statement. Else navigate to WinObjC-samples root directory and run the ‘git submodule update --init --recursive’ git command.

Now Make sure you are using the Bolts 1.8.4 version submodule which has hash Bolts1.8.4@e64deecb2f0e10ac0dbb71f522c7a5b9cafb0b4d
	(you can do that by navigating to the WinObjC-Samples/ThirdParty/Bolts/BoltsInClasspath/Bolts-ObjC-1.8.4 directory in cmd and type in git checkout 1.8.4)
	
Then follow the steps from WinObjC (https://github.com/Microsoft/WinObjC/#getting-started-with-the-bridge) github repo documentation to create a visual studio solution.

In Visual Studio expand the solution and navigate to Bolts folder. Then right click on Bolts target go to properties->clang->Enable ObjectiveC ARC and set it to YES(-fobjc-arc).Do this for the other target BoltsInClassPath also in subsequent BoltsInClassPath folder.

In the BoltsInClassPath sample app to make this app run on Windows you might find two issues in the app build phase.

1) When you start building the app you may encounter
 Bolts.lib (BFExecutor_F456FB2F.obj) : error LNK 2019: unresolved external symbol _pthread_get_stackaddr_np referenced in function remaining_stack_size
 Bolts.lib (BFExecutor_F456FB2F.obj) : error LNK 2019: unresolved external symbol _pthread_get_stacksize_np referenced in function remaining_stack_size

This happens because WinObjC uses a different implementation for pThread. On Windows, you'll have to go to your Bolts dependency in the solution and navigate to the Bolts/Bolts/Common/BFExecutor.m file. Change the below method implementation as shown:

```Objective-c
__attribute__((noinline)) static size_t remaining_stack_size(size_t *restrict totalSize) {

    pthread_t currentThread = pthread_self();


	// NOTE: We must store stack pointers as uint8_t so that the pointer math is well-defined

	uint8_t *endStack = 0;//pthread_get_stackaddr_np(currentThread);

	*totalSize = 0;//pthread_get_stacksize_np(currentThread);


	// NOTE: If the function is inlined, this value could be incorrect

	uint8_t *frameAddr = __builtin_frame_address(0);


	return (*totalSize) - (endStack - frameAddr);

}
```

```Objective-c
2) go to your Bolts dependency in the solution and navigate to Bolts/Public Headers/Bolts.h file. change the line in import statements like this.
	#if __has_include(<Bolts/BFAppLink.h>) && WINOBJC && !TARGET_OS_WATCH && !TARGET_OS_TV
```

Now Build and run the sample on to emulator.

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
