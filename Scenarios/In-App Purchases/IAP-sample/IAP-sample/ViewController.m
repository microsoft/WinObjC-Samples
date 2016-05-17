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

/////////////////////////////////////////
// WinObjC Sample - In-App Purchases   //
// github.com/Microsoft/WinObjC-samples//
/////////////////////////////////////////

#import "ViewController.h"

#ifdef WINOBJC
#import <UWP/WindowsApplicationModelStore.h>
#endif

@interface ViewController ()

@property UILabel *demoTitle;
@property UILabel *demoInfo;
@property UILabel *label;
@property UIButton *button;

@end

@implementation ViewController

// WinObjC example app constants
#ifdef WINOBJC
static NSString * const removableFont = @"Comic Sans MS";
#else
static NSString * const removableFont = @"Chalkduster";
#endif

static NSString * const kTitleString = @"In-App Purchases";
static NSString * const kButtonText = @"Change font to System font";
static NSString * const kLabelInitialText = @"Simulated - no purchase will be made.";

BOOL systemFont = NO;

#ifdef WINOBJC
WSProductListing* product1;
#endif


- (void)formatFonts {
    // Update fonts
    if (systemFont) {
        self.label.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
        self.demoInfo.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
        self.demoTitle.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
        self.button.titleLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    }
    else {
         self.label.font = [UIFont fontWithName:removableFont size:10];
         self.demoInfo.font = [UIFont fontWithName:removableFont size:14];
         self.demoTitle.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
         self.button.titleLabel.font = [UIFont fontWithName:removableFont size:12];
    }

}

- (void)viewDidLoad
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
    NSString * infoString = [NSString stringWithFormat:@"This WinObjC sample project demonstrates how to enable In-App Purchases for Windows 10 using Objective-C. The button below simulates the purchase of a non-consumable product that changes the UI to a font other than %@.", removableFont];

    self.demoInfo.text = infoString;
    self.demoInfo.font = [UIFont fontWithName:removableFont size:14];
    self.demoInfo.numberOfLines = 0;
    self.demoInfo.lineBreakMode = NSLineBreakByWordWrapping;
    self.demoInfo.textAlignment = NSTextAlignmentCenter;
    self.demoInfo.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Set up the button
    self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.button.titleLabel.font = [UIFont fontWithName:removableFont size:12];
    [self.button setTitle:kButtonText
                 forState:UIControlStateNormal];
    [self.button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.button addTarget:self
                    action:@selector(storeButtonPressed)
          forControlEvents:UIControlEventTouchDown];
    
    // Set up the label
    self.label = [UILabel new];
    self.label.text = kLabelInitialText;
    self.label.font = [UIFont fontWithName:removableFont size:10];
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

    [self formatFonts];

#ifdef WINOBJC

    // Mock store
    WFUri* mockStoreURI = [WFUri makeUri:@"ms-appx:///in-app-purchase.xml"];

    // Open XML containing the product information in the store [mock or otherwise].
    [WSStorageFile getFileFromApplicationUriAsync:mockStoreURI 
        success:^void(WSStorageFile* result) {
        
            [WSCurrentAppSimulator reloadSimulatorAsync:result].completed = 
                ^void(RTObject<WFIAsyncAction>* asyncInfo,WFAsyncStatus asyncStatus) {
                
                [WSCurrentAppSimulator loadListingInformationAsyncWithSuccess:^void(WSListingInformation* info) {
                
                    product1 = [info.productListings objectForKey:@"product0"];
                    NSString* button1Title = [NSString stringWithFormat:@"Buy %@ (%@) now", product1.name, product1.formattedPrice];
                    [self.button setTitle:button1Title
                                 forState:UIControlStateNormal];
                    [self.button addTarget:self
                                    action:@selector(storeButtonPressed)
                          forControlEvents:UIControlEventTouchDown];
            }
                failure:^(NSError* err) {
                    NSLog(@"Hit error %@ when attempting to load listing information!", err);
                }];
            };
       }

       failure:^(NSError* err) {
            NSLog(@"Hit error %@ when attempting to load mock store XML data!", err);
       }
     ];

#endif

#ifdef WINOBJC
    [[UIApplication sharedApplication] setStatusBarHidden:YES]; // Deprecated in iOS
#endif
}

- (BOOL) prefersStatusBarHidden
{
    return YES;
}

- (void)storeButtonPressed
{
    NSLog(@"Pushing store button.");
#ifdef WINOBJC
    [self buyProduct:product1.productId name:product1.name];
#endif
    [self formatFonts];
}

#ifdef WINOBJC
-(void)buyProduct:(NSString*)productId name:(NSString*)name {
    WSLicenseInformation* licenseInformation = [WSCurrentAppSimulator licenseInformation];
    NSDictionary* productLicenses = [licenseInformation productLicenses];
    WSProductLicense* license = productLicenses[productId];

    if (!license.isActive) {
        self.label.text = [NSString stringWithFormat:@"Buying %@", name];
        [WSCurrentAppSimulator requestProductPurchaseAsync:productId
                                            includeReceipt:TRUE
                                            success:^void(NSString* result) {
                                                // validate the purchase
                                                NSDictionary* productLicenses = [[WSCurrentAppSimulator licenseInformation] productLicenses];
                                                WSProductLicense* license = productLicenses[productId];
                                                if (license.isActive) {
                                                    systemFont = YES;
                                                    self.label.text = [NSString stringWithFormat:@"You bought %@", name];
                                                    NSLog(@"You purchased %@.", name);
                                                    [self formatFonts];
                                                };
                                            }
                                            failure:^(NSError* err) {
                                                self.label.text = [NSString stringWithFormat:@"You did not buy %@", name];
                                                NSLog(@"You did not purchase %@.\nError:%@", name, err);
                                                [self formatFonts];
                                            }];
    } else {
        self.label.text = [NSString stringWithFormat:@"You already bought %@", name];
        NSLog(@"%@ already purchased.", name);
        [self formatFonts];
}                                           
}
#endif

@end
