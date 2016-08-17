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

/*
 
 This class primarily houses a view with a QR scanner built from the
 AVCapture and related classes. These classes are not currently implemented
 in Islandwood and thus won't be called in the UWP solution
 
 */

#import "CreateContactViewController.h"

@implementation CreateContactViewController


- (void)viewDidLoad{
	
	#ifndef WINOBJC
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    CGFloat frameWidth = self.view.frame.size.width;
    CGFloat frameHeight = self.view.frame.size.height;
    
    
    AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];
    AVCaptureDevice *frontCam = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *err = nil;
    AVCaptureDeviceInput *camInput = [AVCaptureDeviceInput deviceInputWithDevice:frontCam error:&err];
    // start the capture session
    [captureSession addInput:camInput];
    
    dispatch_queue_t delegateQ = dispatch_queue_create("delQ",NULL);
    // attach metadata output to the session
    AVCaptureMetadataOutput *qrOut = [[AVCaptureMetadataOutput alloc] init];
    [captureSession addOutput:qrOut];
    [qrOut setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    [qrOut setMetadataObjectsDelegate:self queue:delegateQ];
    
    // add navigation bar
    _navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 20, frameWidth, 44)];
    _navBar.barTintColor = [UIColor colorWithRed:(0xc5/255.0f) green:(0xef/255.0f) blue:(0xf7/255.0f) alpha:1.0];
    
    
    // add navbar item with buttons
    UINavigationItem *staticItem = [[UINavigationItem alloc] initWithTitle:@"Scan Contact QR"];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:@selector(backButtonPressed)];
    staticItem.leftBarButtonItem = backButton;
    [_navBar pushNavigationItem:staticItem animated:NO];
    // add navigation bar
    [self.view addSubview:_navBar];
    
    // set up text block
    self.instructionLabel = [[UILabel alloc] init];
    self.instructionLabel.text = @"Bring QR Code in Frame";
    self.instructionLabel.adjustsFontSizeToFitWidth = TRUE;
    [self.instructionLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.instructionLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:self.instructionLabel];
    
    
    
    // add the imageview with callback
    _displayView = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
    [_displayView setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    
    
    
    // add the container uiview
    _previewContainer = [[UIView alloc] initWithFrame:CGRectMake(20, 100, frameWidth-40, 400)];
    _previewContainer.layer.borderWidth = 1;
    _previewContainer.layer.cornerRadius = 15;
    _previewContainer.clipsToBounds = TRUE;
    [_previewContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:_previewContainer];
    
    [_displayView setFrame:_previewContainer.frame];
    [self.view.layer addSublayer:_displayView];
    
    
    
    
    
    // set platform agnostic constraints
    NSDictionary *metrics = @{ @"pad": @80.0, @"margin": @40, @"paymentButtonHeight": @150};
    NSDictionary *views = @{ @"submit" : self.instructionLabel,
                             @"container" : self.previewContainer
                             };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-50-[container]-20-[submit]-80-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[submit]-50-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    // start the camera
    [captureSession startRunning];
    
    #endif
    
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
	#ifndef WINOBJC

    // check for empty array
    if(metadataObjects.count == 0){
        return;
    }
    AVMetadataMachineReadableCodeObject *qr = [metadataObjects objectAtIndex:0];
    if (qr.type == AVMetadataObjectTypeQRCode) {
        NSString *addrString = qr.stringValue;        
        UIAlertController *newAddress = [UIAlertController alertControllerWithTitle:@"Create Contact" message:@"Provide a name for this contact" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *submit = [UIAlertAction actionWithTitle:@"Create" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // get string pair
            NSString *newTag = newAddress.textFields.firstObject.text;
            NSString *finalString = [NSString stringWithFormat:@"%@,%@\n",newTag,addrString];
            ContactManager *contactManager = [ContactManager globalManager];
            [contactManager addKeyPair:finalString];
            
            // add kp to the manager
            [self.view setNeedsDisplay];
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate date]];
            
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            // just quietly exit
        }];
        
        [newAddress addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Adress Name";
        }];
        
        
        [newAddress addAction:cancel];
        [newAddress addAction:submit];
        
        
        [self presentViewController:newAddress animated:YES completion:^{
            // nothing
        }];
        
        
        
    }
    
	#endif

}

- (void)backButtonPressed {
    [self dismissViewControllerAnimated:TRUE completion:^{
        // nil
    }];
}



@end
