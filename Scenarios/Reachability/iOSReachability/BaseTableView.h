//
//  BaseTableView.h
//  ObjCTableViewNoNib
//
//  Created by Luis Meddrano-Zaldivar on 4/21/17.
//  Copyright © 2017 Luis Meddrano-Zaldivar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableView : UIViewController <UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property NSArray *content;
@property UITableView *tableView;
@property NSMutableAttributedString* bufferedOutText;
@property UITextView *delegateOutputTextView;

-(void)appendToPrintBuffer:(id)format, ...;
-(void)clearLogFromTextView;
-(void)printColoredDebugInfo:(NSString*) string using:(UIColor*)color ;
-(void)printAndscrollDelegateTextViewToBottom;
-(void)configurePropertiesAndViews;

@end
