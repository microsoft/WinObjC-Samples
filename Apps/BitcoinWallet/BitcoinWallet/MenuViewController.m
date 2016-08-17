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

#import <Foundation/Foundation.h>
#import "MenuViewController.h"

@implementation MenuViewController

static NSString *kMakePaymentString = @"Make Payment\nBalance: 0.00BTC";
static NSString *kAddressesButtonString = @"My\nAddresses";
static NSString *kContactsButtonString = @"My\nContacts";
static NSString *kTransactionsButtonString = @"Past Transactions";




- (void)viewDidLoad {
    
    self.view.backgroundColor = [UIColor colorWithRed:(210.0/255.0f) green:(215.0/255.0f) blue:(211.0/255.0f) alpha:1.0];
    
    // no status bar on UWP
	#ifdef WINOBJC
	[[UIApplication sharedApplication] setStatusBarHidden:YES]; // Deprecated in iOS
	#endif

    // payment button
    self.makePaymentButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.makePaymentButton.layer.borderWidth = 1;
    self.makePaymentButton.layer.cornerRadius = 15;
    self.makePaymentButton.clipsToBounds = TRUE;
    
    self.makePaymentButton.backgroundColor = [UIColor colorWithRed:(0x87/255.0f) green:(0xd3/255.0f) blue:(0x7c/255.0f) alpha:1.0];
    [self.makePaymentButton setTitle:kMakePaymentString
                            forState:UIControlStateNormal];
    [self.makePaymentButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.makePaymentButton addTarget:self
                               action:@selector(transationButtonPressed)
                     forControlEvents:UIControlEventTouchUpInside];
    [self.makePaymentButton sizeToFit];
    self.makePaymentButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.makePaymentButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.makePaymentButton.titleLabel.textColor = [UIColor blackColor];
    [self.view addSubview:self.makePaymentButton];
    
    // addresses button
    self.myAddressesButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.myAddressesButton.layer.borderWidth = 1;
    self.myAddressesButton.layer.cornerRadius = 15;
    self.myAddressesButton.clipsToBounds = TRUE;
    
    self.myAddressesButton.backgroundColor = [UIColor colorWithRed:(0xf1/255.0f) green:(0xa9/255.0f) blue:(0xa0/255.0f) alpha:1.0];
    self.myAddressesButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.myAddressesButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.myAddressesButton setTitle:kAddressesButtonString
                            forState:UIControlStateNormal];
    [self.myAddressesButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.myAddressesButton addTarget:self
                               action:@selector(addressButtonPressed)
                     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.myAddressesButton];
    
    // contacts button
    self.myContactsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.myContactsButton.layer.borderWidth = 1;
    self.myContactsButton.layer.cornerRadius = 15;
    self.myContactsButton.clipsToBounds = TRUE;
    self.myContactsButton.backgroundColor = [UIColor colorWithRed:(0xf5/255.0f) green:(0xd7/255.0f) blue:(0x6e/255.0f) alpha:1.0];
    [self.myContactsButton setTitle:kContactsButtonString
                           forState:UIControlStateNormal];
    self.myContactsButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.myContactsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.myContactsButton sizeToFit];
    [self.myContactsButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.myContactsButton addTarget:self
                              action:@selector(contactButtonPressed)
                    forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.myContactsButton];
    
    // transactions button
    self.myTransactionsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.myTransactionsButton.layer.borderWidth = 1;
    self.myTransactionsButton.layer.cornerRadius = 15;
    self.myTransactionsButton.clipsToBounds = TRUE;
    self.myTransactionsButton.backgroundColor = [UIColor colorWithRed:(0xc5/255.0f) green:(0xef/255.0f) blue:(0xf7/255.0f) alpha:1.0];
    [self.myTransactionsButton setTitle:kTransactionsButtonString
                               forState:UIControlStateNormal];
    [self.myTransactionsButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.myTransactionsButton addTarget:self
                                  action:@selector(transactionListButtonPressed)
                        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.myTransactionsButton];
    
    
    
    // set platform agnostic constraints
    NSDictionary *metrics = @{ @"pad": @80.0, @"margin": @40, @"paymentButtonHeight": @150};
    NSDictionary *views = @{ @"paymentButton"   : self.makePaymentButton,
                             @"contactsButton" : self.myContactsButton,
                             @"addressesButton" : self.myAddressesButton,
                             @"transactionsButton" : self.myTransactionsButton
                             };
    
    // These constraints display well on Windows UWP devices
    #ifdef WINOBJC
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[paymentButton]-300-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[paymentButton]-50-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-170-[contactsButton]-225-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[contactsButton]-50-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-250-[addressesButton]-150-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[addressesButton]-50-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-325-[transactionsButton]-100-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[transactionsButton]-50-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    #endif
    // These constraints display well on iOS
    #ifndef WINOBJC
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[paymentButton]-350-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[paymentButton]-50-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-325-[contactsButton]-200-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[contactsButton]-193-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-325-[addressesButton]-200-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-193-[addressesButton]-50-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-475-[transactionsButton]-100-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[transactionsButton]-50-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    #endif
    
    // async get balance and update
    dispatch_queue_t balanceQueue = dispatch_queue_create("Balance Queue",NULL);
    dispatch_async(balanceQueue, ^{
		#ifndef WINOBJC
        // get addresses
        NSDictionary *addresses = [[AddressManager globalManager] getKeyPairs];
        // get the double (there are 100mil satoshi to a bitcoin)
        double balanceInSatoshi = [NetworkOps returnBalanceFromAddresses:addresses];
        double balanceInBTC = (balanceInSatoshi /100000000.0f);
        // update the string
        kMakePaymentString = [NSString stringWithFormat:@"Make Payment\nBalance: %.2fBTC",balanceInBTC];
        // update the view hierarchy
        [self.makePaymentButton setTitle:kMakePaymentString forState:UIControlStateNormal];
        [self.makePaymentButton setNeedsDisplay];
		#endif
    });
    
    // strange crashes on background thread under UWP
	#ifdef WINOBJC
	// get addresses
    NSDictionary *addresses = [[AddressManager globalManager] getKeyPairs];
    // get the double (there are 100mil satoshi to a bitcoin)
    double balanceInSatoshi = [NetworkOps returnBalanceFromAddresses:addresses];
    double balanceInBTC = (balanceInSatoshi /100000000.0f);
    // update the string
    kMakePaymentString = [NSString stringWithFormat:@"Make Payment\nBalance: %.2fBTC",balanceInBTC];
    // update the view hierarchy
    [self.makePaymentButton setTitle:kMakePaymentString forState:UIControlStateNormal];
    [self.makePaymentButton setNeedsDisplay];
	#endif
    
    
    
}

// The following methods handle button presses and display the relevant VC

- (void)addressButtonPressed {
    AddressListView *addrViewCon = [[[AddressListView alloc] init] retain];
    [addrViewCon setModalPresentationStyle:UIModalPresentationFullScreen];
    [addrViewCon setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:addrViewCon animated:YES completion:^{
        // nada
    }];
}

- (void)contactButtonPressed {
    MainViewController *contactVC = [[[MainViewController alloc] init] retain];
    [contactVC setModalPresentationStyle:UIModalPresentationFullScreen];
    [contactVC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:contactVC animated:YES completion:^{
        // nada
    }];
}

- (void)transationButtonPressed {
    SendTransactionViewController *contactVC = [[[SendTransactionViewController alloc] init] retain];
    [contactVC setModalPresentationStyle:UIModalPresentationFullScreen];
    [contactVC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:contactVC animated:YES completion:^{
        // nada
    }];
}

- (void)transactionListButtonPressed {
    TransactionListViewController *contactVC = [[[TransactionListViewController alloc] init] retain];
    [contactVC setModalPresentationStyle:UIModalPresentationFullScreen];
    [contactVC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:contactVC animated:YES completion:^{
        // nada
    }];
}

@end
