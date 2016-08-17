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

#import "TransactionListViewController.h"

@implementation TransactionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

	#ifdef WINOBJC
	[[UIApplication sharedApplication] setStatusBarHidden:YES]; // Deprecated in iOS
	#endif
    
    CGFloat frameWidth = self.view.frame.size.width;
    CGFloat frameHeight = self.view.frame.size.height;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // add navigation bar
    _navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 20, frameWidth, 44)];
    _navBar.barTintColor = [UIColor colorWithRed:(0xc5/255.0f) green:(0xef/255.0f) blue:(0xf7/255.0f) alpha:1.0];
    
    // add navbar item with buttons
    UINavigationItem *navBar = [[UINavigationItem alloc] initWithTitle:@"Recent Transactions"];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:@selector(backButtonPressed)];
    navBar.leftBarButtonItem = backButton;
    [_navBar pushNavigationItem:navBar animated:NO];
    // add navigation bar
    [self.view addSubview:_navBar];
    
    // dummy data
    TransactionManager *transactionMan = [TransactionManager globalManager];
    //[transactionMan createKeyPairsWithDummyData];
    _pairDict = [[transactionMan getTransactionSet] retain];
    _tableData = [[NSArray arrayWithArray:[_pairDict allObjects]] retain];

    
    // create tableview
    CGRect mainTableFrame = CGRectMake(0, 64, frameWidth, frameHeight-64);
    _mainTable = [[UITableView alloc]initWithFrame:mainTableFrame style:UITableViewStylePlain];
    [_mainTable setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_mainTable setDelegate:self];
    [_mainTable setDataSource:self];
    _mainTable.backgroundColor = [UIColor colorWithRed:(210.0/255.0f) green:(215.0/255.0f) blue:(211.0/255.0f) alpha:1.0];
    [self.view addSubview:_mainTable];
    
    
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tableData count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *contactCellIdent = @"contactCell";
    UITableViewCell *contactCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contactCellIdent];
    
    
    contactCell.textLabel.numberOfLines = 0;
    
    NSString *txHash = [_tableData objectAtIndex:indexPath.row];
    
    
    TransactionManager *tm = [TransactionManager globalManager];
    NSDictionary *contactDict = [tm getTransHashToContactMap];
    NSString *contact = [contactDict objectForKey:txHash];
    
    NSDictionary *addressDict = [tm getTransHashToAddressMap];
    NSString *address = [addressDict objectForKey:txHash];
    
    // build the dict, pull out confirmations/amnt
    NSDictionary *txDat = [APINetworkOps getTXHashInfo:txHash];
    
    NSNumber *confirmations = [txDat objectForKey:@"confirmed"];
    NSString *confirmed = @"UNCONFIRMED";
    if (confirmations != NULL){
        confirmed = @"CONFIRMED";
    }
    
    NSString *value = [txDat objectForKey:@"total"];
    double cVal = [value doubleValue];
    double cValBTC = (cVal / 100000000.0f);
    
    NSString *finalStrToDisplay = [NSString stringWithFormat:@"To: %@\nFrom: %@\nAmount: %3.2f\n%@",contact,address,cValBTC,confirmed];
    contactCell.textLabel.text = finalStrToDisplay;
    
    
    /*
     
     The message will look like
     To: XXX
     From: XXX
     Amount: XXX BTC
     Confirmed/Pending/Rejected
     
     
     */
    
    
    return contactCell;
}


- (void)addNewAddressPressed {

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}

- (void)backButtonPressed {
    [self dismissViewControllerAnimated:TRUE completion:^{
        // nil
    }];
}


@end
