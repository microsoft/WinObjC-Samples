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

#import "MainViewController.h"


@implementation MainViewController

static NSDictionary *contacts;

- (void)viewDidLoad {
    [super viewDidLoad];

    // UWP has no status bar
	#ifdef WINOBJC
	[[UIApplication sharedApplication] setStatusBarHidden:YES]; // Deprecated in iOS
	#endif
    CGFloat frameWidth = self.view.frame.size.width;
    CGFloat frameHeight = self.view.frame.size.height;
    [self.view setBackgroundColor:[UIColor whiteColor]];

    // add navigation bar
    _navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 20, frameWidth, 44)];
	#ifdef WINOBJC
	_navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, frameWidth, 44)];
	#endif
    _navBar.barTintColor = [UIColor colorWithRed:(0xc5/255.0f) green:(0xef/255.0f) blue:(0xf7/255.0f) alpha:1.0];
    
    // add navbar item with buttons
    UINavigationItem *staticItem = [[UINavigationItem alloc] initWithTitle:@"Contacts"];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:@selector(addButtonPressed)];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:@selector(backButtonPressed)];
    staticItem.rightBarButtonItem = addButton;
    staticItem.leftBarButtonItem = backButton;
    [_navBar pushNavigationItem:staticItem animated:NO];
    // add navigation bar
    [self.view addSubview:_navBar];
    
    
    // Fill Table
    ContactManager *contactMan = [ContactManager globalManager];
    NSDictionary *pairDict = [contactMan getKeyPairs];
    contacts = pairDict;
    _tableData = [[NSArray arrayWithArray:[pairDict allKeys]] retain];
    
    // create tableview
    CGRect mainTableFrame = CGRectMake(0, 64, frameWidth, frameHeight-64);
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

// number of rows = number of contats
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tableData count];
}

// return cell with contact name
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *contactCellIdent = @"contactCell";
    UITableViewCell *contactCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contactCellIdent];
    contactCell.textLabel.text = [_tableData objectAtIndex:indexPath.row];    
    return contactCell;
}

// select contact, create VC with the relevant info and show
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    // get the row
    UITableViewCell *cellSelected = [tableView cellForRowAtIndexPath:indexPath];
    NSString *tag = cellSelected.textLabel.text;
    // get the address
    NSString *address = [contacts objectForKey:tag];    
    ContactViewController *toShow = [ContactViewController initWithName:tag andAddress:address];
    [toShow setModalPresentationStyle:UIModalPresentationFullScreen];
    [toShow setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:toShow animated:YES completion:^{
    }];

    
}

- (void)backButtonPressed {
    [self dismissViewControllerAnimated:TRUE completion:^{
        // nil
    }];
}

// on add, iOS will show qr scanner, UWP does not support and show text entry 
- (void)addButtonPressed {
    
	#ifndef WINOBJC
    CreateContactViewController *toShow = [[CreateContactViewController alloc] init];
    [toShow setModalPresentationStyle:UIModalPresentationFullScreen];
    [toShow setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:toShow animated:YES completion:^{
    }];
	#endif 

	// windows projections don't have any QR Support. This is two text blocks because of time constraints
	#ifdef WINOBJC
	WXCContentDialog *alert = [WXCContentDialog make];
	alert.primaryButtonText = @"Accept";
	alert.secondaryButtonText = @"Reject";

	// put a text block as the title
	WXCTextBlock *title = [WXCTextBlock make];
	title.text = @"Create New Contact";
	alert.title = title;

	// put a StackPanel containing two text blocks in as the content
	WXCTextBox* nameBox = [WXCTextBox make];
	nameBox.placeholderText = @"Address_Nickname,Address";
	alert.content = nameBox;
	[alert showAsyncWithSuccess:^(WXCContentDialogResult success) {
		// 1 is accept
		if (success == 1){
			// grab the text box's data, make a new address with that name
			NSString *newTag = nameBox.text;

			// if string is null it's no good
            if(newTag == NULL) {
				[self sendErrorMsg];
                return;
            }

			NSString *finalString = [NSString stringWithFormat:@"%@\n",newTag];
			
			// if it doesn't fit the regex [alphanum],[alphanum] it isn't valid either

			// get contact man, put split string in
			ContactManager *con = [ContactManager globalManager];
			[con addKeyPair:finalString];
		}
	} failure:^(NSError* failure) {
		// nope
	}];


	#endif

}

// send UWP error message
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
	} failure:^(NSError* failure) {
		// nope
	}];

	#endif


}







@end
