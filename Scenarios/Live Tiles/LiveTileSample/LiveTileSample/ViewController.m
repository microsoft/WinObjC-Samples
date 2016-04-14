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
// WinObjC Sample - Live Tiles ///////
// github.com/Microsoft/WinObjC //////
//////////////////////////////////////

#import "ViewController.h"

#ifdef WINOBJC
#import <UWP/WindowsUINotifications.h>
#import <UWP/WindowsDataXmlDom.h>
#endif

@interface ViewController ()

@property UILabel *demoTitle;
@property UILabel *demoInfo;
@property UILabel *label;
@property UIButton *button;

@end

@implementation ViewController

// WinObjC example app constants
static NSString * const kTitleString = @"Live Tiles";
static NSString * const kInfoString = @"This WinObjC sample project demonstrates how to create and update Live Tiles using Objective-C. The button below will update the label with a timestamp. When running on Windows 10, it will also update the app's Live Tile with the same string.";
static NSString * const kButtonText = @"Push me";
static NSString * const kLabelInitialText = @"Press the button to generate a Live Tile.";

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
    
    // Set up the button
    self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.button setTitle:kButtonText
                 forState:UIControlStateNormal];
    [self.button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.button addTarget:self
                    action:@selector(buttonPressed)
          forControlEvents:UIControlEventTouchUpInside];
    
    // Set up the label
    self.label = [UILabel new];
    self.label.text = kLabelInitialText;
    self.label.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    self.label.numberOfLines = 0;
    self.label.lineBreakMode = NSLineBreakByWordWrapping;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.demoTitle];
    [self.view addSubview:self.demoInfo];
    [self.view addSubview:self.button];
    [self.view addSubview:self.label];
    
    // Layout constraints
    NSDictionary *metrics = @{ @"pad": @80.0, @"margin": @40, @"demoInfoHeight": @120 };
    NSDictionary *views = @{ @"title"   : self.demoTitle,
                             @"info"    : self.demoInfo,
                             @"button"  : self.button,
                             @"label"   : self.label
                            };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[title]-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[info]-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[button]-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[label]-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[title]-[info(demoInfoHeight)]-margin-[button]-[label]"
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

- (void) buttonPressed
{
    // Update label
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"MM-dd HH:mm"];

    NSString *timeDateString = [formatter stringFromDate:[NSDate date]];
    NSString *labelString = [NSString stringWithFormat:@"Button pressed at: %@", timeDateString];
    self.label.text = labelString;
    
    // Create Live Tile if on WinObjC
#ifdef WINOBJC
    // Create an XML payload that describes the tile - https://msdn.microsoft.com/windows/uwp/controls-and-patterns/tiles-and-notifications-creating-tiles
    WDXDXmlDocument* tileXml = [WDXDXmlDocument make];

    // Build the XML structure
    NSString *xmlDocument = @"<tile><visual>\n";

    // Small Tile
    xmlDocument = [xmlDocument stringByAppendingString:@"<binding template=\"TileSmall\"><group><subgroup><text>Button!</text></subgroup></group></binding>\n"];

    // Medium Tile
    xmlDocument = [xmlDocument stringByAppendingString:[NSString stringWithFormat:@"<binding template=\"TileMedium\"><group><subgroup><text hint-style=\"subtitle\">Pressed at:</text><text hint-style=\"captionSubtle\">%@</text></subgroup></group></binding>\n", timeDateString]];

    // Large Tile
    xmlDocument = [xmlDocument stringByAppendingString:[NSString stringWithFormat:@"<binding template=\"TileWide\"><group><subgroup><text hint-style=\"subtitle\">Button pressed at:</text><text hint-style=\"captionSubtle\">%@</text></subgroup></group></binding>\n", timeDateString]];

    // Cleanup on XML
    xmlDocument = [xmlDocument stringByAppendingString:@"</visual></tile>\n"];

    [tileXml loadXml:xmlDocument];

    WUNTileNotification *notification = [WUNTileNotification makeTileNotification: tileXml];

    // Notify the user via live tile
    WUNTileUpdater* tileUpdater = [WUNTileUpdateManager createTileUpdaterForApplication];
    [tileUpdater update:notification];
#endif
    
}

@end
