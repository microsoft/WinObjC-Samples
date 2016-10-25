//
//  ViewController.m
//  FileActivation
//
//  Created by Raj Seshasankaran on 10/19/16.
//  Copyright © 2016 Raj Seshasankaran. All rights reserved.
//

#import "ViewController.h"

#ifdef WINOBJC
#import <UWP/WindowsStorage.h>
#endif

@interface ViewController ()

@property UILabel* demoTitle;
@property UILabel* demoInfo;
@property UILabel* countInfo;
@property UILabel* namesInfo;

@end

@implementation ViewController

static NSString* const kTitleString = @"File activation";
static NSString* const kInfoString = @"This WinObjC sample project demonstrates how to register file types in a WinOBJC app and handle the files when the app is activated by opening the registered file(s). ";

static NSString * const kFilesCountString = @"No files were opened.";
static NSString * const kFileNamesString = @"Please launch app by double clicking on a file with .faa extension.  ";

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // Set up the demo title label
    self.demoTitle = [UILabel new];
    self.demoTitle.text = [NSString stringWithFormat:@"WinObjC: %@", kTitleString];
    self.demoTitle.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
    self.demoTitle.textAlignment = NSTextAlignmentCenter;
    self.demoTitle.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Set up the demo info label
    self.demoInfo = [UILabel new];
    self.demoInfo.text = kInfoString;
    self.demoInfo.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    self.demoInfo.numberOfLines = 0;
    self.demoInfo.lineBreakMode = NSLineBreakByWordWrapping;
    self.demoInfo.textAlignment = NSTextAlignmentCenter;
    self.demoInfo.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.countInfo = [UILabel new];
    self.countInfo.text = kFilesCountString;
    self.countInfo.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    self.countInfo.numberOfLines = 0;
    self.countInfo.lineBreakMode = NSLineBreakByWordWrapping;
    self.countInfo.textAlignment = NSTextAlignmentCenter;
    self.countInfo.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.namesInfo = [UILabel new];
    self.namesInfo.text = kFileNamesString;
    self.namesInfo.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    self.namesInfo.numberOfLines = 0;
    self.namesInfo.lineBreakMode = NSLineBreakByWordWrapping;
    self.namesInfo.textAlignment = NSTextAlignmentCenter;
    self.namesInfo.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:self.demoTitle];
    [self.view addSubview:self.demoInfo];
    [self.view addSubview:self.countInfo];
    [self.view addSubview:self.namesInfo];
    
    // Layout constraints
    NSDictionary *metrics = @{ @"pad": @80.0, @"namesHeight": @120, @"demoInfoHeight": @120 };
    NSDictionary *views = @{ @"title"   : self.demoTitle,
                             @"info"    : self.demoInfo,
                             @"count"   : self.countInfo,
                             @"names"   : self.namesInfo
                             };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[title]-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[info]-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[count]-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[names]-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[title]-[info(demoInfoHeight)]-[count]-[names(namesHeight)]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
#ifdef WINOBJC
    [[UIApplication sharedApplication] setStatusBarHidden:YES]; // Deprecated in iOS
#endif
}

- (BOOL) prefersStatusBarHidden
{
    return YES;
}

#ifdef WINOBJC
- (void) handleFilesActivated:(NSArray*) files {
    self.countInfo.text = [NSString stringWithFormat:@"File activation opened %d file(s)", files.count];
    NSMutableString* fileNames = [NSMutableString string];
    for (int i=0; i < files.count; ++i) {
        // rt_dynamic_cast<> below is required because of a known issue with projection.
        WSIStorageFile* item = rt_dynamic_cast([WSIStorageFile class], files[i]);
        [fileNames appendFormat:@"%@\r\n", item.name];
    }
    self.namesInfo.text = fileNames;
}
#endif

@end
