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
// WinObjC Sample - Radial Control ////////////
// github.com/Microsoft/WinObjC ///////////////
///////////////////////////////////////////////

#import "ViewController.h"

#ifdef WINOBJC
#import <UWP/WindowsUIInput.h>
#endif

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

@implementation ViewController

// WinObjC example app constants
static NSString * const kTitleString = @"Radial Controller";
static NSString * const kInfoString = @"This WinObjC sample project demonstrates how to use a radial controller";

- (void)viewDidLoad {
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
    
    //Set up the demo slider
    self.slider = [UISlider new];
    [self.slider setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.slider addTarget:self
					action:@selector(sliderDidChange)
     forControlEvents:UIControlEventValueChanged];
    
    // Set up the demo slider label
    self.sliderLabel = [UILabel new];
    self.sliderLabel.text = [NSString stringWithFormat:@"Slider value: %f", self.slider.value];
    self.sliderLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    self.sliderLabel.textAlignment = NSTextAlignmentCenter;
    self.sliderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    //Set up the demo switch
    self.switchControl = [UISwitch new];
    [self.switchControl setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:self.demoTitle];
    [self.view addSubview:self.demoInfo];
    [self.view addSubview:self.slider];
    [self.view addSubview:self.sliderLabel];
    [self.view addSubview:self.switchControl];
    
    // Layout constraints
    NSDictionary *metrics = @{@"pad":@80.0, @"margin":@40, @"demoInfoHeight":@100, @"sliderHeight":@40, @"switchHeight":@30};
    NSDictionary *views = @{@"title":self.demoTitle,
                            @"info":self.demoInfo,
                            @"slider":self.slider,
                            @"sliderLabel":self.sliderLabel,
                            @"switch":self.switchControl};
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[title]-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[info]-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[slider]-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[sliderLabel]-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[switch]-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[title]-[info(demoInfoHeight)]-margin-[slider(sliderHeight)]-[sliderLabel]-margin-[switch(switchHeight)]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
#ifdef WINOBJC
    [[UIApplication sharedApplication] setStatusBarHidden:YES]; // Deprecated in iOS
    
    // Create a reference to the radial controller
    self.radialController = [WUIRadialController createForCurrentView];

    // Get the radial controller menu
    WUIRadialControllerMenu* menu = self.radialController.menu;

    // Get the menu items
    NSMutableArray* menuItems = menu.items;

    // Create a new menu item
    WUIRadialControllerMenuItem* newMenuItem = [WUIRadialControllerMenuItem createFromKnownIcon:@"Custom Tool" value:WUIRadialControllerMenuKnownIconRuler];

    // Add a new menu item
    [menuItems addObject:newMenuItem];
	
    __block ViewController* blockSelf = self; // Ensures self will not be retained
    
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)sliderDidChange{
    self.sliderLabel.text = [NSString stringWithFormat:@"Slider value: %f", self.slider.value];
}

@end

