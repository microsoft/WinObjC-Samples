# Using Projections: Cortana

Cortana offers a robust and comprehensive extensibility framework that enables you to seamlessly incorporate functionality from your app into the Cortana experience. With Cortana, your app can be activated to the foreground and an action or command executed within the app using voice and typed commands.

These are the basic steps to add voice command functionality and integrate Cortana with your app using speech or keyboard input:

1. **Create a Voice Command Definition (VCD) file and register it when the app is launched.** The VCD file is an XML document that defines all the spoken commands that the user can say to initiate actions or invoke commands when activating your app. For more information, see [VCD elements and attributes v1.2](https://msdn.microsoft.com/library/windows/apps/dn706593).
2. **Handle the activation-by-voice command.** You may want to handle launch differently depending on the method by which a user launched your app.

## Running the Sample
1. Open the CortanaSample-WinStore10.sln Visual Studio solution.
2. Ensure that the project includes the CortanaSample\CortanaSampleCommands.xml VCD file. If it does not, add it by selecting **Project** > **Add Existing Item**.
3. Build and deploy the application to your phone or PC.
4. Start the sample app for the first time, which should automatically register it with Cortana. **Close it immediately.**
5. Open **Cortana** and try making some of the pre-configured queries. These can be performed via voice or by typing them into Cortana's search bar:
    * "Cortana Sample, show trip to London."
    * "Show trip to Long Island in Cortana Sample."
    * "Show my Cortana Sample trip to Rio."
6. The sample app should open automatically, and reflect the query made to Cortana.

## The Code

The code for incorporating Cortana functionality using Objective-C looks like this:

**VCD XML File**
*Describes the commands and phrases to listen for*
```xml
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
```

**AppDelegate.m**
*Registers VCD file and handles the activation-by-voice command*
```Objective-C
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#ifdef WINOBJC
	WAPackage *package = [WAPackage current];
	WSStorageFolder *installedLocation = package.installedLocation;

	// Load VCD XML file describing voice commands from app installation location
	[installedLocation getFileAsync:@"CortanaSampleCommands.xml"
							success:^(WSStorageFile *storageFile) {
								// Install commands
								[WAVVoiceCommandDefinitionManager installCommandDefinitionsFromStorageFileAsync:storageFile];
							}
							failure:^(NSError *error) {
								NSLog(@"Failed to load commands file: %@", error);
							}];

	// Handle activation-by-voice command
	if (launchOptions != nil) {
		// Check for the key containing WMSSpeechRecognitionResults
		if(launchOptions[UIApplicationLaunchOptionsVoiceCommandKey]){
			WMSSpeechRecognitionResult* result = launchOptions[UIApplicationLaunchOptionsVoiceCommandKey];
			ViewController* viewController = (ViewController*) [[application keyWindow] rootViewController];
			[viewController setSpeechRecognitionLabelsWithSpeechRecognitionResult:result];
		}
	}
#endif
	return YES;
}
```
**ViewController.m**
*Updates views using WMSSpeechRecognitionResult*
```Objective-C
#ifdef WINOBJC
- (void)setSpeechRecognitionLabelsWithSpeechRecognitionResult:(WMSSpeechRecognitionResult*)result
{
	// The recognized phrase from what the user said
	NSString* destination = result.semanticInterpretation.properties[@"destination"][0];

	// What the user said
	NSString* spokenText = result.text;

	// Was the voice command actually spoken or typed in
	NSString* commandMode = result.semanticInterpretation.properties[@"commandMode"][0];

	// The command name of the speech recognition result
	NSString* voiceCommandName = result.rulePath[0];
}
#endif
```

Read on for a complete explanation of how the above code works.

## Tutorial

You can find the Cortana sample project under */Scenarios/Cortana/CortanaSample*. The project consists of a number of labels; when the activation-by-voice command is received, the labels are updated with the command, spoken text, and method by which the app was activated.

Let’s walk through adding the Cortana functionality.

### Add UWP framework headers
We need the public headers for the relevant UWP frameworks. In the extracted SDK (or your built SDK directory, if you’ve cloned [WinObjC from GitHub and built the project from source](https://github.com/Microsoft/WinObjC)), go to the [include\Platform\Universal Windows\UWP](https://github.com/Microsoft/WinObjC/tree/master/include/Platform/Universal Windows/UWP) directory and take a look at what you find. Each header file represents a different namespace within the [Windows Runtime APIs](https://msdn.microsoft.com/en-us/library/windows/apps/br211377.aspx). For our purposes, we will need APIs from:

-	[Windows.ApplicationModel](https://msdn.microsoft.com/en-us/library/windows/apps/windows.applicationmodel.aspx)
-	[Windows.Storage](https://msdn.microsoft.com/en-us/library/windows/apps/windows.storage.aspx)
-	[Windows.Media.SpeechRecognition](https://msdn.microsoft.com/en-us/library/windows/apps/windows.media.speechrecognition.aspx)

To include these frameworks – and make sure they’re only included when the code is being run on Windows – we’ll start by adding an #ifdef and two #import macros to the top of our application delegate implementation file:

*AppDelegate.m*
```Objective-C
#ifdef WINOBJC
#import <UWP/WindowsApplicationModel.h>
#import <UWP/WindowsStorage.h>
#import <UWP/WindowsApplicationModelVoiceCommands.h>
#endif
```

Next, we’ll extend the application delegate `application:didFinishLaunchingWithOptions` method to register the voice command set in the VCD XML file when the app is launched:

```Objective-C
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#ifdef WINOBJC
	WAPackage *package = [WAPackage current];
	WSStorageFolder *installedLocation = package.installedLocation;

	// Load VCD XML file describing voice commands from app installation location
	[installedLocation getFileAsync:@"CortanaSampleCommands.xml"
							success:^(WSStorageFile *storageFile) {
								// Install commands
								[WAVVoiceCommandDefinitionManager installCommandDefinitionsFromStorageFileAsync:storageFile];
							}
							failure:^(NSError *error) {
								NSLog(@"Failed to load commands file: %@", error);
							}];
#endif
	return YES;
}
```

Now when you run the application the VCD XML file's commands will be registered with the system.

### Handle activation by voice command
You may want to handle app activation differently depending on how the user launched your app (Start Menu, previously launched apps, or Cortana). To do so, you'll need to handle the `WMSSpeechRecognitionResult` result in `application:didReceiveVoiceCommand`, `application:didFinishLaunchingWithOptions`, `application:willFinishLaunchingWithOptions`.

Update the *AppDelegate.m* method `application:didFinishLaunchingWithOptions` to handle the activation-by-voice command by checking the `LaunchOptions` dictionary for `UIApplicationLaunchOptionsVoiceCommandKey` and grabbing the `WMSSpeechRecognitionResult` value:

```Objective-C
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#ifdef WINOBJC
	[...]
	// Handle activation-by-voice command
	if (launchOptions != nil) {
		// Check for the key containing WMSSpeechRecognitionResults
		if(launchOptions[UIApplicationLaunchOptionsVoiceCommandKey]){
			WMSSpeechRecognitionResult* result = launchOptions[UIApplicationLaunchOptionsVoiceCommandKey];
			ViewController* viewController = (ViewController*) [[application keyWindow] rootViewController];
			[viewController setSpeechRecognitionLabelsWithSpeechRecognitionResult:result];
		}
	}
#endif
	return YES;
}
```

Add the new `application:didReceiveVoiceCommand` delegate method for responding to voice commands:

```Objective-C
#ifdef WINOBJC
// Called when a voice command is received
- (void)application:(UIApplication *)application didReceiveVoiceCommand:(WMSSpeechRecognitionResult*)result
{
	ViewController* viewController = (ViewController*) [[application keyWindow] rootViewController];
	[viewController setSpeechRecognitionLabelsWithSpeechRecognitionResult:result];
}
#endif
```

`application:willFinishLaunchingWithOptions` can also be updated to respond to voice commands as well:

```Objective-C
- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	if(launchOptions != nil){
#ifdef WINOBJC
		if(launchOptions[UIApplicationLaunchOptionsVoiceCommandKey]) {
			// You could handle WMSSpeechRecognitionResult in here also
		}
#endif
	}
	return YES;
}
```

#### Update the UI to respond to users' voice commands
The *CortanaSample* project contains code to display the results of voice commands in text labels.  You'll want to add your own functionality to respond to users' voice commands.

That’s it! You’re done. Now, try asking Cortana to show your trips.

When Cortana is listening, here are some of the voice commands that work in the sample:
* "Cortana Sample, show trip to London"

Infix and suffix forms are also supported:
* "Show trip to Rioin in Cortana Sample"
* "Show my Cortana Sample trip to London"

## Additional Reading
Want a deeper dive into everything Cortana can do? Check out:
- The [Cortana interactions in UWP apps](https://msdn.microsoft.com/windows/uwp/input-and-devices/cortana-interactions)
- The iOS bridge [UWP header libraries](https://github.com/Microsoft/WinObjC/tree/master/include/Platform/Universal Windows/UWP) to find the exact APIs you need.
- The iOS bridge [Dev Design Specification for Cortana Activation] (https://github.com/Microsoft/WinObjC/blob/develop/docs/Foundation/CortanaForegroundActivation.md) to learn more about how Cortana is exposed to Objective-C apps.

Microsoft also hosts an excellent [design guide to Cortana user experience](https://msdn.microsoft.com/en-us/library/windows/apps/xaml/dn974233.aspx) on MSDN.
