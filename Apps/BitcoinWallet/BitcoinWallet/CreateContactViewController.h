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

#ifndef CreateContactViewController_h
#define CreateContactViewController_h
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ContactManager.h"

@import AVFoundation;

@interface CreateContactViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>

@property (strong,nonatomic) AVCaptureVideoPreviewLayer *displayView;
@property (strong,atomic) UINavigationBar *navBar;
@property (strong,atomic) UILabel *instructionLabel;
@property (strong,atomic) UIView *previewContainer;

@end


#endif /* CreateContactViewController_h */
