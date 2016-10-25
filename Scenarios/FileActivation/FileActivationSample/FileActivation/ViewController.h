//
//  ViewController.h
//  FileActivation
//
//  Created by Raj Seshasankaran on 10/19/16.
//  Copyright © 2016 Raj Seshasankaran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/NSArray.h>

@interface ViewController : UIViewController

#ifdef WINOBJC
- (void) handleFilesActivated:(NSArray*) files;
#endif

@end

