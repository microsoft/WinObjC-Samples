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

#ifndef TransactionListViewController_h
#define TransactionListViewController_h
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "APINetworkOps.h"
#import "TransactionManager.h"

@interface TransactionListViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UINavigationBar* navBar;
@property (atomic,strong) UITableView *mainTable;
@property (atomic,strong) NSArray *tableData;
@property (atomic,strong) NSSet *pairDict;

@property (atomic,strong) NSMutableArray *toAddr;
@property (atomic,strong) NSMutableArray *fromAddr;
@property (atomic,strong) NSMutableArray *amount;

@end

#endif /* TransactionListViewController_h */
