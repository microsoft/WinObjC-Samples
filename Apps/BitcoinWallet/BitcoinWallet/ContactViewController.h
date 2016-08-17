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

#ifndef ContactViewController_h
#define ContactViewController_h
#import <UIKit/UIKit.h>
#import "NetworkOps.h"

@interface ContactViewController : UIViewController

@property (strong,atomic) UINavigationBar *navBar;
@property (strong,atomic) UIImageView *qrImage;
@property (strong,atomic) UILabel *nameLabel;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *qrCode;

+ (id)initWithName:(NSString*)nameStr andAddress:(NSString*)qrStr;


@end

#endif /* ContactViewController_h */
