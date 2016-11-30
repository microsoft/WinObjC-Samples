# Using Projections: Radial Control

Radial controllers like the Surface Dial allow Windows users to enable a host of compelling and unique user interaction experiences for Windows and Windows apps. They support a rotate action, a click action and a press and hold action. For more radial controllers terms and concepts, see [Surface Dial interactions](https://msdn.microsoft.com/en-us/windows/uwp/input-and-devices/windows-wheel-interactions).

## The Code

Using Objective-C, the code for adding a custom menu item to the radial controller tool that responds to rotate and click actions looks like this:

```Objective-C
  #ifdef WINOBJC
  // Create a reference to the radial controller
    self.radialController = [WUIRadialController createForCurrentView];
    
    __block ViewController* blockSelf = self; // Ensures self will not be retained
    
    // Add a menu item for the new radial control tool
    [[[self.radialController menu] items] addObject:[WUIRadialControllerMenuItem createFromKnownIcon:@"MenuItem" value:WUIRadialControllerMenuKnownIconRuler]];
    
    // Add a handler for click input from the radial controller
    [self.radialController addButtonClickedEvent:^(WUIRadialController* controller, WUIRadialControllerButtonClickedEventArgs* args)
     {
         [blockSelf.switchControl setOn:!(blockSelf.switchControl.on) animated:YES];
     }];
    
    // Add a handler for rotation input from the radial controller
    [self.radialController addRotationChangedEvent:^(WUIRadialController* controller, WUIRadialControllerRotationChangedEventArgs* args)
     {
         [blockSelf.slider setValue:(blockSelf.slider.value + ([args rotationDeltaInDegrees]/360.0f)) animated:YES];
     }];
  #endif

```

Read on for a complete explanation of how the code above works.

## Tutorial
You can find the Radial Control sample project under */Scenarios/Radial Control/RadialControlSample*. The project consists of a slider, a label that is updated with the value of the slider and a switch.

```Objective-C
  @interface ViewController()

  @property UILabel *demoTitle;
  @property UILabel *demoInfo;
  @property UISlider *slider;
  @property UILabel *sliderLabel;
  @property UISwitch *switchControl;

  @end
  
  @implementation ViewController
  [...]
  
  -(void)sliderDidChange{
    self.sliderLabel.text = [NSString stringWithFormat:@"Slider value: %f", self.slider.value];
  }

  @end
```

You will now update this app to add a custom menu item to the radial controller tool that will respond to rotate and click actions by changing the slider value and toggling the swicth.

### Setting Up

First, open up the *RadialControlSample* directory in your Windows command prompt. You will run the [VSImporter tool](https://github.com/Microsoft/WinObjC/wiki/Using-vsimporter) from the WinObjC SDK on the RadialControlSample project to generate a Visual Studio solution file (.sln).

*Example:*
```
c:\> cd "\winobjc-samples\Scenarios\Radial Control\RadialControlSample"
c:\winobjc-samples\Scenarios\Radial Control\RadialControlSample> \winobjc-sdk\bin\vsimporter.exe
Generated C:\winobjcSamples\WinObjC-Samples\Scenarios\Radial Control\RadialControlSample\RadialControlSample.vsimporter\RadialControlSample-WinStore10\RadialControlSample.vcxproj
Generated C:\winobjcSamples\WinObjC-Samples\Scenarios\Radial Control\RadialControlSample\RadialControlSample-WinStore10.sln

C:\winobjcSamples\WinObjC-Samples\Scenarios\Radial Control\RadialControlSample>
```

Once you've generated the .sln file, open it in Visual Studio.

To implement radial controller features in your app, you will need the public headers for the relevant UWP frameworks. In the extracted SDK (or your built SDK directory, if you’ve cloned [WinObjC from GitHub and built the project from source](https://github.com/Microsoft/WinObjC)), go to the [include\Platform\Universal Windows\UWP](https://github.com/Microsoft/WinObjC/tree/master/include/Platform/Universal Windows/UWP) directory and take a look at what you find. Each header file represents a different namespace within the [Windows Runtime APIs](https://msdn.microsoft.com/en-us/library/windows/apps/br211377.aspx). For our purposes, you will need APIs from [Windows.UI.Input](https://msdn.microsoft.com/en-us/library/windows/apps/windows.ui.input.aspx) since the radial controller is an input device and all it's classes are contained in that namespace.

To include this framework – and make sure it's only included when the code is being run on Windows – start by adding an **#ifdef** and the **#import** macros to the top of the view controller implementation file:

```Objective-C

  #ifdef WINOBJC
  #import <UWP/WindowsUIInput.h>
  #endif

```
### Add a New Menu Item to the Radial Controller Tool

First, you need to add a property to your ViewController that will reference the RadialController. In C++, the radial controller is represented by the [RadialController](https://msdn.microsoft.com/library/windows/apps/windows.ui.input.radialcontroller) class. However, as you build using Objective-C projections, you will notice that the standard naming scheme for these objects has been modified to match Objective-C conventions, where classes are prefixed with the letters that constitute their containing namespace:

- **Windows.Data.Xml.Dom.XmlDocument** becomes **WDXDXmlDocument**
- **Windows.UI.Notifications.ToastNotification** becomes **WUNToastNotification**
- **Windows.UI.Notifications.ToastNotificationManager** becomes **WUNToastNotificationManager**

*Coming soon*
