//
//  ViewController.h
//  FileActivation
//
//  Created by Raj Seshasankaran on 10/19/16.
//  Copyright © 2016 Raj Seshasankaran. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef WINOBJC
#import <UWP/WindowsStorage.h>
#endif

@interface ViewController : UIViewController

#ifdef WINOBJC
- (void) handleFilesActivated:NSArray<WSIStorageItem>* files;
#endif

@end

