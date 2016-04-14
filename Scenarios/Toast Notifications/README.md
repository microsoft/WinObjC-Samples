# Using Projections: Toast Notifications

Toast notifications allow Windows users to create adaptive, interactive and flexible pop-up notifications. They can contain text, images, and buttons and inputs for user interaction. Toast notifications also allow foreground activation of the app that generated them and the activation of other apps via protocol activation. For more information on toast notification terms and concepts, see [Toast Notification and Action Center Overview for Windows 10](https://blogs.msdn.microsoft.com/tiles_and_toasts/2015/07/08/toast-notification-and-action-center-overview-for-windows-10/).

There are 4 steps to create a toast notification:

1. Construct the notification XML payload
  1. Construct the visual part of the payload
  2. Construct the actions part of the payload (optional)
2. Create a toast notification object with the XML payload
3. Provide an identity tag and a group id to the notification (optional)
4. Send the notification via a notification manager object
 
## The Code

The code for creating a toast notification with rich content using Objective-C looks like this:

```Objective-C
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
```

For creating a toast notification with actions, it looks like this:

```Objective-C
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
    
    // Provide tag and group to the notification
    notification.tag = @"myTag";
    notification.group = @"myGroup";
    
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
    
    // Create the toast notification manager 
    WUNToastNotifier *toastNotifier = [WUNToastNotificationManager createToastNotifier];
    
    // Show the toast notification
    [toastNotifier show:notification];
  #endif
```

Read on for a complete explanation of how the above code works.

## Tutorial
You can find the Toast Notification sample project under */Scenarios/Toast Notifications/ToastNotificationsSample*. The project consists of 2 buttons and their corresponding labels. When the buttons are pressed, their labels are updated with the date/time that they were pressed.

```Objective-C
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
  }

  - (void) actionNotificationButtonPressed
  {
    // Update button label
    NSString *timeDateString = [self getTimeDateString];
    self.richNotificationLabel.text = [NSString stringWithFormat:@"Button pressed at: %@", timeDateString];
  }
```
You will now update this app to have the top button send a toast notification with rich content, and the bottom one send a toast notification with 2 actions: one action will activate the Maps app via protocol activation, and the other will reactivate the app in the foreground.

### Setting Up

First, open up the *ToastNotificationSample* directory in your Windows command prompt. You will run the [VSImporter tool](https://github.com/Microsoft/WinObjC/wiki/Using-vsimporter) from the WinObjC SDK on the ToastNotificationSample project to generate a Visual Studio solution file (.sln).

*Example:*
```
c:\> cd "\winobjc-samples\Scenarios\Toast Notifications\ToastNotificationSample"
c:\winobjc-samples\Scenarios\Toast Notifications\ToastNotificationSample> \winobjc-sdk\bin\vsimporter.exe
Generated c:\winobjc-samples\Scenarios\Toast Notifications\ToastNotificationSample\ToastNotificationsSample.vsimporter\ToastNotificationsSample-Headers-WinStore10\ToastNotificationsSample-Headers.vcxitems
Generated c:\winobjc-samples\Scenarios\Toast Notifications\ToastNotificationSample\ToastNotificationsSample.vsimporter\ToastNotificationsSample-WinStore10\ToastNotificationsSample.vcxproj
Generated c:\winobjc-samples\Scenarios\Toast Notifications\ToastNotificationSample\ToastNotificationsSample-WinStore10.sln

c:\winobjc-samples\Scenarios\Toast Notifications\ToastNotificationSample>
```
Once you've generated the .sln file, open it in Visual Studio.

To implement toast notifications, you will need the public headers for the relevant UWP frameworks. In the extracted SDK (or your built SDK directory, if you’ve cloned [WinObjC from GitHub and built the project from source](https://github.com/Microsoft/WinObjC)), go to the [include\Platform\Universal Windows\UWP](https://github.com/Microsoft/WinObjC/tree/master/include/Platform/Universal Windows/UWP) directory and take a look at what you find. Each header file represents a different namespace within the [Windows Runtime APIs](https://msdn.microsoft.com/en-us/library/windows/apps/br211377.aspx). For our purposes, you will need APIs from:

-	[Windows.UI.Notifications](https://msdn.microsoft.com/en-us/library/windows/apps/windows.ui.notifications.aspx)
-	[Windows.Data.Xml.Dom](https://msdn.microsoft.com/en-us/library/windows/apps/windows.data.xml.dom.aspx)

To include these frameworks – and make sure they’re only included when the code is being run on Windows – start by adding an **#ifdef** and two **#import** macros to the top of the view controller implementation file:

```Objective-C
  #ifdef WINOBJC
  #import <UWP/WindowsUINotifications.h>
  #import <UWP/WindowsDataXmlDom.h>
  #endif
```

Next, extend the buttons action methods with additional **#ifdef**.
```Objective-C
  - (void) richNotificationButtonPressed
  {
    // Update button label
    NSString *timeDateString = [self getTimeDateString];
    self.richNotificationLabel.text = [NSString stringWithFormat:@"Button pressed at: %@", timeDateString];
    
    // Create toast notification if on WinObjC
    #ifdef WINOBJC
    #endif
  }

  - (void) actionNotificationButtonPressed
  {
    // Update button label
    NSString *timeDateString = [self getTimeDateString];
    self.richNotificationLabel.text = [NSString stringWithFormat:@"Button pressed at: %@", timeDateString];
    
    // Create toast notification if on WinObjC
    #ifdef WINOBJC
    #endif
  }
```

### Send a Toast Notification With Rich Content
In this example, you will modify the top button action method **richNotificationButtonPressed** so that it sends a a toast notification with rich content.

#### Construct the Visual Part of the Notification XML Payload
First, you will build an XML doc that fits the new flexible and adaptive toast template schema: ToastGeneric. This allows the number of text lines, optional profile picture that replaces the logo, and optional inline picture, to be all managed at once. 

```Objective-C
  -(void)richNotificationButtonPressed
  {
    [...]
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
    #endif
  }
```

See the [Adaptive and interactive toast notifications for Windows 10](https://blogs.msdn.microsoft.com/tiles_and_toasts/2015/07/02/adaptive-and-interactive-toast-notifications-for-windows-10/) documentation for more information on the XML structure of toast notifications.

As you build using Objective-C projections, you will notice that the standard naming scheme for these objects has been modified to match Objective-C conventions, where classes are prefixed with the letters that constitute their containing namespace:

-	**Windows.Data.Xml.Dom.XmlDocument** becomes **WDXDXmlDocument**
-	**Windows.UI.Notifications.ToastNotification** becomes **WUNToastNotification**
-	**Windows.UI.Notifications.ToastNotificationManager** becomes **WUNToastNotificationManager**

#### Create a Toast Notification Object With the XML Payload
The next step is to generate a [ToastNotification](https://msdn.microsoft.com/en-us/library/windows/apps/xaml/windows.ui.notifications.toastnotification.aspx) object. For this step, take a quick look at the [WindowsUINotifications](https://github.com/Microsoft/WinObjC/blob/master/include/Platform/Universal Windows/UWP/WindowsUINotifications.h) header to see you what you need.

```Objective-C
  @interface WUNToastNotification : RTObject 
  + (WUNToastNotification*)makeToastNotification:(WDXDXmlDocument*)content ACTIVATOR; 
```

As shown above, you need to take the **WDXDXmlDocument** you just created and pass it to the **makeToastNotification** method:

```Objective-C
  -(void)richNotificationButtonPressed
  {
    [...]
    #ifdef WINOBJC
      [...]
      [tileXml loadXml:xmlDocument];
      
      // Create the toast notification object
      WUNToastNotification *notification = [WUNToastNotification makeToastNotification:tileXml];
    #endif
  }
```

#### Send the Notification Via a Notification Manager Object

To send a toast notification, use the **WUNToastNotificationManager** factory class to create an instance of **WUNToastNotifier**. Referencing the [ToastNotificationManager class documentation](https://msdn.microsoft.com/en-us/library/windows/apps/xaml/windows.ui.notifications.toastnotificationmanager.aspx), this is just a call to **createToastNotifier**:

```Objective-C
  -(void)richNotificationButtonPressed
  {
    [...]
    #ifdef WINOBJC
      [...]
      WUNToastNotification *notification = [WUNToastNotification makeToastNotification:tileXml];
    
      // Create the toast notification manager
      WUNToastNotifier *toastNotifier = [WUNToastNotificationManager createToastNotifier];
    #endif
  }
```

Referencing the [ToastNotifier class documentation](https://msdn.microsoft.com/en-us/library/windows/apps/xaml/windows.ui.notifications.toastnotifier.aspx) now, you only need to call its **show** method with the **WUNToastNotification** object you created to show the toast notification:

```Objective-C
  -(void)richNotificationButtonPressed
  {
    [...]
    #ifdef WINOBJC
      [...]
      WUNToastNotifier *toastNotifier = [WUNToastNotificationManager createToastNotifier];
      
      // Show the toast notification
      [toastNotifier show:notification];
    #endif
  }
```

That’s it! Now, press the top button to see your toast notification with rich content.

To send a toast notification with actions, continue reading below.

### Send a Toast Notification With Actions
In this example, you will modify the bottom button action method actionNotificationButtonPressed so that it sends a a toast notification with actions.

#### Construct the Visual Part of the Notification XML Payload
The code to build the visual part of the payload is very similar to the one for the notification with rich content, which was previously explained:

```Objective-C
  -(void)actionNotificationButtonPressed
  {
    [...]
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
    #endif
  }
```

#### Construct the Actions Part of the Notification XML Payload
After building the visual part of the XML payload, instead of finishing it by closing the toast tag, you will now add action elements to it.

##### Add the Show Map Action Using the Maps app
To launch another app from your toast notification, you need to activate it via protocol activation. This requires having the app you're trying to launch registered to become the default handler for a certain Uniform Resource Identifier (URI) scheme name. For more information, see the [How to handle URI activation (HTML)](How to handle URI activation (HTML)) documentation. 

For this example, you will activate the Maps app. See the [URI scheme for the Windows Maps app](https://msdn.microsoft.com/en-us/library/windows/apps/xaml/jj635237.aspx) documentation for a full description of the URI scheme supported by the app.

The code below creates a button labeled "Show map" in the toast notification, specified by the **content** attribute. The button will trigger the protocol activation of another app, according to the **activationType** attribute. Finally, the **arguments** attribute contains the URI to activate the Maps app, which conforms to the scheme of the above documentation.

```Objective-C
-(void)actionNotificationButtonPressed
  {
    [...]
    #ifdef WINOBJC
      [...]
      xmlDocument = [xmlDocument stringByAppendingString:@"</binding>\n</visual>\n"];
      
      // Add the show map action with protocol activation of the maps app
      xmlDocument = [xmlDocument stringByAppendingString:@"<actions><action activationType=\"protocol\" content=\"Show map\" arguments=\"bingmaps:?q=antelop%20canyon\"/>\n"];
    #endif
  }
```

After constructing the show map action element, finish building the XML payload and create the **WUNToastNotificatio**n object, as you did previously for the notification with rich content. 

```Objective-C
  -(void)actionNotificationButtonPressed
  {
    [...]
    #ifdef WINOBJC
      [...]
      xmlDocument = [xmlDocument stringByAppendingString:@"<actions><action activationType=\"protocol\" content=\"Show map\" arguments=\"bingmaps:?q=antelop%20canyon\"/>\n"];
      
      // Finish building the action and clean up the toast xml structure
        xmlDocument = [xmlDocument stringByAppendingString : @"</actions>\n</toast>"];
        
      // Parse the String to XML - https://blogs.msdn.microsoft.com/tiles_and_toasts/2015/07/08/quickstart-sending-a-local-toast-notification-and-handling-activations-from-it-windows-10/
      WDXDXmlDocument* tileXml = [WDXDXmlDocument make];
      [tileXml loadXml:xmlDocument];
      
      // Create the toast notification object
      WUNToastNotification *notification = [WUNToastNotification makeToastNotification:tileXml];
    #endif
  }
```

#### Add a Foreground Activation Event of the App
If you look at the [Quickstart: Sending a local toast notification and handling activations from it (Windows 10)](https://blogs.msdn.microsoft.com/tiles_and_toasts/2015/07/08/quickstart-sending-a-local-toast-notification-and-handling-activations-from-it-windows-10/205/), you might notice that the **activationType** attribute of the action element should be able to take the foreground and background values to handle those types of activation of the app. The Windows Bridge for iOS doesn't support this functionality yet, but there is a workaround for the foreground activation.

If you look again at the [ToastNotification class](https://msdn.microsoft.com/en-us/library/windows/apps/xaml/windows.ui.notifications.toastnotification.aspx) documentation, you might notice the [ToastNotification.Activated](https://msdn.microsoft.com/en-us/library/windows/apps/windows.ui.notifications.toastnotification.activated.aspx) event. Going back to
the [WindowsUINotifications](https://github.com/Microsoft/WinObjC/blob/master/include/Platform/Universal Windows/UWP/WindowsUINotifications.h) header under the **WUNToastNotification** class, you'll find that this events maps to the **addActivatedEvent** method below:

```Objective-C
  @interface WUNToastNotification : RTObject
  [...]
  - (EventRegistrationToken)addActivatedEvent:(void (^)(WUNToastNotification*, RTObject*))del;
```

This method allows you to activate your app in the foreground when the body of the toast notification is clicked, and to add a callback to the event. You will now have the callback update the button label with the time/date that the app is activated and the tag and group of the toast notification that activated the app.

```Objective-C
  -(void)actionNotificationButtonPressed
  {
    [...]
    #ifdef WINOBJC
      [...]
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
    #endif
  }
```

As shown in the code above, you need to cast the **RTObject args** object to the **WUNToastActivatedEventArgs** class to access the activation event arguments. You use the **rt_dynamic_cast** method for that, which you can find in the [InteropBase.h](https://github.com/Microsoft/WinObjC/blob/bcc7e1f88f39112f29e3d1be27c12995287cc798/include/Platform/Universal%20Windows/UWP/InteropBase.h) header. It enables the safe cast of the **RTObject** class into derived projected class types, like **WUNToastActivatedEventArgs**. 

Once you have an object of the **WUNToastActivatedEventArgs**, you can access its arguments through its NSString property of the same name, as you can again see in the [WindowsUINotifications](https://github.com/Microsoft/WinObjC/blob/master/include/Platform/Universal Windows/UWP/WindowsUINotifications.h) header:

```Objective-V
  @interface WUNToastActivatedEventArgs : RTObject 
  @property (readonly) NSString* arguments; 
  @end 
```

The arguments returned by the **WUNToastActivatedEventArgs** object of the callback of the activation event correspond to the **launch** attribute string of the toast element of the XML payload you created earlier:

```Objective-C
  -(void)actionNotificationButtonPressed
  {
    [...]
    // Create an XML payload that describes the visuals of the Toast Notification - https://msdn.microsoft.com/windows/uwp/controls-and-patterns/tiles-and-notifications-adaptive-interactive-toasts
    NSString *xmlDocument = @"<toast launch=\"antelope-canyon-toast\">\n<visual>\n<binding template=\"ToastGeneric\">\n";
    [...]
  }
```
The format and contents of this string are defined by the app developer for its own use. When the user taps or clicks the toast to launch its associated app, the launch string provides context to the app that can be used to show the user a view relevant to the toast content, rather than launching it in its default way.

### Provide an Identity Tag and a Group Id to the Notification
In the code of the previous section, you had the callback of the activation event of the app update the button label with the tag and group of the toast notification that generated the event. Those are properties of the **WUNToastNotification** class, which you can see in the [WindowsUINotifications](https://github.com/Microsoft/WinObjC/blob/master/include/Platform/Universal Windows/UWP/WindowsUINotifications.h) header:

```Objective-C
  @interface WUNToastNotification : RTObject
  [...]
  @property (retain) NSString* tag; 
  @property BOOL suppressPopup; 
  @property (retain) NSString* group;
  [...]
```
To set these properties, simply update them on the notification object:

```Objective-C
  -(void)actionNotificationButtonPressed
  {
    [...]
    #ifdef WINOBJC
      [...]
      [notification addActivatedEvent:^void(WUNToastNotification * sender, RTObject * args) 
      { 
        [...]
      }]; 
    
      // Provide tag and group to the notification 
      notification.tag = @"myTag"; 
      notification.group = @"myGroup"; 
    #endif
  }
```

Once that is done, simply create a **WUNToastNotifier** object and pass your notification object to it's **show** method to complete the sample app, as you did previously for the notification with rich content.

```Objective-C
  -(void)actionNotificationButtonPressed
  {
    [...]
    #ifdef WINOBJC
      [...]
      notification.group = @"myGroup"; 
      
      // Create the toast notification manager  
      WUNToastNotifier *toastNotifier = [WUNToastNotificationManager createToastNotifier]; 
        
      // Show the toast notification 
      [toastNotifier show:notification]; 
    #endif 
  }
```

That’s it! You’re done. Now, press the buttons and see your toast notifications in action.

## Additional Reading
For more code examples of additional toast notification functionalities, check out the [WinRTSample](https://github.com/Microsoft/WinObjC/tree/master/samples/WinRTSample) of the Windows Bridge for IOS SDK, and in particular the [ToastViewController.m](https://github.com/Microsoft/WinObjC/blob/master/samples/WinRTSample/WinRTSample/ToastsViewController.m) file.

Want a deeper dive into everything a toast notification can do? Check out:
- The [Adaptive and interactive toast notifications documentation](https://msdn.microsoft.com/windows/uwp/controls-and-patterns/tiles-and-notifications-adaptive-interactive-toasts)
- The [Quickstart: Sending a local toast notification and handling activations from it (Windows 10)](https://blogs.msdn.microsoft.com/tiles_and_toasts/2015/07/08/quickstart-sending-a-local-toast-notification-and-handling-activations-from-it-windows-10/205/)
- The [Toast Notification and Action Center Overview for Windows 10](https://blogs.msdn.microsoft.com/tiles_and_toasts/2015/07/08/toast-notification-and-action-center-overview-for-windows-10/)
- The iOS bridge [UWP header libraries](https://github.com/Microsoft/WinObjC/tree/master/include/Platform/Universal Windows/UWP) to find the exact API you need.

Microsoft also hosts [Guidelines for toast notifications](https://msdn.microsoft.com/en-us/library/windows/apps/hh465391.aspx) on MSDN.

## Known Issues
- The Windows bridge for IOS doesn't yet support the foreground and background values for the activationType attribute of the action element of the XML payload of toast notifications. There is a workaround for the foreground activation of an app in the "Add a Foreground Activation Event of the App" section of this tutorial.
