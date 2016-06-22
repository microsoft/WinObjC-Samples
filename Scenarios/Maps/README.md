# Using Projections: Maps

The use of map controls allows application developers to provide users with pertinent geographical information in an easy to visualize form.

## The Sample

The project provided displays a map and provides two buttons which independently control aspects of the map's display. One allows a user to toggle the map between a road view and a satelite imagery view. The other button allows a user to turn a live traffic overlay on and off.

## Setting Up

1. First open the MapsSample directory in file explorer. Next, run the [VSImporter tool](https://github.com/Microsoft/WinObjC/wiki/Using-vsimporter) on the MapsSample project to generate a Visual Studio solution (.sln) file. 
2. Open the .sln file in Visual Studio
3. When in Visual Studio, press F5 or select Build->Build Solution in the menu bar

The project will then build and be ready to run.

## The code 

All the code that is mentioned below can be found in MapsSample/ViewController.m.


### Imports & Properties

```Objective-C
#ifdef WINOBJC
#import <UWP/WindowsUIXamlControlsMaps.h>
#import <UWP/WindowsDevicesGeolocation.h>
#endif
```

To include the frameworks needed for the sample, you will use `#ifdef` and two `#import` macros to the top of the ViewController implementation. The macros ensure this is done only when the code is being run on windows so as not to impact iOS functionality.

Each header represents a different namespace within the Windows Runtime APIs. We will be using the WinObjC extensions of [Windows.Devices.Geolocation](https://msdn.microsoft.com/en-us/library/windows/apps/windows.devices.geolocation.aspx) and [Windows.UI.Xaml.Controls.Maps](https://msdn.microsoft.com/en-us/library/windows/apps/windows.ui.xaml.controls.maps). The headers files themselves can be found on github [in this directory](https://github.com/Microsoft/WinObjC/tree/master/include/Platform/Universal%20Windows/UWP)

```Objective-C
#ifdef WINOBJC
@property (strong, nonatomic) WUXCMMapControl *winMap;
@property (strong, nonatomic) UIView *winMapView;
#else
```
    
For the most basic display of the XAML MapControl in Windows, these are the required elements. They are separate from the elements which are required for map display in iOS and are thus surrounded by `#ifdef` macros.

### Displaying the Map & Linking Elements
```Objective-C
#ifdef WINOBJC
[[UIApplication sharedApplication] setStatusBarHidden:YES]; // Deprecated in iOS
#endif
```

To ensure proper display on Windows 10 devices, use the same `#ifdef` pattern to change how the status bar is displayed. Under iOS, this setting is accessed in a different way due to API changes not currently encompassed in the WinObjC project; thus, under Windows, it is done in the above way.

```Objective-C
// Set up traffic toggle button
self.trafficToggle = [UIButton buttonWithType:UIButtonTypeSystem];
[self.trafficToggle setTitle:kTrafficToggleString
                    forState:UIControlStateNormal];
[self.trafficToggle setTranslatesAutoresizingMaskIntoConstraints:NO];
[self.trafficToggle addTarget:self
                       action:@selector(trafficTogglePressed)
             forControlEvents:UIControlEventTouchUpInside];
[self.view addSubview:self.trafficToggle];
```

At a high level on both platforms, UIButtons work in the same way in terms of initialization and layout. They are registered to the same handler functions (whose behavior is platform dependent).

```Objective-C
#ifdef WINOBJC
double offset = [self mapFrameOffset];
double altitude = 0.0;
WDGBasicGeoposition *NewYork = [[WDGBasicGeoposition alloc] init];
NewYork.latitude = lat;
NewYork.longitude = lon;
NewYork.altitude = altitude;
WDGGeopoint *newYorkGeopoint = [WDGGeopoint make:NewYork];
    
self.winMap = [WUXCMMapControl make];
self.winMap.center = newYorkGeopoint;
self.winMap.zoomLevel = 11;
self.winMap.mapServiceToken = @"YOUR_API_KEY_HERE";
CGRect mapFrame = CGRectMake(offset, 10, 400, 400);
self.winMapView = [[UIView alloc] initWithFrame:mapFrame];
[self.winMapView setNativeElement:self.winMap];
[self.trafficToggle setTranslatesAutoresizingMaskIntoConstraints:NO];
[self.view addSubview:self.winMapView];
#else
[...]
#endif
```

First, you'll use the Objective C implementations of [WDGBasicGeoposition](https://msdn.microsoft.com/en-us/library/windows/apps/windows.devices.geolocation.basicgeoposition.aspx) and [WDGeopoint](https://msdn.microsoft.com/en-us/library/windows/apps/windows.devices.geolocation.geopoint.aspx) to create a geographic reference which our [WUXCMapControl](https://msdn.microsoft.com/en-us/library/windows/apps/windows.ui.xaml.controls.maps.mapcontrol.aspx) can understand. Then, create and set the parameters of this control. Since it is not a UIView itself – and therefore can't be directly placed in the view hierarchy – it is wrapped inside a UIView as its native element and then that object is placed in the superview.

In changing from Windows Native API to WinObjC API, the classes change by abreviating the full path in the former's namespace as follows. The API is consistent with the Windows implementation, but the names have changed.
1. **Windows.Devices.Geolocation.BasicGeoposition** becomes **WDGBasicGeoposition**
2. **Windows.Devices.Geolocation.Geopoint** becomes **WDGGeopoint**
3. **Windows.UI.Xaml.Controls.Maps.MapControl** becomes **WUXCMMapControl**

The settings for the MapControl XAML control can be found above. One setting of note for this sample is that if the MapControl is not provided a valid Bing Maps API token, it will display an error message. One isn't given in the provided code, so the error message will appear. The steps to obtaining a valid token can be found [here under "Getting Started"](https://www.bingmapsportal.com/).

```Objective-C
// Set platform agnostic constraints
NSDictionary *metrics = @{ @"pad": @80.0, @"margin": @40, @"mapHeight": @350};
NSDictionary *views = @{ @"trafficToggle"   : self.trafficToggle,
                         @"overlayToggle"   : self.overlayToggle,
                         @"map"    : mapView
                         };
[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-50-[map(mapHeight)]-[overlayToggle][trafficToggle]"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[overlayToggle]-|"
                                                                  options:0
                                                                  metrics:metrics
                                                                    views:views]];
[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[trafficToggle]-|"
                                                                  options:0
                                                                  metrics:metrics
                                                                    views:views]];
    
[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[map]-|"
                                                                  options:0
                                                                  metrics:metrics
                                                                    views:views]];  
```                                                                      

NSLayoutConstraints are used the same way in WinObjC as on iOS.

### Setting up Button Handlers

```Objective-C
// Toggle the traffic on and off
- (void)trafficTogglePressed {
#ifdef WINOBJC
    self.winMap.trafficFlowVisible = !self.winMap.trafficFlowVisible;
#else
    self.mkMapView.showsTraffic = !self.mkMapView.showsTraffic;
#endif
}

// Toggle the overlay between aerial and road.
- (void)overlayTogglePressed {
#ifdef WINOBJC
    if (self.winMap.style == WUXCMMapStyleRoad) {
        self.winMap.style = WUXCMMapStyleAerialWithRoads;
    } else {
        self.winMap.style = WUXCMMapStyleRoad;
    }
#else
    if (self.mkMapView.mapType == MKMapTypeStandard) {
        self.mkMapView.mapType = MKMapTypeHybrid;
    } else {
        self.mkMapView.mapType = MKMapTypeStandard;
    }
#endif   
}
```

Button handlers point to the same function in both iOS and UWP. Aditionally, the action taken in each platform is exactly the same; however, we use `#ifdef` macros in the function definitions as platform-specific controls must be accessed and modified.

### Implementation Specific Decisions (What and Why)

```Objective-C
#ifdef WINOBJC
// Override to change the UIView containing the WinObjC MapControl to resize with the window
// UIView containing MapControl in UWP requires this, but the MKMapview in iOS does not.
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    double offset = [self mapFrameOffset];
    CGRect mapFrame = CGRectMake(offset, 10, 400, 600);
    self.winMapView.frame = mapFrame;
}
#endif

// Calculate the offset that will allow the 400 width map to sit in the center of the parent view
- (double)mapFrameOffset {
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    float screenwidth = screenBounds.size.width;
    float offset = (screenwidth-400)/2.0;
    return offset;
}
```
    
In Windows, the XAML MapControl is wrapped in a static UIView which has a defined position and size on the screen based on the CGRect frame that backs it. 

To ensure that it will stay centered when the screen is resized, when the superview (view size) changes we provide an overridden UIView method which will calculate the proper position of the MapControl containing UIView and update the frame. This was a design choice and not indicative of a canonical design pattern for UWP, and other choices, including putting all elements in a vertical stack view, are equally valid.

## Collected Reading and Quick Reference
1. [How to use VSImporter to convert XCode projects to Visual Studio Projects](https://github.com/Microsoft/WinObjC/wiki/Using-vsimporter)
2. The Windows API references for elements used in this example can be found here
    1. [Windows.Devices.Geolocation](https://msdn.microsoft.com/en-us/library/windows/apps/windows.devices.geolocation.aspx)
    2. [Windows.UI.Xaml.Controls.Maps](https://msdn.microsoft.com/en-us/library/windows/apps/windows.ui.xaml.controls.maps)
3. [Bing Maps API token how-to (to get rid of a "unspecified mapServiceToken" error)](https://www.bingmapsportal.com/)
