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
@property (strong, nonatomic) WUXCMMapControl *winMap;
@property (strong, nonatomic) UIView *winMapView;
#else 
@property (strong, nonatomic) MKMapView *mkMapView;
#endif

@end

@implementation ViewController

NSString * const kTrafficToggleString = @"Toggle Traffic";
NSString * const kOverlayToggleString = @"Toggle Overlay";

- (void)viewDidLoad {
    [super viewDidLoad];

	#ifdef WINOBJC
	[[UIApplication sharedApplication] setStatusBarHidden:YES]; // Deprecated in iOS
	#endif
    
    // set up traffic toggle button
    self.trafficToggle = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.trafficToggle setTitle:kTrafficToggleString
                   forState:UIControlStateNormal];
    [self.trafficToggle setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.trafficToggle addTarget:self
                           action:@selector(trafficTogglePressed)
                 forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.trafficToggle];
    
    // set up overlay toggle button
    self.overlayToggle = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.overlayToggle setTitle:kOverlayToggleString
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
    
    self.winMap = [WUXCMMapControl make];
    self.winMap.center = newYorkGeopoint;
    self.winMap.zoomLevel = 11;
    self.winMap.mapServiceToken = @"YOUR_API_KEY_HERE";
	self.winMap.maxHeight = 450;
	self.winMap.maxWidth = 300;
    CGRect mapFrame = CGRectMake(offset, 10, 300, 450);
    self.winMapView = [[UIView alloc] initWithFrame:mapFrame];
	self.winMapView.frame = mapFrame;
	self.winMapView.backgroundColor = [UIColor blackColor];
    [self.winMapView setNativeElement:self.winMap];
    [self.trafficToggle setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.winMapView];
    
    // iOS requires a MapKit MKMapview
    #else
    CLLocationDistance radiusMeters = 10000;
    CLLocationCoordinate2D newYorkGeopoint = CLLocationCoordinate2DMake(lat, lon);
    MKCoordinateRegion mapCenter = MKCoordinateRegionMakeWithDistance(newYorkGeopoint, radiusMeters, radiusMeters);
    self.mkMapView = [[MKMapView alloc] init];
    [self.mkMapView setRegion:mapCenter animated:YES];
    [self.mkMapView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.mkMapView];
    #endif

    
    UIView *mapView;
	#ifdef WINOBJC
	mapView = self.winMapView;
	#else
	mapView = self.mkMapView;
	#endif

	

    // set platform agnostic constraints
    NSDictionary *metrics = @{ @"pad": @80.0, @"margin": @40, @"mapHeight": @450};
    NSDictionary *views = @{ @"trafficToggle"   : self.trafficToggle,
                             @"overlayToggle"   : self.overlayToggle,
                             @"map"    : mapView
                             };
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[map(mapHeight)]-10-[overlayToggle][trafficToggle]"
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
																		
																	

}

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
    CGRect mapFrame = CGRectMake(offset, 10, 300, 450);
    self.winMapView.frame = mapFrame;
}
#endif

// Calculate the offset that will allow the 300 width map to sit in the center of the parent view
- (double)mapFrameOffset {
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    float screenwidth = screenBounds.size.width;
    float offset = (screenwidth-300)/2.0;
    return offset;
}

@end
