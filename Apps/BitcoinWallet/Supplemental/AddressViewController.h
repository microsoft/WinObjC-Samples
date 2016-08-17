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

#ifndef AddressViewController_h
#define AddressViewController_h
#import "NetworkOps.h"
#import "Bolts.h"
#import <UIKit/UIKit.h>

@interface AddressViewController : UIViewController

@property (strong,atomic) UINavigationBar *navBar;
@property (strong,atomic) UIImageView *qrImage;
@property (strong,atomic) UILabel *nameLabel;
@property (strong,nonatomic) NSString *addressName;
@property (strong,nonatomic) NSString *address;

+ (id)initWithName:(NSString*)name andAddress:(NSString*)address;


@end

#endif /* AddressViewController_h */