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

*Coming soon*
