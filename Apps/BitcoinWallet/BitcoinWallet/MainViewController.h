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

#ifndef MainViewController_h
#define MainViewController_h

#import <UIKit/UIKit.h>
#import "CryptoOps.h"
#import "NetworkOps.h"
#import "AddressManager.h"
#import "AddressViewController.h"
#import "ContactManager.h"
#import "CreateContactViewController.h"
#import "ContactViewController.h"
#import <Foundation/Foundation.h>

#ifdef WINOBJC
#import <UWP/WindowsUIXamlControls.h>
#import <UWP/WindowsMediaCapture.h>
#import <UWP/WindowsDevicesEnumeration.h>
#endif

@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (atomic,strong) UITableView *mainTable;
@property (atomic,strong) NSArray *tableData;
@property (strong,atomic) UINavigationBar *navBar;

@end

#endif /* MainViewController_h */
