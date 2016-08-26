//******************************************************************************
//
// Copyright (c) 2016 Microsoft Corporation. All rights reserved.
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

//////////////////////////////////////
// WinObjC Sample - Cortana //////////
// github.com/Microsoft/WinObjC //////
//////////////////////////////////////

#import "AppDelegate.h"
#import "ViewController.h"

#ifdef WINOBJC
#import <UWP/WindowsApplicationModel.h>
#import <UWP/WindowsStorage.h>
#import <UWP/WindowsApplicationModelVoiceCommands.h>
#endif

@interface AppDelegate ()

@end

#ifdef WINOBJC
// Tell the WinObjC runtime the application size
@implementation UIApplication (UIApplicationInitialStartupMode)
+ (void)setStartupDisplayMode:(WOCDisplayMode*)mode {
    mode.autoMagnification = TRUE;
    mode.sizeUIWindowToFit = TRUE;
    mode.clampScaleToClosestExpected = FALSE;
    mode.fixedWidth = 0;
    mode.fixedHeight = 0;
    mode.magnification = 1.0;
}
@end
#endif

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	if(launchOptions != nil){
#ifdef WINOBJC
		if(launchOptions[UIApplicationLaunchOptionsVoiceCommandKey]){
			// You could handle WMSSpeechRecognitionResult in here also
		}
#endif
	}
	return YES;
}

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

#ifdef WINOBJC
// Called when a voice command is received
- (void)application:(UIApplication *)application didReceiveVoiceCommand:(WMSSpeechRecognitionResult*)result
{
    ViewController* viewController = (ViewController*) [[application keyWindow] rootViewController];
    [viewController setSpeechRecognitionLabelsWithSpeechRecognitionResult:result];
}
#endif

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

@end
