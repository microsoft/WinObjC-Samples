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

#import "AddressViewController.h"

@implementation AddressViewController

// Class level method to create an AddressVC with the right data
+ (id)initWithName:(NSString*)name andAddress:(NSString*)address {
    AddressViewController *toRet = [[AddressViewController alloc] init];
    toRet.addressName = name;
    toRet.address = address;
    return toRet;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // no status bar in UWP
	#ifdef WINOBJC
	[[UIApplication sharedApplication] setStatusBarHidden:YES]; // Deprecated in iOS
	#endif
    
    self.view.backgroundColor = [UIColor colorWithRed:(210.0/255.0f) green:(215.0/255.0f) blue:(211.0/255.0f) alpha:1.0];
    CGFloat frameWidth = self.view.frame.size.width;
    CGFloat frameHeight = self.view.frame.size.height;
    
    
    // add navigation bar
    _navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 20, frameWidth, 44)];
	// lack of status bar in UWP
    #ifdef WINOBJC
	_navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, frameWidth, 44)];
	#endif
    _navBar.barTintColor = [UIColor colorWithRed:(0xc5/255.0f) green:(0xef/255.0f) blue:(0xf7/255.0f) alpha:1.0];
    
    // add navbar item with buttons
    UINavigationItem *staticItem = [[UINavigationItem alloc] initWithTitle:_addressName];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:@selector(backButtonPressed)];
    staticItem.leftBarButtonItem = backButton;
    [_navBar pushNavigationItem:staticItem animated:NO];
    // add navigation bar
    [self.view addSubview:_navBar];
    
    // add the imageview with callback
    _qrImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300,300)];
    _qrImage.layer.borderWidth = 1;
    [_qrImage setBackgroundColor:[UIColor colorWithRed:(210.0/255.0f) green:(215.0/255.0f) blue:(211.0/255.0f) alpha:1.0]];
    [_qrImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_qrImage];
    
    // set platform agnostic constraints
    NSDictionary *metrics = @{ @"pad": @80.0, @"margin": @40, @"paymentButtonHeight": @150};
    NSDictionary *views = @{ @"imageview"   : self.qrImage,
                             };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[imageview]-225-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[imageview]-20-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    
    
    // asynchronously get the QR Image
    dispatch_queue_t balanceQueue = dispatch_queue_create("ImageQueue",NULL);
    dispatch_async(balanceQueue, ^{
        // get the image data, set image, update view
        NSData *imageData = [NetworkOps getAddressQRCode:_address];
        UIImage *toAdd = [[UIImage alloc] initWithData:imageData];
        [_qrImage setImage:toAdd];
        [_qrImage setNeedsDisplay];
        
    });
    
    
    
    
}


// dismiss the vc
- (void)backButtonPressed {
    [self dismissViewControllerAnimated:TRUE completion:^{
        // nil
    }];
}

@end
