# Bitcoin Wallet

## Functionality
The provided application is a demonstration of the capabiilities of the Windows Bridge to iOS. The application is a bitcoin wallet which runs on the [bitcoin test3 network](https://en.bitcoin.it/wiki/Testnet), a developer sandbox where the coins have no value other than to demonstrate the usage of the blockchain technology. With this application, a user can create new addresses under their control, create contacts, send and recieve bitcoins, and view past transactions. 

The application and the associated source code serves to demonstrate the process by which an application (which was developed entirely in an iOS environment in Objective-C) can be ported through the use of the Islandwood tools on to the Universal Windows Platform while maintaining the same usability.

## Setting Up

For this sample, you will need a PC running Windows 10, the [Windows Bridge for iOS](https://github.com/Microsoft/WinObjC), Visual Studio 2015. If you would like to run and see the application for comparison on iOS, you will need a Mac running a modern build of OSX and Xcode 7 or better. 

This sample uses the RESTful API provided by [BlockCypher](https://dev.blockcypher.com/) as a platform independent way to build, marshall, and submit bitcoin transactions to the peer-to-peer network. In APINetworkOps.m 

1. First open the MapsSample directory in file explorer. Next, run the [VSImporter tool](https://github.com/Microsoft/WinObjC/wiki/Using-vsimporter) tool on the MapsSample project to generate a Visual Studio solution (.sln) file. 
2. Open the .sln file in Visual Studio
3. When in Visual Studio, press F5 or select Build->Build Solution in the menu bar

After the project has built, it is ready to run or deploy.


## Sugested Usage and Basic Use Case

The application was designed to showcase a basic functionality in terms of Bitcoin transactions. In this vein, it is completely usable. The suggested use case looks something like this.

1. Install, set up the application on the target device
2. Generate an address, read the QR Code as an address
3. Send some bitcoins to that address
 -If you have another testnet client with bitcoins, feel free to use those
 -You can also get them from a [testnet faucet](http://tpfaucet.appspot.com/)
4. Add a contact
5. Use the send transaction menu to direct your transaction
6. Monitor the status of your transaction with the transaction menu

## The Code


### Displaying controls for contextual decisions

In the iOS application, many of the contextual decisions that the user makes are done through UIAlertView pop-up dialogs. When a user needs to confirm an action that the application is going to take or add some input before said action occurs, it is done entirely within the UIAlertView. There are a number of issues with this when the conversion through the WinObjC SDK occurs. Namely, many of the selectors and methods have not yet been ported in the bridge's UIKit implementation. However, the Windows XAML controls offer us the Content Dialog which works in a similar way. The Context Dialog is a pop-up control which we can fill with other XAML Controls as content. I will include one such example here to display the usage pattern; however, it is used everywhere that UIAlertViews need replacing

First, in our header file we include the [Windows.UI.Xaml.Controls](https://msdn.microsoft.com/en-us/library/windows/apps/windows.ui.xaml.controls.aspx) namespace, where the Content Dialog control is defined.

```ObjectiveC
#ifdef WINOBJC
#import <UWP/WindowsUIXamlControls.h>
#endif
```
In the Windows Bridge to iOS, the naming convention concatenates the first letters of the namespace as follows. In this naming scheme, what was [Windows.UI.XAML.Controls.ContentDialog](https://msdn.microsoft.com/en-us/library/windows/apps/windows.ui.xaml.controls.contentdialog.aspx) becomes WXCContentDialog. Also of note, the make selector is the "constructor" which performs a similar role to the alloc/init functions in Foundation classes.

```ObjectiveC
WXCContentDialog *alert = [WXCContentDialog make];
alert.primaryButtonText = @"Accept";
alert.secondaryButtonText = @"Reject";
```

Next, the Context Dialog uses another XAML Control as the title. We achieve this with a [Text Block](https://msdn.microsoft.com/en-us/library/windows/apps/windows.ui.xaml.controls.textblock.aspx) control.In the project's naming scheme, what was [Windows.UI.XAML.Controls.TextBlock](https://msdn.microsoft.com/en-us/library/windows/apps/windows.ui.xaml.controls.textblock.aspx) becomes WXCTextBlock.

```ObjectiveC
// put a text block as the title
WXCTextBlock *title = [WXCTextBlock make];
title.text = @"Create New Contact";
alert.title = title;
```

Finally, we are ready to fill the Context Dialog with our, in this case, address name box. This [Windows.UI.Xaml.TextBox](https://msdn.microsoft.com/en-us/library/windows/apps/windows.ui.xaml.controls.textbox.aspx) allows for the user to input text, as they do when adding a new contact. We also set a callback with the relevant action to perform if the correct button is pressed

```ObjectiveC
WXCTextBox* nameBox = [WXCTextBox make];
nameBox.placeholderText = @"Address_Nickname,Address";
alert.content = nameBox;
[alert showAsyncWithSuccess:^(WXCContentDialogResult success) {
	// do success
} failure:^(NSError* failure) {
		// do failure
	}];
```

### Altering the View and Autolayout System for UWP

There are a number of small tweaks that need to be made to the layout system in order to improve the look of the application. Firstly, we hide the status bar as iOS applications do; however, this is done manually in UWP.

```ObjectiveC
#ifdef WINOBJC
[[UIApplication sharedApplication] setStatusBarHidden:YES]; // Deprecated in iOS
#endif
```

Next, I manually based some frame boxes of what the size of the iOS status bar was, so this too needs to change in UWP where no such bar exists.

```ObjectiveC
// The status bar is usually 20 px tall
_navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 20, frameWidth, 44)];
#ifdef WINOBJC
_navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, frameWidth, 44)];
#endif
```

Aditionally, this changes the frame of the tableview that sits below the status bar given the two above changes

```ObjectiveC
// create tableview
CGRect mainTableFrame = CGRectMake(0, 64, frameWidth, frameHeight-64);
#ifdef WINOBJC
mainTableFrame = CGRectMake(0, 44, frameWidth, frameHeight-44);

```

Finally, the iOS layout scheme targeted the iPhone 6s, my development device and such the constraints looked none too pretty on UWP. Thus, for example, each set of constraints was altered slightly to fix cosmetic problems

```ObjectiveC
#ifndef WINOBJC
[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[paymentButton]-300-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
#endif 
#ifdef WINOBJC
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[paymentButton]-350-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
#endif
```



### Use of the System Camera

If one runs the iOS version of the application, they will find that adding new contacts is done by scanning a QR code associated with the address and a live camera preview for them to position the QR code into. This is a fluid experience that can't, as of yet, be recreated easily in UWP because of the lack of easy QR processing libraries. Zebra Crossing (ZXing) is the most popular C# library for this purpose but is not interoprable. Therefore, it has not been included in the released version. However, the camera portion does work. Taking a photograph using it in your application is a common use case and is explained below

Firstly, we will be using the CameraCaptureUI API which calls up the default Windows Phone/Device camera interface and allows us to access the result in a callback. We then import the following two namespaces: [Windows.Media.Capture](https://msdn.microsoft.com/en-us/library/windows/apps/windows.media.capture.aspx) and [Windows.Storage](https://msdn.microsoft.com/en-us/library/windows/apps/windows.storage.aspx)

```ObjectiveC
#ifdef WINOBJC
#import <UWP/WindowsMediaCapture.h>
#import <UWP/WindowsStorage.h>
#end
```

Next, we will instantiate an instance of the [CameraCaptureUI](https://msdn.microsoft.com/en-us/library/windows/apps/windows.media.capture.cameracaptureui.aspx) class. For the purposes of demonstration we won't change any of the photo settings; however, note that they can be changed through PhotoSettings.Format along with PhotoSettings.CroppedSizeInPixels. Instead, we will create the CameraCaptureUI and then have it launch and deal with what returns as a callback
```ObjectiveC
#ifdef WINOBJC
// create the CameraCaptureUI
WMCCameraCaptureUI *camCapture = [WMCCameraCaptureUI make];
#end
```

We're going to assume you only want to capture photos, and thus set the mode to be WMCCameraCaptureUIModePhoto. Others are detailed in the header files in the project found at [UWP/WindowsMediaCapture.h](https://github.com/Microsoft/WinObjC/blob/master/include/Platform/Universal%20Windows/UWP/WindowsMediaCapture.h)
```ObjectiveC
#ifdef WINOBJC
// Launch, deal with callback
[camCapture captureFileAsync:WMCCameraCaptureUIMode success:^(WSStorageFile success){ 
	// the WSStorageFile success contains the photo you've captured
} failure:^(NSError* failure) {
	// handle failure
}]
#end
```

## Provided supplemental code which includes 3rd party libraries 

Included in the /Supplemental folder of the project are a number of files which mirror the files of the same name in the project folders but whose headers and implementations reference the popular 3rd party libraries AFNetworking and Bolts. The two frameworks are at rapidly improving stages of functionality when interacting with the SDK, but at the time of writing are not fully plug-and-play. Thus, the code is provided with the understanding that eventually once development on the bridge has progressed, this application will also demonstrate the capabilities of the SDK to handle middleware. 

## Disclaimer

Steps were taken to ensure that the transactions performed are validated and verified, as well, the entire application runs on the test3 blockchain which was designed to have no or little inherent value. Even so, this application is first and foremost a demonstration of the Bridge to iOS as a technology and not intended to be a day to day financial instrument and we would highly advise against any use to that end. 

## Licences

The DEREncoder.m/.h file pair, and the uECC.m/.h file pair are both parts of 3rd party libraries which have been released under the BSD 2-Clause licence and whose licences can be found reproduced in full as comments within the source code. The uECC Library is [located on Github](https://github.com/utamaro/pyuecc) as are the [DER Encoding functions](https://github.com/ricmoo/GMEllipticCurveCrypto) here.

Apart from the above files, the rest of the project is being released by Microsoft under the [standard MIT Licence](https://opensource.org/licenses/MIT) which can be found as intended in any of the afforementioned code.

## Privacy

This application uses the data you input into it as the basis for forming transactions which are going to be sent to a 3rd party service ([BlockCypher](https://www.blockcypher.com/)) for propgation and verification by the rest of the network. 

## Collected Reading and Quick Reference

1. ContextDialog, TextBox, and TextBlock XAML Controls can be found [at the MSDN API Reference for the Windows.UI.Xaml.Controls namespace](https://msdn.microsoft.com/en-us/library/windows/apps/windows.ui.xaml.controls.aspx)
2. The specifics for the Windows.UI.Xaml.Controls namespace in the Windows Bridge to iOS are [found in the header files](https://github.com/Microsoft/WinObjC/blob/master/include/Platform/Universal%20Windows/UWP/WindowsUIXamlControls.h)
3. The use of the system camera is detailed at the [MSDN UWP reference](https://msdn.microsoft.com/en-us/library/windows/apps/windows.media.capture.aspx) and the specifics are found in the [WinObjC header files](https://github.com/Microsoft/WinObjC/blob/master/include/Platform/Universal%20Windows/UWP/WindowsMediaCapture.h)
4. The status of [middleware/3rd party library support can be found in the WinObjC Wiki](https://github.com/Microsoft/WinObjC/wiki/Supported-Third-Party-Libraries)
5. [Information about Bitcoin, blockchain technology, ect](https://en.bitcoin.it/wiki/Main_Page)

