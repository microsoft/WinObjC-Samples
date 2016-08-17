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

#ifndef MenuViewController_h
#define MenuViewController_h
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AddressManager.h"
#import "NetworkOps.h"
#import "TransactionManager.h"
#import "AddressListView.h"
#import "APINetworkOps.h"
#import "SendTransactionViewController.h"
#import "TransactionListViewController.h"

@interface MenuViewController : UIViewController

@property (nonatomic,strong) UIButton *makePaymentButton;
@property (nonatomic,strong) UIButton *myAddressesButton;
@property (nonatomic,strong) UIButton *myContactsButton;
@property (nonatomic,strong) UIButton *myTransactionsButton;
@property (nonatomic,strong) UIButton *refreshButton;




@end

#endif /* MenuViewController_h */
