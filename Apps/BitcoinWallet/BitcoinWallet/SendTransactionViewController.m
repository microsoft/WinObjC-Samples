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

#import "SendTransactionViewController.h"

@implementation SendTransactionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

	#ifdef WINOBJC
	[[UIApplication sharedApplication] setStatusBarHidden:YES]; // Deprecated in iOS
	#endif

    
    // set contact info
    ContactManager *cm = [ContactManager globalManager];
    _contactData = [[cm getKeyPairs] retain];
    _pickerData = [[_contactData allKeys] retain];
    
    // set address info
    AddressManager *am = [AddressManager globalManager];
    _addressData = [am getKeyTagMapping];
    _pickerDataAddresses = [[_addressData allKeys] retain];
    
    CGFloat frameWidth = self.view.frame.size.width;
    CGFloat frameHeight = self.view.frame.size.height;
    
    self.view.backgroundColor = [UIColor colorWithRed:(210.0/255.0f) green:(215.0/255.0f) blue:(211.0/255.0f) alpha:1.0];

    
    // add navigation bar
    _navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 20, frameWidth, 44)];

	// navbar should sit on top of app frame, no status bar to worry about in UWP
	#ifdef WINOBJC
	_navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, frameWidth, 44)];
	#endif

    _navBar.barTintColor = [UIColor colorWithRed:(0xc5/255.0f) green:(0xef/255.0f) blue:(0xf7/255.0f) alpha:1.0];
    
    // add navbar item with buttons
    
    UINavigationItem *navBar = [[UINavigationItem alloc] initWithTitle:@"Send Transaction"];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:@selector(backButtonPressed)];
    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStyleDone target:nil action:@selector(sendPaymentPressed)];
    navBar.rightBarButtonItem = submitButton;
    navBar.leftBarButtonItem = backButton;
    [_navBar pushNavigationItem:navBar animated:NO];
    // add navigation bar
    [self.view addSubview:_navBar];
    
    // set up text field
    self.amountField = [[UITextField alloc] init];
    [self.amountField setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.amountField.textAlignment = NSTextAlignmentCenter;
    self.amountField.layer.borderWidth = 1;
    self.amountField.placeholder = @"Enter Amount in BTC";
    [self.amountField setKeyboardType:UIKeyboardTypeDecimalPad];
    [self.view addSubview:self.amountField];
    
    
    // set up text block
    self.toLabel = [[UILabel alloc] init];
    self.toLabel.text = @"FROM";
    self.toLabel.font = [UIFont systemFontOfSize:25];
	self.toLabel.backgroundColor = [UIColor colorWithRed:(210.0/255.0f) green:(215.0/255.0f) blue:(211.0/255.0f) alpha:1.0];
    [self.toLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.toLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:self.toLabel];

	// set up text block
    self.fromLabel = [[UILabel alloc] init];
    self.fromLabel.text = @"TO";
    self.fromLabel.font = [UIFont systemFontOfSize:25];
	self.fromLabel.backgroundColor = [UIColor colorWithRed:(210.0/255.0f) green:(215.0/255.0f) blue:(211.0/255.0f) alpha:1.0];
    [self.fromLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.fromLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:self.fromLabel];
    
    // set up the contact spinner
    self.contactPicker = [[UIPickerView alloc]init];
    self.contactPicker.delegate = self;
    self.contactPicker.dataSource = self;
    [self.view addSubview:self.contactPicker];
    
    // set up the address spinner
    self.addressPicker = [[UIPickerView alloc]init];
    self.addressPicker.delegate = self;
    self.addressPicker.dataSource = self;
    [self.addressPicker setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.addressPicker];
	

	// looks good on ios
	#ifndef WINOBJC
	// set platform agnostic constraints
    NSDictionary *metrics = @{ @"pad": @80.0, @"margin": @40, @"paymentButtonHeight": @150};
    NSDictionary *views = @{ @"amount" : self.amountField,
                             @"to" : self.toLabel,
                             @"contact" : self.contactPicker,
                             @"address" : self.addressPicker
                             };
    


    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[contact]-10-[to][address][amount]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[contact]-50-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[to]-50-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[address]-50-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[amount]-50-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
	#endif




    
}

- (void)sendPaymentPressed {

	// if no contacts or no from addresses
	if ([_pickerData count] == 0 || [_pickerDataAddresses count] == 0) {
		[self sendErrorMsg];
		return;
	}

	// if null amount or amount isn't a number
	NSString *amountString = [_amountField text];
	if (amountString == NULL) {
		[self sendErrorMsg];
		return;
	}

	if ([amountString doubleValue] == 0.0) {
		[self sendErrorMsg];
		return;
	}


    NSString *pickerContact = [self pickerView:_contactPicker titleForRow:[_contactPicker selectedRowInComponent:0] forComponent:0];
    NSString *pickerAddress = [self pickerView:_addressPicker titleForRow:[_addressPicker selectedRowInComponent:0] forComponent:0];
    NSString *paymentMessage = [NSString stringWithFormat:@"Confirm you want to send %@ BTC from your address \"%@\" \nto your contact \"%@\"\n",_amountField.text, pickerAddress, pickerContact];
	NSLog(@"%@",paymentMessage);

	// ERROR CHECKING - PLATFORM AGNOSTIC
	// Checks for null to,from,amount
	if (pickerContact == NULL || pickerAddress == NULL) {
		[self sendErrorMsg];
		return;
	}
	// TODO: checks if amount string is a valid number (no double decimals)

	#ifndef WINOBJC

    UIAlertController *newAddress = [UIAlertController alertControllerWithTitle:@"Confirm Payment" message:paymentMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *submit = [UIAlertAction actionWithTitle:@"Submit" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        // send the transaction handler the from -> to address and the amount
        
        double amountInSatoshi = [[_amountField text]doubleValue] * 100000000;

        NSNumber *amount = [NSNumber numberWithDouble:amountInSatoshi];
        NSString *inputAddr = [_addressData objectForKey:pickerAddress];
        NSString *outputAddr = [_contactData objectForKey:pickerContact];
        NSData *skele = [[APINetworkOps generatePartialTXWithInput:inputAddr andOutput:outputAddr andValue:amount] retain];
        NSString *partialTx = [APINetworkOps getTXSkeletonWithData:skele];
        
        NSData *dataToSign = [[partialTx dataUsingEncoding:NSUTF8StringEncoding] retain];
        
        NSString* returnedData = [APINetworkOps sendCompletedTransaction:dataToSign forAddress:pickerAddress];
        
        NSData *dataFromString = [returnedData dataUsingEncoding:NSUTF8StringEncoding];
        
        //  create the json object
        NSDictionary *finalTX = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:dataFromString options:0 error:nil];
        
        // error check (literally check for errors in the resturned object
        if ( [finalTX objectForKey:@"errors"]) {
            // if errors, fail quiet *for now*
            return;
        
        } else {
            // else if no errors, assume correct names from input
            NSString *pt1 = [NSString stringWithFormat:@"%@,%@,",pickerAddress,pickerContact];
            // now get the hash from /tx/hash->string
            NSDictionary *tx = [finalTX objectForKey:@"tx"];
            NSString *txHash = [tx objectForKey:@"hash"];
            
            // create transaction with format TO,FROM,HASH
            NSString *finalTxString = [NSString stringWithFormat:@"%@%@\n",pt1,txHash];
        
            // create a transaction + add it to the trans controller
            TransactionManager *txMan = [TransactionManager globalManager];
            [txMan addTransHash:finalTxString];
        }
        
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // just quietly exit
    }];
    
    [newAddress addAction:cancel];
    [newAddress addAction:submit];
    
    
    [self presentViewController:newAddress animated:YES completion:^{
        // nothing
    }];

	#endif 

	#ifdef WINOBJC

	// windows code because UIALERTCONTROLLER as above is not valid. UIAlertView Text Fields aren't supported by IW yet
	// The correct mapping is content dialog
	WXCContentDialog *alert = [WXCContentDialog make];
	alert.primaryButtonText = @"Accept";
	alert.secondaryButtonText = @"Reject";

	// put a text block as the title
	WXCTextBlock *title = [WXCTextBlock make];
	title.text = @"Send Transaction";
	alert.title = title;

	// put a text box in as the content
	WXCTextBlock* contentText = [WXCTextBlock make];
	contentText.text = paymentMessage;
	contentText.maxLines = 2;
	alert.content = contentText;

	[alert showAsyncWithSuccess:^(WXCContentDialogResult success) {
		//  if accept is pressed (WXCContentDialogResult.WXCContentDialogResultPrimary = 1)
		if (success == 1){
		        double amountInSatoshi = [[_amountField text]doubleValue] * 100000000;

        NSNumber *amount = [NSNumber numberWithDouble:amountInSatoshi];
        NSString *inputAddr = [_addressData objectForKey:pickerAddress];
        NSString *outputAddr = [_contactData objectForKey:pickerContact];
        NSData *skele = [[APINetworkOps generatePartialTXWithInput:inputAddr andOutput:outputAddr andValue:amount] retain];
        NSString *partialTx = [APINetworkOps getTXSkeletonWithData:skele];
        
        NSData *dataToSign = [[partialTx dataUsingEncoding:NSUTF8StringEncoding] retain];
        
        NSString* returnedData = [APINetworkOps sendCompletedTransaction:dataToSign forAddress:pickerAddress];
        
        NSData *dataFromString = [returnedData dataUsingEncoding:NSUTF8StringEncoding];
        
        //  create the json object
        NSDictionary *finalTX = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:dataFromString options:0 error:nil];
        
        // error check (literally check for errors in the resturned object
        if ( [finalTX objectForKey:@"errors"]) {
            // if errors, fail quiet
            return;
        
        } else {
            // else if no errors, assume correct names from input
            NSString *pt1 = [NSString stringWithFormat:@"%@,%@,",pickerAddress,pickerContact];
            // now get the hash from /tx/hash->string
            NSDictionary *tx = [finalTX objectForKey:@"tx"];
            NSString *txHash = [tx objectForKey:@"hash"];
            
            // create transaction with format TO,FROM,HASH
            NSString *finalTxString = [NSString stringWithFormat:@"%@%@\n",pt1,txHash];
        
            // create a transaction + add it to the trans controller
            TransactionManager *txMan = [TransactionManager globalManager];
            [txMan addTransHash:finalTxString];
        }


		}
	} failure:^(NSError* failure) {
		// nope
	}];

	#endif

    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == _addressPicker) {
        return [_addressData count];
    } else {
        return [_contactData count];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    if (component == 0) {
        return 30;
    }else {
        return 0;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return 150;
    } else {
        return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == _addressPicker) {
        return [_pickerDataAddresses objectAtIndex:row];
    } else {
        return [_pickerData objectAtIndex:row];
    }
}

- (void)backButtonPressed {
    [self dismissViewControllerAnimated:TRUE completion:^{
        // nil
    }];
}

// to ensure proper view placement under UWP frames are updated on drawing

#ifdef WINOBJC
- (CGRect)calcContactPickerFrame {
	CGFloat frameWidth = self.view.frame.size.width;
    CGFloat frameHeight = self.view.frame.size.height;
	CGRect contactFrame = CGRectMake(200,180,50,100);
	return contactFrame;
}

- (CGRect)calcAddressPickerFrame {
	CGFloat frameWidth = self.view.frame.size.width;
    CGFloat frameHeight = self.view.frame.size.height;
	CGRect contactFrame = CGRectMake(200,300,50,100);
	return contactFrame;
}

- (CGRect)calcToLabelFrame {
	CGFloat frameWidth = self.view.frame.size.width;
    CGFloat frameHeight = self.view.frame.size.height;
	CGRect contactFrame = CGRectMake(50,205,75,50);
	return contactFrame;
}

- (CGRect)calcFromLabelFrame {
	CGFloat frameWidth = self.view.frame.size.width;
    CGFloat frameHeight = self.view.frame.size.height;
	CGRect contactFrame = CGRectMake(50,315,75,50);
	return contactFrame;
}

- (CGRect)calcAmountFieldFrame {
	CGFloat frameWidth = self.view.frame.size.width;
    CGFloat frameHeight = self.view.frame.size.height;
	CGRect contactFrame = CGRectMake(25,75,frameWidth-50,100);
	return contactFrame;
}

-(void) viewWillLayoutSubviews {
	self.contactPicker.frame = [self calcContactPickerFrame];
	self.addressPicker.frame = [self calcAddressPickerFrame];
	self.amountField.frame = [self calcAmountFieldFrame];
	self.toLabel.frame = [self calcToLabelFrame];
	self.fromLabel.frame = [self calcFromLabelFrame];
} 
#endif


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
	contentText.text = @"There was an error in your payment\nFix the parameters and try again";
	contentText.maxLines = 2;
	alert.content = contentText;

	[alert showAsyncWithSuccess:^(WXCContentDialogResult success) {
	} failure:^(NSError* failure) {
		// nope
	}];

	#endif


}



@end
