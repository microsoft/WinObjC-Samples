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

#ifndef AddressListView_h
#define AddressListView_h

#include <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#include "AddressManager.h"
#include "AddressViewController.h"
#include "CryptoOps.h"
#import "NetworkOps.h"
#import "APINetworkOps.h"

// import ui/notifcations for the toast if we are on a windows system
#ifdef WINOBJC
#import <UWP/WindowsUIXamlControls.h>
#import <UWP/WindowsDataXmlDom.h>
#endif



@interface AddressListView : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong,nonatomic) UINavigationBar* navBar;
@property (atomic,strong) UITableView *mainTable;
@property (atomic,strong) NSArray *tableData;
@property (atomic,strong) NSDictionary *pairDict;

@end

#endif /* AddressListView_h */
