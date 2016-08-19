# Using Projections: Cortana

Cortana offers a robust and comprehensive extensibility framework that enables you to seamlessly incorporate functionality from your app into the Cortana experience. Using voice commands, your app can be activated to the foreground and an action or command executed within the app.

These are the basic steps to add voice-command functionality and integrate Cortana with your app using speech or keyboard input: 
1. Create a Voice Command Definition (VCD) file. This is an XML document that defines all the spoken commands that the user can say to initiate actions or invoke commands when activating your app. [VCD elements and attributes v1.2](https://msdn.microsoft.com/library/windows/apps/dn706593). 
2. Register the command sets in the VCD file when the app is launched. 
3. Handle the activation-by-voice-command.

## The Code

The code for incorporating Cortana functionality using Objective-C looks like this:
```VCD XML document
<?xml version="1.0" encoding="utf-8"?>
<VoiceCommands xmlns="http://schemas.microsoft.com/voicecommands/1.2">
  <CommandSet xml:lang="en-us" Name="CortanaSampleCommandSet_en-us">
    <AppName>Cortana Sample</AppName>
    <Example>Show trip to London</Example>

    <Command Name="showTripToDestination">
      <Example>Show trip to London</Example>
      <ListenFor RequireAppName="BeforeOrAfterPhrase">show [my] trip to {destination}</ListenFor>
      <ListenFor RequireAppName="ExplicitlySpecified">show [my] {builtin:AppName} trip to {destination}</ListenFor>
      <Feedback>Showing trip to {destination}</Feedback>
      <Navigate />
    </Command>
    <PhraseList Label="destination">
      <Item>London</Item>
      <Item>Long Island</Item>
      <Item>Melbourne</Item>
      <Item>North Dakota</Item>
      <Item>Rio</Item>
      <Item>Yosemite National Park</Item>
    </PhraseList>
  </CommandSet>
</VoiceCommands>

```Objective-C
	// register VCD
	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	#ifdef WINOBJC
		WAPackage *package = [WAPackage current];
		WSStorageFolder *installedLocation = package.installedLocation;

		// load command file from app installation location
		[installedLocation getFileAsync:@"CortanaSampleCommands.xml" 
										success:^(WSStorageFile *storageFile) {
											// install commands
											[WAVVoiceCommandDefinitionManager installCommandDefinitionsFromStorageFileAsync:storageFile];
										} 
										failure:^(NSError *error) {
											NSLog(@"Failed to load commands file: %@", error);
										}];
		
		// handle the activation-by-voice-command
		if (launchOptions != nil) {
			// check for the key containing WMSSpeechRecognitionResults 
			if(launchOptions[UIApplicationLaunchOptionsVoiceCommandKey]){
				WMSSpeechRecognitionResult* result = launchOptions[UIApplicationLaunchOptionsVoiceCommandKey];
				ViewController* viewController = (ViewController*) [[application keyWindow] rootViewController];
				[viewController setSpeechRecognitionLabelsWithSpeechRecognitionResult:result];
			}
		}
	#endif
		return YES;
	}
	
	#ifdef WINOBJC
	// 
	- (void)setSpeechRecognitionLabelsWithSpeechRecognitionResult:(WMSSpeechRecognitionResult*)result {
		
		// the recognized phrase from what the user said
		NSString* destination = result.semanticInterpretation.properties[@"destination"][0];

		// what the user said
		NSString* spokenText = result.text;

		// was the voice command actually spoken or typed in
		NSString* commandMode = result.semanticInterpretation.properties[@"commandMode"][0];

		// the command name of the speech recognition result
		NSString* voiceCommandName = result.rulePath[0];

		...
	}
	#endif
```

Read on for a complete explanation of how the above code works.

## Tutorial

You can find the Cortana sample project under */Scenarios/Cortana/CortanaSample*. The project consists of a number of labels; when the a activation-by-voice-command is received, the labels are updated with the command, spoken text, phrase and how the app was activated with.

Let’s update this app to send that information to the tile.

### Setting up
First, open up the *CortanaSample* directory at your windows prompt. 
You will run the [VSImporter tool](https://github.com/Microsoft/WinObjC/wiki/Using-vsimporter) from the WinObjC SDK on the CortanaSample project to generate a Windows solution file (.sln).

*Example:*
```
c:\> cd "\winobjc-samples\Scenarios\Cortana\CortanaSample"
c:\winobjc-samples\Scenarios\Cortana\CortanaSample> \winobjc-sdk\bin\vsimporter.exe
Generated c:\winobjc-samples\Scenarios\Cortana\CortanaSample\CortanaSample.vsimporter\CortanaSample-Headers-WinStore10\CortanaSample-Headers.vcxitems
Generated c:\winobjc-samples\Scenarios\Cortana\CortanaSample\CortanaSample.vsimporter\LiveTileSampleSample-WinStore10\CortanaSample.vcxproj
Generated c:\winobjc-samples\Scenarios\Cortana\CortanaSample\CortanaSample-WinStore10.sln

Once you've generated the .sln file, open it in Visual Studio.

We need the public headers for the relevant UWP frameworks. In the extracted SDK (or your built SDK directory, if you’ve cloned [WinObjC from GitHub and built the project from source](https://github.com/Microsoft/WinObjC)), go to the [include\Platform\Universal Windows\UWP](https://github.com/Microsoft/WinObjC/tree/master/include/Platform/Universal Windows/UWP) directory and take a look at what you find. Each header file represents a different namespace within the [Windows Runtime APIs](https://msdn.microsoft.com/en-us/library/windows/apps/br211377.aspx). For our purposes, we will need APIs from:

-	[Windows.ApplicationModel](https://msdn.microsoft.com/en-us/library/windows/apps/windows.applicationmodel.aspx)
-	[Windows.Storage](https://msdn.microsoft.com/en-us/library/windows/apps/windows.storage.aspx)
-	[Windows.Media.SpeechRecognition](https://msdn.microsoft.com/en-us/library/windows/apps/windows.media.speechrecognition.aspx)

To include these frameworks – and make sure they’re only included when the code is being run on Windows – we’ll start by adding an #ifdef and two #import macros to the top of our application delegate implementation file:

```Objective-C
#ifdef WINOBJC
#import <UWP/WindowsApplicationModel.h>
#import <UWP/WindowsStorage.h>
#import <UWP/WindowsApplicationModelVoiceCommands.h>
#endif
```

Next, we’ll extend the application delete :didFinishLaunchingWithOptions handler method with the code to register the command sets in the VCD file when the app is launched.

```Objective-C
#ifdef WINOBJC
	WAPackage *package = [WAPackage current];
	WSStorageFolder *installedLocation = package.installedLocation;

	// load command file from app installation location
	[installedLocation getFileAsync:@"CortanaSampleCommands.xml" 
									success:^(WSStorageFile *storageFile) {
										// install commands
										[WAVVoiceCommandDefinitionManager installCommandDefinitionsFromStorageFileAsync:storageFile];
									} 
									failure:^(NSError *error) {
										NSLog(@"Failed to load commands file: %@", error);
									}];
	...
#endif
```

### Add the XML VCD file to the project
For this sample a VCD file has already been created and is present in the Xcode project, you'll need to add the VCD file to the project so it's present in the apps installed location 
Right click on the project CortanaSample (Universal Windows)
Choose Add Existing Item
Add the XML Document (CortanaSampleCommands.xml) located in the original Xcode folder

Now when you run the application the XML VCD file's commands will be registered with the system
```
### Handle the activation-by-voice-command.
Depending on how the app is launched: Start Menu, previously launched, Cortana, you'll need to handle the WMSSpeechRecognitionResult result in application:didReceiveVoiceCommand, application:didFinishLaunchingWithOptions, application:willFinishLaunchingWithOptions

```Objective-C
	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	#ifdef WINOBJC
		...
		if (launchOptions != nil) {
			// check for the key containing WMSSpeechRecognitionResults 
			if(launchOptions[UIApplicationLaunchOptionsVoiceCommandKey]){
				WMSSpeechRecognitionResult* result = launchOptions[UIApplicationLaunchOptionsVoiceCommandKey];
				ViewController* viewController = (ViewController*) [[application keyWindow] rootViewController];
				[viewController setSpeechRecognitionLabelsWithSpeechRecognitionResult:result];
			}
		}
	#endif
		return YES;
	}

	#ifdef WINOBJC
	// Called when a voice command is received.
	- (void)application:(UIApplication *)application didReceiveVoiceCommand:(WMSSpeechRecognitionResult*)result {
		ViewController* viewController = (ViewController*) [[application keyWindow] rootViewController];
		[viewController setSpeechRecognitionLabelsWithSpeechRecognitionResult:result];
	}
	#endif

	- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
		if(launchOptions != nil){
	#ifdef WINOBJC
			if(launchOptions[UIApplicationLaunchOptionsVoiceCommandKey]){
				// you could handle WMSSpeechRecognitionResult in here also
			}
	#endif
		}
		return YES;
	}
```

TODO ADD MORE

That’s it! You’re done. Now, try asking Cortana to show your trip's.

## Additional Reading
Want a deeper dive into everything a Cortana can do? Check out:
- The [Cortana interactions in UWP apps](https://msdn.microsoft.com/windows/uwp/input-and-devices/cortana-interactions)
- The iOS bridge [UWP header libraries](https://github.com/Microsoft/WinObjC/tree/master/include/Platform/Universal Windows/UWP) to find the exact API you need.

Microsoft also hosts an excellent [design guide to Cortana user experience](https://msdn.microsoft.com/en-us/library/windows/apps/xaml/dn974233.aspx) on MSDN.










