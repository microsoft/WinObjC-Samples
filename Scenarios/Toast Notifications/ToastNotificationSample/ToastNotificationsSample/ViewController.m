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

///////////////////////////////////////////////
// WinObjC Sample - Toast Notifications ///////
// github.com/Microsoft/WinObjC ///////////////
///////////////////////////////////////////////

#import "ViewController.h"

#ifdef WINOBJC
#import <UWP/WindowsUINotifications.h>
#import <UWP/WindowsDataXmlDom.h>
#endif

@interface ViewController()

@property UILabel *demoTitle;
@property UILabel *demoInfo;
@property UILabel *richNotificationLabel;
@property UIButton *richNotificationButton;
@property UILabel *actionNotificationLabel;
@property UIButton *actionNotificationButton;

@end

@implementation ViewController

// WinObjC example app constants
static NSString * const kTitleString = @"Toast Notifications";
static NSString * const kInfoString = @"This WinObjC sample project demonstrates how to create flexible and interactive toast notifications using Objective-C. The buttons below will update the labels under them with a timestamp. When running on Windows 10, the first one will also pop a local toast notification with rich content. The second one will pop a toast notification with actions: clicking on the notification will handle foreground activation of the app, and clicking on the \"show map\" button will launch the Maps app.";
static NSString * const kRichNotificationButtonText = @"Toast notification with rich content";
static NSString * const kActionNotificationButtonText = @"Toast notification with actions";
static NSString * const kLabelInitialText = @"Press the button to generate a toast notification.";

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
    
    // Set up the rich notification button
    self.richNotificationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.richNotificationButton setTitle:kRichNotificationButtonText
                                 forState:UIControlStateNormal];
    [self.richNotificationButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.richNotificationButton addTarget:self
                                    action:@selector(richNotificationButtonPressed)
                          forControlEvents:UIControlEventTouchUpInside];
    
    // Set up the rich notification label
    self.richNotificationLabel = [UILabel new];
    self.richNotificationLabel.text = kLabelInitialText;
    self.richNotificationLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    self.richNotificationLabel.numberOfLines = 0;
    self.richNotificationLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.richNotificationLabel.textAlignment = NSTextAlignmentCenter;
    self.richNotificationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Set up the action notification button
    self.actionNotificationButton = [UIButton buttonWithType : UIButtonTypeRoundedRect];
    [self.actionNotificationButton setTitle:kActionNotificationButtonText
                                   forState:UIControlStateNormal];
    [self.actionNotificationButton setTranslatesAutoresizingMaskIntoConstraints : NO];
    [self.actionNotificationButton addTarget:self
                                      action:@selector(actionNotificationButtonPressed)
                            forControlEvents:UIControlEventTouchUpInside];
    
    // Set up the action notification label
    self.actionNotificationLabel = [UILabel new];
    self.actionNotificationLabel.text = kLabelInitialText;
    self.actionNotificationLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    self.actionNotificationLabel.numberOfLines = 0;
    self.actionNotificationLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.actionNotificationLabel.textAlignment = NSTextAlignmentCenter;
    self.actionNotificationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.demoTitle];
    [self.view addSubview:self.demoInfo];
    [self.view addSubview:self.richNotificationButton];
    [self.view addSubview:self.richNotificationLabel];
    [self.view addSubview:self.actionNotificationButton];
    [self.view addSubview:self.actionNotificationLabel];
    
    // Layout constraints
    NSDictionary *metrics = @{@"pad":@80.0, @"margin":@40, @"demoInfoHeight":@160 };
    NSDictionary *views = @{@"title":self.demoTitle,
                            @"info":self.demoInfo,
                            @"richNotificationButton":self.richNotificationButton,
                            @"richNotificationLabel":self.richNotificationLabel,
                            @"actionNotificationButton":self.actionNotificationButton,
                            @"actionNotificationLabel":self.actionNotificationLabel};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[title]-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[info]-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[richNotificationButton]-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[richNotificationLabel]-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[actionNotificationButton]-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[actionNotificationLabel]-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[title]-[info(demoInfoHeight)]-margin-[richNotificationButton]-[richNotificationLabel]-margin-[actionNotificationButton]-[actionNotificationLabel]"
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

- (NSString *) getTimeDateString
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat : @"MM-dd HH:mm"];
    NSString *timeDateString = [formatter stringFromDate : [NSDate date]];
    
    return timeDateString;
}

- (void) richNotificationButtonPressed
{
    // Update button label
    NSString *timeDateString = [self getTimeDateString];
    self.richNotificationLabel.text = [NSString stringWithFormat:@"Button pressed at: %@", timeDateString];
    
    // Create toast notification if on WinObjC
#ifdef WINOBJC
    // Get the toast notification data
    NSString *title = @"Andrew sent you a picture";
    NSString *content = @"Check this out: Antelope Canyon in Arizona!";
    NSString *profilePicture = @"ms-appx:///User Profile Picture.jpg";
    NSString *canyonPicture = @"ms-appx:///Canyon Picture.jpg";
    
    // Create an XML payload that describes the visuals of the Toast Notification - https://msdn.microsoft.com/windows/uwp/controls-and-patterns/tiles-and-notifications-adaptive-interactive-toasts
    NSString *xmlDocument = @"<toast launch=\"app-define-string\">\n<visual>\n<binding template=\"ToastGeneric\">\n";
    
    // Add the toast title
    xmlDocument = [xmlDocument stringByAppendingString:[NSString stringWithFormat:@"<text>%@</text>\n", title]];
    
    // Add the toast text content
    xmlDocument = [xmlDocument stringByAppendingString:[NSString stringWithFormat:@"<text>%@</text>\n", content]];
    
    // Add the toast text timestamp
    xmlDocument = [xmlDocument stringByAppendingString:[NSString stringWithFormat:@"<text>\Picture sent on %@\</text>\n", timeDateString]];
    
    // Add the toast logo
    xmlDocument = [xmlDocument stringByAppendingString:[NSString stringWithFormat:@"<image src=\"%@\" placement=\"appLogoOverride\" hint-crop=\"circle\"/>\n", profilePicture]];
    
    // Add the toast picture
    xmlDocument = [xmlDocument stringByAppendingString:[NSString stringWithFormat:@"<image src=\"%@\"/>\n", canyonPicture]];
    
    // Finish the visual and clean up the toast XML structure
    xmlDocument = [xmlDocument stringByAppendingString:@"</binding>\n</visual>\n</toast>"];
    
    // Parse the String to XML - https://blogs.msdn.microsoft.com/tiles_and_toasts/2015/07/08/quickstart-sending-a-local-toast-notification-and-handling-activations-from-it-windows-10/
    WDXDXmlDocument* tileXml = [WDXDXmlDocument make];
    [tileXml loadXml:xmlDocument];
    
    // Create the toast notification object
    WUNToastNotification *notification = [WUNToastNotification makeToastNotification:tileXml];
    
    // Create the toast notification manager
    WUNToastNotifier *toastNotifier = [WUNToastNotificationManager createToastNotifier];
    
    // Show the toast notification
    [toastNotifier show:notification];
#endif
}

- (void) actionNotificationButtonPressed
{
    // Update button label
    NSString *timeDateString = [self getTimeDateString];
    self.actionNotificationLabel.text = [NSString stringWithFormat:@"Button pressed at: %@", timeDateString];
    
    // Create toast notification if on WinObjC
#ifdef WINOBJC
    // Get the toast notification data
    NSString *title = @"Andrew sent you a picture";
    NSString *content = @"Check this out: Antelope Canyon in Arizona!";
    NSString *profilePicture = @"ms-appx:///User Profile Picture.jpg";
    
    // Create an XML payload that describes the visuals of the Toast Notification - https://msdn.microsoft.com/windows/uwp/controls-and-patterns/tiles-and-notifications-adaptive-interactive-toasts
    NSString *xmlDocument = @"<toast launch=\"antelope-canyon-toast\">\n<visual>\n<binding template=\"ToastGeneric\">\n";
    
    // Add the toast title
    xmlDocument = [xmlDocument stringByAppendingString:[NSString stringWithFormat:@"<text>%@</text>\n", title]];
    
    // Add the toast text content
    xmlDocument = [xmlDocument stringByAppendingString:[NSString stringWithFormat:@"<text>%@</text>\n", content]];
    
    // Add the toast text timestamp
    xmlDocument = [xmlDocument stringByAppendingString:[NSString stringWithFormat:@"<text>\Picture sent on %@\</text>\n", timeDateString]];
    
    // Add the toast logo
    xmlDocument = [xmlDocument stringByAppendingString:[NSString stringWithFormat:@"<image src=\"%@\" placement=\"appLogoOverride\" hint-crop=\"circle\"/>\n", profilePicture]];
    
    // Finish building the visual XML structure
    xmlDocument = [xmlDocument stringByAppendingString:@"</binding>\n</visual>\n"];
    
    // Add the show map action with protocol activation of the maps app
    xmlDocument = [xmlDocument stringByAppendingString:@"<actions><action activationType=\"protocol\" content=\"Show map\" arguments=\"bingmaps:?q=antelop%20canyon\"/>\n"];
    
    // Finish building the action and clean up the toast xml structure
    xmlDocument = [xmlDocument stringByAppendingString : @"</actions>\n</toast>"];
    
    // Parse the String to XML - https://blogs.msdn.microsoft.com/tiles_and_toasts/2015/07/08/quickstart-sending-a-local-toast-notification-and-handling-activations-from-it-windows-10/
    WDXDXmlDocument* tileXml = [WDXDXmlDocument make];
    [tileXml loadXml:xmlDocument];
    
    // Create the toast notification object
    WUNToastNotification *notification = [WUNToastNotification makeToastNotification:tileXml];
    
    // Add the notification foreground activation event
    [notification addActivatedEvent:^void(WUNToastNotification * sender, RTObject * args)
    {
    	// Cast the callback block args to their proper type
    	WUNToastActivatedEventArgs* toastArgs = rt_dynamic_cast([WUNToastActivatedEventArgs class], args);
    
    	// Get the event info and args
    	NSLog(@"Notification tag: %@", sender.tag);
    	NSLog(@"Notification group: %@", sender.group);
    	NSLog(@"Notification args: %@", toastArgs.arguments);
    
    	// Update button label
    	NSString *timeDateString = [self getTimeDateString];
    	self.actionNotificationLabel.text = [NSString stringWithFormat:@"App activated by toast with tag %@ and group %@ at %@", sender.tag, sender.group, timeDateString];
    }];
    
    // Provide tag and group to the notification
    notification.tag = @"myTag";
    notification.group = @"myGroup";
    
    // Create the toast notification manager 
    WUNToastNotifier *toastNotifier = [WUNToastNotificationManager createToastNotifier];
    
    // Show the toast notification
    [toastNotifier show:notification];
#endif
}

@end
