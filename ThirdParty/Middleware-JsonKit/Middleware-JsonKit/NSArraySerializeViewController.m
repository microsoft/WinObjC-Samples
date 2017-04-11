//
//  NSArraySerializeViewController.m
//  Middleware-JsonKit
//
//  Created by venkat kongara on 4/3/17.
//  Copyright © 2017 microsoft. All rights reserved.
//

#import "JSONKit.h"
#import "NSArraySerializeViewController.h"
#import "Helper.h"
#import "Organization.h"
#import "Person.h"
#import "PersonalDetails.h"
#import "PersonIdentification.h"


@interface NSArraySerializeViewController () {
    NSArray* testArray;
}

@end

@implementation NSArraySerializeViewController

-(void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    switch (indexPath.row) {
        case 0: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [weakSelf serializeToJSONData];
            });
            break;
        }
        case 1: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [weakSelf serializeToJSONDataWithOptions];
            });
            break;
        }
        case 2: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [weakSelf serializeToJSONString];
            });
            break;
        }
        case 3: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [weakSelf serializeToJSONStringWithOptions];
            });
            break;
        }
        case 4: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [weakSelf serializeUnSupportedArrayObjectsToJSONStringWithOptionsUsingBlock];
            });
            break;
        }
        case 5: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [weakSelf serializeUnSupportedArrayObjectsToJSONDataWithOptionsUsingBlock];
            });
            break;
        }
        case 6: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [weakSelf serializeUnSupportedArrayObjectsToJSONStringWithOptionsUsingDelegate];
            });
            break;
        }
        case 7: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [weakSelf serializeUnSupportedArrayObjectsToJSONDataWithOptionsUsingDelegate];
            });
            break;
        }
        default:
            break;
    }
}

- (void)viewDidLoad {
    //testArray = [[NSArray alloc] initWithObjects:@"one",@"/two",@"three",@"four", nil];
	testArray = [[NSArray alloc] initWithObjects:@"One",[[NSNumber alloc] initWithInt:2],@"/two",@"three",@"four", nil];
    [super viewDidLoad];
    self.buttonArray = [[NSArray alloc] initWithObjects:@"convert to JSONData",@"convert to JSONDataWithOptions",@"convert to JSONString",@"convert to JSONStringWithOptions",@"convert unsupported object to JSON String With Options Using Block",@"convert unsupported object to JSON Data With Options Using Block",@"convert unsupported object to JSON String With Options Using Delegate",@"convert unsupported object to JSON Data With Options Using Delegate",nil];
    [self constructViewWithTableView];
    [self setTitle:@"NSArray Serializer"];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)serializeToJSONData{
    NSData* data = [testArray JSONData];
    NSMutableAttributedString* outString = [[NSMutableAttributedString alloc] init];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"created json data from test Array."]]];
    [outString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [outString length])];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" \n%@",data]]];
    [self appendToPrintBuffer:outString];
    [self printAndscrollDelegateTextViewToBottom];
}

-(void)serializeToJSONDataWithOptions{
    NSData* data = [testArray JSONDataWithOptions:JKSerializeOptionNone error:nil];
    NSMutableAttributedString* outString = [[NSMutableAttributedString alloc] init];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"created json data with pretty JSON and included quotes in JSON from test Array."]]];
    [outString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [outString length])];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" \n%@",data]]];
    [self appendToPrintBuffer:outString];
    [self printAndscrollDelegateTextViewToBottom];
}

-(void)serializeToJSONString{
    NSString* jsonString = [testArray JSONString];
    NSMutableAttributedString* outString = [[NSMutableAttributedString alloc] init];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"created json String from test Array. "]]];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@",testArray]]];
    [outString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [outString length])];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n Output is : \n%@",jsonString]]];
    [self appendToPrintBuffer:outString];
    [self printAndscrollDelegateTextViewToBottom];
}

-(void)serializeToJSONStringWithOptions{
    NSString* jsonString = [testArray JSONStringWithOptions:JKSerializeOptionEscapeForwardSlashes error:nil];
    NSMutableAttributedString* outString = [[NSMutableAttributedString alloc] init];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"created json data with escaped forward slashes and included quotes in JSON from test Array."]]];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@",testArray]]];
    [outString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [outString length])];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n Output is : \n%@",jsonString]]];
    [self appendToPrintBuffer:outString];
    [self printAndscrollDelegateTextViewToBottom];
}

-(void)serializeUnSupportedArrayObjectsToJSONStringWithOptionsUsingBlock{
    NSArray* unsupportedArray = [[NSArray alloc] initWithObjects: [Helper getAvengersOrganizationModel], nil];
    NSString* jsonString = [unsupportedArray JSONStringWithOptions:JKSerializeOptionNone serializeUnsupportedClassesUsingBlock:^id(id object) {
        if ([[object description]  isEqual: @"Organization"]) {
            return [(Organization*)object proxyForJson];
        }else if ([[object description]  isEqual: @"Person"]) {
            return [(Person*)object proxyForJson];
        }else if ([[object description]  isEqual: @"PersonalDetails"]) {
            return [(PersonalDetails*)object proxyForJson];
        }else {
            return [(PersonIdentification*)object proxyForJson];
        }
    } error:nil];
    NSMutableAttributedString* outString = [[NSMutableAttributedString alloc] init];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"created json data with escaped forward slashes and included quotes in JSON from test Array."]]];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@",unsupportedArray]]];
    [outString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [outString length])];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n Output is : \n%@",jsonString]]];
    [self appendToPrintBuffer:outString];
    [self printAndscrollDelegateTextViewToBottom];
}

-(void)serializeUnSupportedArrayObjectsToJSONDataWithOptionsUsingBlock{
    NSArray* unsupportedArray = [[NSArray alloc] initWithObjects: [Helper getAvengersOrganizationModel], nil];
    NSData* jsonData = [unsupportedArray JSONDataWithOptions:JKSerializeOptionNone serializeUnsupportedClassesUsingBlock:^id(id object) {
        if ([[object description]  isEqual: @"Organization"]) {
            return [(Organization*)object proxyForJson];
        }else if ([[object description]  isEqual: @"Person"]) {
            return [(Person*)object proxyForJson];
        }else if ([[object description]  isEqual: @"PersonalDetails"]) {
            return [(PersonalDetails*)object proxyForJson];
        }else {
            return [(PersonIdentification*)object proxyForJson];
        }
    } error:nil];
    NSMutableAttributedString* outString = [[NSMutableAttributedString alloc] init];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"created json data with escaped forward slashes and included quotes in JSON from test Array."]]];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@",unsupportedArray]]];
    [outString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [outString length])];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n Output is : \n%@",jsonData]]];
    [self appendToPrintBuffer:outString];
    [self printAndscrollDelegateTextViewToBottom];
}

-(NSString*)createJSONStringFromModel{
    return [Helper getJSONStringFromModel];
}

-(void)serializeUnSupportedArrayObjectsToJSONStringWithOptionsUsingDelegate{
    NSArray* unsupportedArray = [[NSArray alloc] initWithObjects: [Helper getAvengersOrganizationModel], nil];
    NSString* jsonString = [unsupportedArray JSONStringWithOptions:JKSerializeOptionNone serializeUnsupportedClassesUsingDelegate:self selector:@selector(createJSONStringFromModel) error:nil];
    NSMutableAttributedString* outString = [[NSMutableAttributedString alloc] init];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"created json data with escaped forward slashes and included quotes in JSON from test Array."]]];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@",unsupportedArray]]];
    [outString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [outString length])];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n Output is : \n%@",jsonString]]];
    [self appendToPrintBuffer:outString];
    [self printAndscrollDelegateTextViewToBottom];
}

-(void)serializeUnSupportedArrayObjectsToJSONDataWithOptionsUsingDelegate{
    NSArray* unsupportedArray = [[NSArray alloc] initWithObjects: [Helper getAvengersOrganizationModel], nil];
    NSData* jsonData = [unsupportedArray JSONDataWithOptions:JKSerializeOptionNone serializeUnsupportedClassesUsingDelegate:self selector:@selector(createJSONStringFromModel) error:nil];
    NSMutableAttributedString* outString = [[NSMutableAttributedString alloc] init];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"created json data with escaped forward slashes and included quotes in JSON from test Array."]]];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@",unsupportedArray]]];
    [outString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [outString length])];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n Output is : \n%@",jsonData]]];
    [self appendToPrintBuffer:outString];
    [self printAndscrollDelegateTextViewToBottom];
}

@end
