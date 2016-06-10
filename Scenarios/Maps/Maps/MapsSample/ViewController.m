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
#import "ViewController.h"

#ifdef WINOBJC
#import <UWP/WindowsUIXamlControlsMaps.h>
#import <UWP/WindowsDevicesGeolocation.h>
#endif

@interface ViewController ()
@property (strong, nonatomic) UIButton *trafficToggle;
@property (strong, nonatomic) UIButton *overlayToggle;
#ifdef WINOBJC
@property (strong, nonatomic) WUXCMMapControl *map;
@property (strong, nonatomic) UIView *mapView;
#else 
@property (strong, nonatomic) MKMapView *mapView;
#endif

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // set up traffic toggle button
    self.trafficToggle = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.trafficToggle setTitle:@"Toggle Traffic"
                   forState:UIControlStateNormal];
    [self.trafficToggle setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.trafficToggle addTarget:self
                           action:@selector(trafficTogglePressed)
                 forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.trafficToggle];
    
    // set up overlay toggle button
    self.overlayToggle = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.overlayToggle setTitle:@"Toggle Overlay"
                        forState:UIControlStateNormal];
    [self.overlayToggle setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.overlayToggle addTarget:self
                           action:@selector(overlayTogglePressed)
                 forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.overlayToggle];
    
    // set up the mapview with New York map center
    
    double lat = 40.722;
    double lon = -74.001;
    
    // UWP requires a MapControl set inside an UIKit UIView
    #ifdef WINOBJC
    double offset = [self mapFrameOffset];
    double altitude = 0.0;
    WDGBasicGeoposition *NewYork = [[WDGBasicGeoposition alloc] init];
    NewYork.latitude = lat;
    NewYork.longitude = lon;
    NewYork.altitude = altitude;
    WDGGeopoint *newYorkGeopoint = [WDGGeopoint make:NewYork];
    
    self.map = [WUXCMMapControl make];
    self.map.center = newYorkGeopoint;
    self.map.zoomLevel = 11;
    self.map.mapServiceToken = @"YOUR_API_KEY_HERE";
    CGRect mapFrame = CGRectMake(offset, 10, 400, 600);
    self.mapView = [[UIView alloc] initWithFrame:mapFrame];
    [self.mapView setNativeElement:self.map];
    [self.trafficToggle setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.mapView];
    
    // iOS requires a MapKit MKMapview
    #else
    CLLocationDistance radiusMeters = 10000;
    CLLocationCoordinate2D newYorkGeopoint = CLLocationCoordinate2DMake(lat, lon);
    MKCoordinateRegion mapCenter = MKCoordinateRegionMakeWithDistance(newYorkGeopoint, radiusMeters, radiusMeters);
    self.mapView = [[MKMapView alloc] init];
    [self.mapView setRegion:mapCenter animated:YES];
    [self.mapView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.mapView];
    #endif

    
    // set platform agnostic constraints
    NSDictionary *metrics = @{ @"pad": @80.0, @"margin": @40, @"mapHeight": @350};
    NSDictionary *views = @{ @"trafficToggle"   : self.trafficToggle,
                             @"overlayToggle"   : self.overlayToggle,
                             @"map"    : self.mapView
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

    // in iOS, we can use constraints to layout the MKMapview, doesn't work with UIView in UWP
    #ifndef WINOBJC
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[map]-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    #endif
    

    
    
    
    
    
}
// Toggle the traffic on and off
- (void)trafficTogglePressed {
    #ifdef WINOBJC
    self.map.trafficFlowVisible = !self.map.trafficFlowVisible;
    #else
    self.mapView.showsTraffic = !self.mapView.showsTraffic;
    #endif
}

// Toggle the overlay between aerial and road.
- (void)overlayTogglePressed {
    #ifdef WINOBJC
    if (self.map.style == WUXCMMapStyleRoad) {
        self.map.style = WUXCMMapStyleAerialWithRoads;
    } else {
        self.map.style = WUXCMMapStyleRoad;
    }
    #else
    if (self.mapView.mapType == MKMapTypeStandard) {
        self.mapView.mapType = MKMapTypeHybrid;
    } else {
        self.mapView.mapType = MKMapTypeStandard;
    }
    #endif
    
    
}

// Dispose of any resources that can be recreated.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#ifdef WINOBJC
// override to change the UIView containing the WinObjC MapControl to resize with the window
// UIView containing MapControl in UWP requires this, but the MKMapview in iOS does not.
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    double offset = [self mapFrameOffset];
    CGRect mapFrame = CGRectMake(offset, 10, 400, 600);
    self.mapView.frame = mapFrame;
}
#endif

// Calculate the offset that will allow the 400 width map to sit in the center of the parent view
- (double)mapFrameOffset {
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    float screenwidth = screenBounds.size.width;
    float offset = (screenwidth-400)/2.0;
    return offset;
}

@end

#ifdef WINOBJC
// Tell the WinObjC runtime how large to render the application
// (Found at github.com/Microsoft/WinObjC/samples/HelloUI)
@implementation UIApplication (UIApplicationInitialStartupMode)
+ (void)setStartupDisplayMode:(WOCDisplayMode*)mode {
    mode.autoMagnification = TRUE;
    mode.sizeUIWindowToFit = TRUE;
    mode.fixedWidth = 0;
    mode.fixedHeight = 0;
    mode.magnification = 1.0;
}
@end
#endif
