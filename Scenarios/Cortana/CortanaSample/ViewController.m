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
// WinObjC Sample - Cortana    ///////
// github.com/Microsoft/WinObjC //////
//////////////////////////////////////

#import "ViewController.h"

#ifdef WINOBJC
#import <UWP/WindowsUINotifications.h>
#import <UWP/WindowsDataXmlDom.h>
#import <UWP/WindowsApplicationModelVoiceCommands.h>
#endif

@interface ViewController ()

@property UILabel *demoTitle;
@property UILabel *demoInfo;
@property UILabel *labelVoiceCommand;
@property UILabel *labelTextSpoken;
@property UILabel *labelDestination;
@property UILabel *labelCommandMode;

@end

@implementation ViewController

// WinObjC example app constants
static NSString * kTitleString = @"Cortana Sample";
static NSString * kInfoString = @"This WinObjC sample project demonstrates how to interact with Cortana using Objective-C. The below labels will be updated with the command, spoken text, phrase and how the app was activated with. When launched using Cortana.";
static NSString * kLabelVoiceCommandInitialText = @"VOICECOMMAND";
static NSString * kLabelTextSpokenInitialText = @"TEXTSPOKEN";
static NSString * kLabelDestinationInitialText = @"DESTINATION";
static NSString * klabelCommandModeText = @"COMMANDMODE";

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // Set up the demo title label
    self.demoTitle = [UILabel new];
    self.demoTitle.text = [NSString stringWithFormat:@"WinObjC: %@", kTitleString];
    self.demoTitle.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
    self.demoTitle.textAlignment = NSTextAlignmentCenter;
    self.demoTitle.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Set up the demo info label
    self.demoInfo = [UILabel new];
    self.demoInfo.text = kInfoString;
    self.demoInfo.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    self.demoInfo.numberOfLines = 0;
    self.demoInfo.lineBreakMode = NSLineBreakByWordWrapping;
    self.demoInfo.textAlignment = NSTextAlignmentCenter;
    self.demoInfo.translatesAutoresizingMaskIntoConstraints = NO;
        
    // Set up the labels
	self.labelVoiceCommand = [UILabel new];
    self.labelVoiceCommand.text = kLabelVoiceCommandInitialText;
    self.labelVoiceCommand.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    self.labelVoiceCommand.numberOfLines = 0;
    self.labelVoiceCommand.lineBreakMode = NSLineBreakByWordWrapping;
    self.labelVoiceCommand.textAlignment = NSTextAlignmentCenter;
    self.labelVoiceCommand.translatesAutoresizingMaskIntoConstraints = NO;

	self.labelTextSpoken = [UILabel new];
    self.labelTextSpoken.text = kLabelTextSpokenInitialText;
    self.labelTextSpoken.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    self.labelTextSpoken.numberOfLines = 0;
    self.labelTextSpoken.lineBreakMode = NSLineBreakByWordWrapping;
    self.labelTextSpoken.textAlignment = NSTextAlignmentCenter;
    self.labelTextSpoken.translatesAutoresizingMaskIntoConstraints = NO;

    self.labelDestination = [UILabel new];
    self.labelDestination.text = kLabelDestinationInitialText;
    self.labelDestination.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    self.labelDestination.numberOfLines = 0;
    self.labelDestination.lineBreakMode = NSLineBreakByWordWrapping;
    self.labelDestination.textAlignment = NSTextAlignmentCenter;
    self.labelDestination.translatesAutoresizingMaskIntoConstraints = NO;

	self.labelCommandMode = [UILabel new];
    self.labelCommandMode.text = klabelCommandModeText;
    self.labelCommandMode.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    self.labelCommandMode.numberOfLines = 0;
    self.labelCommandMode.lineBreakMode = NSLineBreakByWordWrapping;
    self.labelCommandMode.textAlignment = NSTextAlignmentCenter;
    self.labelCommandMode.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.demoTitle];
    [self.view addSubview:self.demoInfo];
    [self.view addSubview:self.labelVoiceCommand];
	[self.view addSubview:self.labelTextSpoken];
    [self.view addSubview:self.labelDestination];
	[self.view addSubview:self.labelCommandMode];
    
    // Layout constraints
    NSDictionary *metrics = @{ @"pad": @80.0, @"margin": @40, @"demoInfoHeight": @120 };
    NSDictionary *views = @{ @"title"				: self.demoTitle,
                             @"info"				: self.demoInfo,
							 @"voiceCommandLabel"	: self.labelVoiceCommand,
                             @"textSpokenLabel"		: self.labelTextSpoken,
                             @"destinationLabel"	: self.labelDestination,
							 @"commandModeLabel"	: self.labelCommandMode
                            };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[title]-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[info]-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[voiceCommandLabel]-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[textSpokenLabel]-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[destinationLabel]-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[commandModeLabel]-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[title]-[info(demoInfoHeight)]-margin-[voiceCommandLabel]-[textSpokenLabel]-[destinationLabel]-[commandModeLabel]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

#ifdef WINOBJC
    [[UIApplication sharedApplication] setStatusBarHidden:YES]; // Deprecated in iOS
#endif
}

- (BOOL) prefersStatusBarHidden
{
    return YES;
}

- (void)voiceCommand: (NSString*)text{
	kLabelVoiceCommandInitialText = text;
    self.labelVoiceCommand.text = kLabelVoiceCommandInitialText;
}

- (void)textSpoken: (NSString*)text{
	kLabelTextSpokenInitialText = text;
    self.labelTextSpoken.text = kLabelTextSpokenInitialText;
}

- (void)launchedBy: (NSString*)text{
	klabelCommandModeText = text;
	self.labelCommandMode.text = klabelCommandModeText;
}

- (void)semanticInterpretation: (NSString*)text{
	kLabelDestinationInitialText = text;
	self.labelDestination.text = kLabelDestinationInitialText;
}

#ifdef WINOBJC
- (void)setSpeechRecognitionLabelsWithSpeechRecognitionResult:(WMSSpeechRecognitionResult*)result {
	
	// the recognized phrase from what the user said
	NSString* destination = result.semanticInterpretation.properties[@"destination"][0];

	// what the user said
	NSString* spokenText = result.text;

	// was the voice command actually spoken or typed in
	NSString* commandMode = result.semanticInterpretation.properties[@"commandMode"][0];

	// the command name of the speech recognition result
	NSString* voiceCommandName = result.rulePath[0];

	// set labels
	[self semanticInterpretation:destination];
	[self textSpoken:spokenText];
	[self launchedBy:commandMode];
	[self voiceCommand:voiceCommandName];
}
#endif

@end
