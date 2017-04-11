//
//  NSDataDeserializeViewController.m
//  Middleware-JsonKit
//
//  Created by venkat kongara on 4/5/17.
//  Copyright © 2017 microsoft. All rights reserved.
//

#import "NSDataDeserializeViewController.h"
#import "JSONKit.h"

@interface NSDataDeserializeViewController () {
    NSData* testData;
    JKParseOptionFlags parseOptionFlag;
}

@end

@implementation NSDataDeserializeViewController

-(void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    switch (indexPath.row) {
        case 0: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [weakSelf objectWithUTF8String];
            });
            break;
        }
        case 1: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [weakSelf mutableObjectWithUTF8String];
            });
            break;
        }
        default:
            break;
    }
}

- (void)viewDidLoad {
    testData = [[self readJsonFrom:@"test" withExtension:@"json"] dataUsingEncoding:NSUTF8StringEncoding];
	parseOptionFlag = JKParseOptionNone;
    [super viewDidLoad];
    self.buttonArray = [[NSArray alloc] initWithObjects:@"objectWithUTF8String",@"mutableObjectWithUTF8String",nil];
    [self constructViewWithTableView];
    [self setTitle:@"Deserialize"];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)alertToCreateDecoder {
    UIAlertAction* alertAction1 = [UIAlertAction actionWithTitle:@"JKParseOptionNone" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        parseOptionFlag = JKParseOptionNone;
    }];
    UIAlertAction* alertAction2 = [UIAlertAction actionWithTitle:@"JKParseOptionStrict" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        parseOptionFlag = JKParseOptionStrict;
    }];
    UIAlertAction* alertAction3 = [UIAlertAction actionWithTitle:@"JKParseOptionComments" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        parseOptionFlag = JKParseOptionComments;
    }];
    UIAlertAction* alertAction4 = [UIAlertAction actionWithTitle:@"JKParseOptionUnicodeNewlines" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        parseOptionFlag = JKParseOptionUnicodeNewlines;
    }];
    UIAlertAction* alertAction5 = [UIAlertAction actionWithTitle:@"JKParseOptionLooseUnicode" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        parseOptionFlag = JKParseOptionLooseUnicode;
    }];
    UIAlertAction* alertAction6 = [UIAlertAction actionWithTitle:@"JKParseOptionPermitTextAfterValidJSON" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        parseOptionFlag = JKParseOptionPermitTextAfterValidJSON;
    }];
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Initialize String deserializing " message:@"select one of the options." preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:alertAction1];
    [alertController addAction:alertAction2];
    [alertController addAction:alertAction3];
    [alertController addAction:alertAction4];
    [alertController addAction:alertAction5];
    [alertController addAction:alertAction6];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)objectWithUTF8String {
    id Object = [testData objectFromJSONDataWithParseOptions:parseOptionFlag error:nil];
    NSMutableAttributedString* outString = [[NSMutableAttributedString alloc] init];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"created below object from a json Data."]]];
    [outString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [outString length])];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" \n%@",Object]]];
    [self appendToPrintBuffer:outString];
    [self printAndscrollDelegateTextViewToBottom];
}

-(void)mutableObjectWithUTF8String {
    id Object = [testData mutableObjectFromJSONDataWithParseOptions:parseOptionFlag error:nil];
    NSMutableAttributedString* outString = [[NSMutableAttributedString alloc] init];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"created below mutable object from a json Data."]]];
    [outString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [outString length])];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" \n%@",Object]]];
    [self appendToPrintBuffer:outString];
    [self printAndscrollDelegateTextViewToBottom];
}

@end
