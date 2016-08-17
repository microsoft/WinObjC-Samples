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
#import "AddressListView.h"

@implementation AddressListView

- (void)viewDidLoad {
    [super viewDidLoad];

    // hide the status bar only in UWP
	#ifdef WINOBJC
	[[UIApplication sharedApplication] setStatusBarHidden:YES]; // Deprecated in iOS
	#endif
    
    CGFloat frameWidth = self.view.frame.size.width;
    CGFloat frameHeight = self.view.frame.size.height;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // add navigation bar
    _navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 20, frameWidth, 44)];
    // take into account no status bar on UWP application
    #ifdef WINOBJC
	_navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, frameWidth, 44)];
	#endif
    _navBar.barTintColor = [UIColor colorWithRed:(0xc5/255.0f) green:(0xef/255.0f) blue:(0xf7/255.0f) alpha:1.0];

    // add navbar item with buttons
    UINavigationItem *navBar = [[UINavigationItem alloc] initWithTitle:@"Addresses"];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:@selector(addNewAddressPressed)];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:@selector(backButtonPressed)];
    navBar.rightBarButtonItem = addButton;
    navBar.leftBarButtonItem = backButton;
    [_navBar pushNavigationItem:navBar animated:NO];
    // add navigation bar
    [self.view addSubview:_navBar];
    
    // get data from address manager
    AddressManager *addressMan = [AddressManager globalManager];
    _pairDict = [[addressMan getKeyTagMapping] retain];
    _tableData = [[NSArray arrayWithArray:[_pairDict allKeys]] retain];
    
    // create tableview
    CGRect mainTableFrame = CGRectMake(0, 64, frameWidth, frameHeight-64);
    // take into account no status bar on UWP application
	#ifdef WINOBJC
	mainTableFrame = CGRectMake(0, 44, frameWidth, frameHeight-44);
	#endif
    _mainTable = [[UITableView alloc]initWithFrame:mainTableFrame style:UITableViewStylePlain];
    [_mainTable setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_mainTable setDelegate:self];
    [_mainTable setDataSource:self];
    _mainTable.backgroundColor = [UIColor colorWithRed:(210.0/255.0f) green:(215.0/255.0f) blue:(211.0/255.0f) alpha:1.0];
    [self.view addSubview:_mainTable];
  
    
}

// table rows = number of addresses stored
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tableData count];
}

// synchronously get the value stored at the address, display it as the cell tag
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *contactCellIdent = @"contactCell";
    UITableViewCell *contactCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contactCellIdent];
    NSString *key = [_tableData objectAtIndex:indexPath.row];
    NSString *addr = [_pairDict objectForKey:key];
    double totalVal = [NetworkOps getBalanceSimple:addr];
    double totalValBTC = (totalVal / 100000000.0f);
    NSString *finalLabel = [NSString stringWithFormat:@"%@ - %.2f BTC",key,totalValBTC];
    contactCell.textLabel.text = finalLabel;    
    return contactCell;
}

// on press, show a view controller with the relevant address
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    // get the row
    UITableViewCell *cellSelected = [tableView cellForRowAtIndexPath:indexPath];
    NSString *tag = cellSelected.textLabel.text;
    // get the address
    NSString *address = [_pairDict objectForKey:tag];    
    AddressViewController *toShow = [AddressViewController initWithName:tag andAddress:address];
    [toShow setModalPresentationStyle:UIModalPresentationFullScreen];
    [toShow setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:toShow animated:YES completion:^{
    }];
    
    
}

// on press, give a popup which allows a user to choose a new name for a new address
- (void)addNewAddressPressed {
    
	// UIAlertController in ios
	#ifndef WINOBJC
    UIAlertController *newAddress = [UIAlertController alertControllerWithTitle:@"Create New Address" message:@"Provide a nickname for this address" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *submit = [UIAlertAction actionWithTitle:@"Create" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // get string pair
        UITextField *addressName = (UITextField*)newAddress.textFields.firstObject;
        NSString *newTag = addressName.text;
        if(newTag == NULL) {
            return;
        }
        [APINetworkOps generateAddressAndAddToAddressManagerWithTag:newTag];
        // add kp to the manager
        [self.view setNeedsDisplay];
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate date]];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        // just quietly exit
    }];
    [newAddress addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Address Name";
    }];
    [newAddress addAction:cancel];
    [newAddress addAction:submit];
    [self presentViewController:newAddress animated:YES completion:^{
        // nothing
    }];
	#endif

    // windows code because UIALERTCONTROLLER as above is not valid. UIAlertView Text Fields aren't supported by IW yet    
	#ifdef WINOBJC
    // The correct mapping is content dialog
    WXCContentDialog *alert = [WXCContentDialog make];
    alert.primaryButtonText = @"Accept";
    alert.secondaryButtonText = @"Reject";
    
    // put a text block as the title
    WXCTextBlock *title = [WXCTextBlock make];
    title.text = @"Create New Address";
    alert.title = title;
    
    // put a text box in as the content
    WXCTextBox* textBox = [WXCTextBox make];
    textBox.placeholderText = @"Type an Address Nickname";
    alert.content = textBox;
    
    [alert showAsyncWithSuccess:^(WXCContentDialogResult success) {
        //  if accept is pressed (WXCContentDialogResult.WXCContentDialogResultPrimary = 1)
        if (success == 1){
            // grab the text box's data, make a new address with that name
            NSString *newTag = textBox.text;
            // if string is null it's no good
            if(newTag == NULL) {
				[self sendErrorMsg];
                return;
            }
			// if the address name already exists it's no good
			AddressManager *addrman = [AddressManager globalManager];
			NSDictionary *dict = [addrman getKeyTagMapping];
			if ([dict objectForKey:newTag] != NULL) {
				[self sendErrorMsg];
				return;	
			}
            [APINetworkOps generateAddressAndAddToAddressManagerWithTag:newTag];
        }
    } failure:^(NSError* failure) {
        // not handled
    }];
    
	#endif
    
}

// exit the vc
- (void)backButtonPressed {
    [self dismissViewControllerAnimated:TRUE completion:^{
        // nil
    }];
}

// exit the vc
- (void)AddressSubmitPressed {
    [self dismissViewControllerAnimated:TRUE completion:^{
        // nil
    }];
}

// display a windows error message using context dialog
- (void)sendErrorMsg {
	
	#ifdef WINOBJC
	WXCContentDialog *alert = [WXCContentDialog make];
	alert.primaryButtonText = @"OK";

	// put a text block as the title
	WXCTextBlock *title = [WXCTextBlock make];
	title.text = @"Error - Incorrect Params";
	alert.title = title;

	// put a text box in as the content
	WXCTextBlock* contentText = [WXCTextBlock make];
	contentText.text = @"There was an error in creating the Address\nFix the parameters and try again";
	contentText.maxLines = 2;
	alert.content = contentText;

	[alert showAsyncWithSuccess:^(WXCContentDialogResult success) {
        // not required
	} failure:^(NSError* failure) {
		// not handled
	}];

	#endif


}




@end
