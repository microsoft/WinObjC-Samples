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

#ifndef SendTransactionViewController_h
#define SendTransactionViewController_h
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ContactManager.h"
#import "AddressManager.h"
#import "TransactionManager.h"
#import "APINetworkOps.h"
#import "CryptoOps.h"

// import ui/notifcations for the toast if we are on a windows system
#ifdef WINOBJC
#import <UWP/WindowsUINotifications.h>
#import <UWP/WindowsDataXmlDom.h>
#import <UWP/WindowsUIXamlControls.h>
#endif

@interface SendTransactionViewController : UIViewController <UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong,atomic) UINavigationBar *navBar;
@property (strong,atomic) UITextField *amountField;
@property (strong,atomic) UILabel *btcLabel;
@property (strong,atomic) UILabel *fromLabel;
@property (strong,atomic) UIPickerView *contactPicker;

@property (strong,atomic) UIButton *makePaymentButton;
@property (strong,atomic) NSArray *pickerData;
@property (strong,atomic) NSDictionary *contactData;
@property (strong,atomic) UILabel *toLabel;

@property (strong,atomic) UIPickerView *addressPicker;
@property (strong,atomic) NSArray *pickerDataAddresses;
@property (strong,atomic) NSDictionary *addressData;







@end

#endif /* SendTransactionViewController_h */
