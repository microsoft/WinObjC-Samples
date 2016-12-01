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
### Adding a New Menu Item to the Radial Controller Tool

To interact with the radial controller you first need to add a property to the view controller of your app that will allow you to access it. In C++ wheel input devices are represented by the [RadialController](https://msdn.microsoft.com/library/windows/apps/windows.ui.input.radialcontroller) class. However, as you build using Objective-C projections, you will notice that the standard naming scheme for these objects has been modified to match Objective-C conventions, where classes are prefixed with the letters that constitute their containing namespace:

- **Windows.UI.Input.RadialController** becomes **WUIRadialController**

As a result, add a **WUIRadialController** property to the **@interface** section of the view controller implementation file:

```Objective-C
  @interface ViewController()

  @property UILabel *demoTitle;
  @property UILabel *demoInfo;
  @property UISlider *slider;
  @property UILabel *sliderLabel;
  @property UISwitch *switchControl;

  #ifdef WINOBJC
  @property WUIRadialController* radialController;
  #endif

  @end
 ```
Next, you need to get a reference to the **WUIRadialController** object with the [CreateForCurrentView](https://msdn.microsoft.com/en-us/library/windows/apps/windows.ui.input.radialcontroller.createforcurrentview) as explained in the [RadialController](https://msdn.microsoft.com/library/windows/apps/windows.ui.input.radialcontroller) class documentation. Looking at the  [WindowsUIInput.h](https://github.com/Microsoft/WinObjC/tree/master/include/Platform/Universal Windows/UWP/WindowsUIInput.h) header you'll find the equivalent Ojective-C projection under the **WUIRadialController** class interface:

```Objective-C
  @interface WUIRadialController : RTObject
  [...]
  + (WUIRadialController*)createForCurrentView;
```

Call this method at the end of the **viewDidLoad** method of the view controller file to instanciate the **WUIRadialController** property:

```Objective-C
  - (void)viewDidLoad {
    [...]
  
  #ifdef WINOBJC    
    // Create a reference to the radial controller
    self.radialController = [WUIRadialController createForCurrentView];
  #endif
  }
```

Now you need to get a reference to the radial controller menu and its items. This is done via the [Menu](https://msdn.microsoft.com/en-us/library/windows/apps/windows.ui.input.radialcontroller.menu) property of the [RadialController](https://msdn.microsoft.com/library/windows/apps/windows.ui.input.radialcontroller) class that returns a [RadialControllerMenu](https://msdn.microsoft.com/en-us/library/windows/apps/windows.ui.input.radialcontrollermenu) object. Looking back at the  [WindowsUIInput.h](https://github.com/Microsoft/WinObjC/tree/master/include/Platform/Universal Windows/UWP/WindowsUIInput.h) header you'll find the equivalent Ojective-C property under the **WUIRadialController** class interface that returns a **WUIRadialControllerMenu** object:

```Objective-C
  @interface WUIRadialController : RTObject
  [...]
  @property (readonly) WUIRadialControllerMenu* menu;
```

Call this property to get a reference to the radial controller menu:

```Objective-C
  - (void)viewDidLoad {
    [...]
  
  #ifdef WINOBJC    
    // Create a reference to the radial controller
    self.radialController = [WUIRadialController createForCurrentView];
    
    // Get the radial controller menu
    WUIRadialControllerMenu* menu = self.radialController.menu; 
  #endif
  }
```

The menu items are accessile via the [Item](https://msdn.microsoft.com/en-us/library/windows/apps/windows.ui.input.radialcontrollermenu.items) property of the [RadialControllerMenu](https://msdn.microsoft.com/en-us/library/windows/apps/windows.ui.input.radialcontrollermenu) class. As before, the interface of the **WUIRadialControllerMenu** class in the [WindowsUIInput.h](https://github.com/Microsoft/WinObjC/tree/master/include/Platform/Universal Windows/UWP/WindowsUIInput.h) header gives you the equivalent Objective-C property:

```Objective-C
  @interface WUIRadialControllerMenu : RTObject
  [...]
  @property (readonly) NSMutableArray* /* WUIRadialControllerMenuItem* */ items;
```

Call this property to get a reference to the menu items:

```Objective-C
  - (void)viewDidLoad {
    [...]
    
    // Get the radial controller menu
    WUIRadialControllerMenu* menu = self.radialController.menu;
    
    // Get the menu items
    NSMutableArray* menuItems = menu.items;
  #endif
  }
```

Next, you need to create a new [RadialControllerMenuItem](https://msdn.microsoft.com/library/windows/apps/windows.ui.input.radialcontrollermenuitem) to add to the menu with the projection of the [CreateFromKnownIcon](https://msdn.microsoft.com/en-us/library/windows/apps/windows.ui.input.radialcontrollermenuitem.createfromknownicon) class method:

```Objective-C
  @interface WUIRadialControllerMenuItem : RTObject
  + (WUIRadialControllerMenuItem*)createFromIcon:(NSString *)displayText icon:(WSSRandomAccessStreamReference*)icon;
```
Call this method to create the new menu item:

```Objective-C
  - (void)viewDidLoad {
    [...]
    
    // Get the menu items
    NSMutableArray* menuItems = menu.items;
    
    // Create a new menu item
    WUIRadialControllerMenuItem* newMenuItem = [WUIRadialControllerMenuItem createFromKnownIcon:@"Custom Tool" value:WUIRadialControllerMenuKnownIconRuler];
  #endif
  }
```

Note that we re-used an existing icon for our tool from the [RadialControllerMenuKnownIcon](https://msdn.microsoft.com/en-us/library/windows/apps/windows.ui.input.radialcontrollermenuknownicon) enumeration, but you can create your own and use the [CreateFromIcon](https://msdn.microsoft.com/en-us/library/windows/apps/windows.ui.input.radialcontrollermenuitem.createfromicon) method instead.

Finally, add your new menu item to the menu items array:

```Objective-C
  - (void)viewDidLoad {
    [...]
    
    // Create a new menu item
    WUIRadialControllerMenuItem* newMenuItem = [WUIRadialControllerMenuItem createFromKnownIcon:@"Custom Tool" value:WUIRadialControllerMenuKnownIconRuler];
  #endif
  
    // Add a new menu item
    [menuItems addObject:newMenuItem];
  }
```

That's it! Now build and run your application and press and hold the Surface Dial to see the new menu item appear.

### Adding a Handler for Click Input

In this example, you will add a handler for click input that will toggle the application switch control if the radial controller is clicked when the new tool you added to the menu is selected. Taking a look at the at the  [WindowsUIInput.h](https://github.com/Microsoft/WinObjC/tree/master/include/Platform/Universal Windows/UWP/WindowsUIInput.h) header you'll see you need the**addButtonClickedEvent** method:

```Objective-C
   @interface WUIRadialController : RTObject
   [...]
   - (EventRegistrationToken)addButtonClickedEvent:(void(^)(WUIRadialController*, WUIRadialControllerButtonClickedEventArgs*))del;
```
Since the callback relies on Objective-C blocks, you need to mark the self reference with the **__block** keyword before using it to access the switch to avoid creating a retain cycle. Add the following code at the end of the **viewDidLoad** method to do this:

```Objective-C
  - (void)viewDidLoad {
    [...]
  
    // Add a new menu item
    [menuItems addObject:newMenuItem];
    
    __block ViewController* blockSelf = self; // Ensures self will not be retained
  }
```

Now you can safely toggle the switch in the radial controller click callback:

```Objective-C
  - (void)viewDidLoad {
    [...]
      
    __block ViewController* blockSelf = self; // Ensures self will not be retained
    
    // Add a handler for click input from the radial controller
    [self.radialController addButtonClickedEvent:^(WUIRadialController* controller, WUIRadialControllerButtonClickedEventArgs* args)
     {
         [blockSelf.switchControl setOn:!(blockSelf.switchControl.on) animated:YES];
     }];
  }
```

You can now build and run your application, select the new menu item and click on the radial controller to see the switch toggle.

### Adding a Handler for Rotation Input

*Coming soon*
