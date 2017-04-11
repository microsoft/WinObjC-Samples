//******************************************************************************
//
// Copyright (c) 2017 Microsoft Corporation. All rights reserved.
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

#import "NSDictionarySerializeViewController.h"
#import "JSONKit.h"
#import "Helper.h"

@interface NSDictionarySerializeViewController () {
    NSDictionary* testDictionary;
}

@end

@implementation NSDictionarySerializeViewController

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
                [weakSelf serializeUnSupportedDictionaryObjectsToJSONStringWithOptionsUsingBlock];
            });
            break;
        }
        case 5: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [weakSelf serializeUnSupportedDictionaryObjectsToJSONDataWithOptionsUsingBlock];
            });
            break;
        }
        case 6: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [weakSelf serializeUnSupportedDictionaryObjectsToJSONStringWithOptionsUsingDelegate];
            });
            break;
        }
        case 7: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [weakSelf serializeUnSupportedDictionaryObjectsToJSONDataWithOptionsUsingDelegate];
            });
            break;
        }
        default:
            break;
    }
}

- (void)viewDidLoad {
    //testDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSNumber alloc] initWithInt:1],@"one",[[NSNumber alloc] initWithInt:2],@"two",[[NSNumber alloc] initWithInt:3],@"three/<>", nil];
    testDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"one",@"2",@"two",@"3",@"three/<>", nil];
    [super viewDidLoad];
    self.buttonArray = [[NSArray alloc] initWithObjects:@"convert to JSONData",@"convert to JSONDataWithOptions",@"convert to JSONString",@"convert to JSONStringWithOptions",@"convert unsupported object to JSON Data With Options Using Block",@"convert unsupported object to JSON Data With Options Using Delegate",@"convert unsupported object to JSON String With Options Using Delegate",nil];
    [self constructViewWithTableView];
    [self setTitle:@"NSDictionary Serializer"];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)serializeToJSONData{
    NSData* data = [testDictionary JSONData];
    NSMutableAttributedString* outString = [[NSMutableAttributedString alloc] init];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"created json data from test dictionary."]]];
    [outString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [outString length])];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" \n%@",data]]];
    [self appendToPrintBuffer:outString];
    [self printAndscrollDelegateTextViewToBottom];
}

-(void)serializeToJSONDataWithOptions{
    NSData* data = [testDictionary JSONDataWithOptions:JKSerializeOptionNone error:nil];
    NSMutableAttributedString* outString = [[NSMutableAttributedString alloc] init];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"created json data with pretty JSON and included quotes in JSON from test dictionary."]]];
    [outString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [outString length])];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" \n%@",data]]];
    [self appendToPrintBuffer:outString];
    [self printAndscrollDelegateTextViewToBottom];
}

-(void)serializeToJSONString{
    NSString* jsonString = [testDictionary JSONString];
    NSMutableAttributedString* outString = [[NSMutableAttributedString alloc] init];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"created json String from test dictionary. "]]];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@",testDictionary]]];
    [outString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [outString length])];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n Output is : \n%@",jsonString]]];
    [self appendToPrintBuffer:outString];
    [self printAndscrollDelegateTextViewToBottom];
}

-(void)serializeToJSONStringWithOptions{
    NSString* jsonString = [testDictionary JSONStringWithOptions:JKSerializeOptionEscapeForwardSlashes error:nil];
    NSMutableAttributedString* outString = [[NSMutableAttributedString alloc] init];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"created json data with escaped forward slashes and included quotes in JSON from test dictionary."]]];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@",testDictionary]]];
    [outString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [outString length])];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n Output is : \n%@",jsonString]]];
    [self appendToPrintBuffer:outString];
    [self printAndscrollDelegateTextViewToBottom];
}

-(void)serializeUnSupportedDictionaryObjectsToJSONStringWithOptionsUsingBlock{
    NSDictionary* unsupportedDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[Helper getAvengersOrganizationModel],@"Avengers model", nil];
    NSString* jsonString = [unsupportedDictionary JSONStringWithOptions:JKSerializeOptionNone serializeUnsupportedClassesUsingBlock:^id(id object) {
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
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"created json data with escaped forward slashes and included quotes in JSON from test dictionary."]]];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@",unsupportedDictionary]]];
    [outString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [outString length])];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n Output is : \n%@",jsonString]]];
    [self appendToPrintBuffer:outString];
    [self printAndscrollDelegateTextViewToBottom];
}

-(void)serializeUnSupportedDictionaryObjectsToJSONDataWithOptionsUsingBlock{
    NSDictionary* unsupportedDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[Helper getAvengersOrganizationModel],@"Avengers model", nil];
    NSData* jsonData = [unsupportedDictionary JSONDataWithOptions:JKSerializeOptionNone serializeUnsupportedClassesUsingBlock:^id(id object) {
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
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"created json data with escaped forward slashes and included quotes in JSON from test dictionary."]]];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@",unsupportedDictionary]]];
    [outString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [outString length])];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n Output is : \n%@",jsonData]]];
    [self appendToPrintBuffer:outString];
    [self printAndscrollDelegateTextViewToBottom];
}

-(NSString*)createJSONStringFromModel{
    return [Helper getJSONStringFromModel];
}

-(void)serializeUnSupportedDictionaryObjectsToJSONStringWithOptionsUsingDelegate{
     NSDictionary* unsupportedDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[Helper getAvengersOrganizationModel],@"Avengers model", nil];
    NSString* jsonString = [unsupportedDictionary JSONStringWithOptions:JKSerializeOptionNone serializeUnsupportedClassesUsingDelegate:self selector:@selector(createJSONStringFromModel) error:nil];
    NSMutableAttributedString* outString = [[NSMutableAttributedString alloc] init];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"created json data with escaped forward slashes and included quotes in JSON from test dictionary."]]];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@",unsupportedDictionary]]];
    [outString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [outString length])];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n Output is : \n%@",jsonString]]];
    [self appendToPrintBuffer:outString];
    [self printAndscrollDelegateTextViewToBottom];
}

-(void)serializeUnSupportedDictionaryObjectsToJSONDataWithOptionsUsingDelegate{
     NSDictionary* unsupportedDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[Helper getAvengersOrganizationModel],@"Avengers model", nil];
    NSData* jsonData = [unsupportedDictionary JSONDataWithOptions:JKSerializeOptionNone serializeUnsupportedClassesUsingDelegate:self selector:@selector(createJSONStringFromModel) error:nil];
    NSMutableAttributedString* outString = [[NSMutableAttributedString alloc] init];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"created json data with escaped forward slashes and included quotes in JSON from test dictionary."]]];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@",unsupportedDictionary]]];
    [outString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [outString length])];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n Output is : \n%@",jsonData]]];
    [self appendToPrintBuffer:outString];
    [self printAndscrollDelegateTextViewToBottom];
}

@end
