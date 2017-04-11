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

#import <UIKit/UIKit.h>
#import "DecodingViewController.h"
#import "JSONKit.h"

@interface DecodingViewController () {
    NSString* testString;
    JSONDecoder* decoder;
}

@end

@implementation DecodingViewController

-(void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    switch (indexPath.row) {
        case 0: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [weakSelf clearCache];
            });
            break;
        }
        case 1: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [weakSelf objectWithUTF8String];
            });
            break;
        }
        case 2: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [weakSelf mutableObjectWithUTF8String];
            });
            break;
        }
        case 3: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [weakSelf objectFromData];
            });
            break;
        }
        case 4: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [weakSelf mutableObjectFromData];
            });
            break;
        }
        default:
            break;
    }
}

- (void)viewDidLoad {
    testString = [self readJsonFrom:@"test" withExtension:@"json"];
	decoder = [JSONDecoder decoderWithParseOptions:JKParseOptionNone];
    [super viewDidLoad];
    self.buttonArray = [[NSArray alloc] initWithObjects:@"clear cache",@"objectWithUTF8String",@"mutableObjectWithUTF8String",@"objectFromData",@"mutableObjectFromData",nil];
    [self constructViewWithTableView];
    [self setTitle:@"JSON Decoder"];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self alertToCreateDecoder];
}

-(void)alertToCreateDecoder {
    UIAlertAction* alertAction1 = [UIAlertAction actionWithTitle:@"JKParseOptionNone" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        decoder = [JSONDecoder decoderWithParseOptions:JKParseOptionNone];
    }];
    UIAlertAction* alertAction2 = [UIAlertAction actionWithTitle:@"JKParseOptionStrict" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        decoder = [JSONDecoder decoderWithParseOptions:JKParseOptionStrict];
    }];
    UIAlertAction* alertAction3 = [UIAlertAction actionWithTitle:@"JKParseOptionComments" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        decoder = [JSONDecoder decoderWithParseOptions:JKParseOptionComments];
    }];
    UIAlertAction* alertAction4 = [UIAlertAction actionWithTitle:@"JKParseOptionUnicodeNewlines" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        decoder = [JSONDecoder decoderWithParseOptions:JKParseOptionUnicodeNewlines];
    }];
    UIAlertAction* alertAction5 = [UIAlertAction actionWithTitle:@"JKParseOptionLooseUnicode" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        decoder = [JSONDecoder decoderWithParseOptions:JKParseOptionLooseUnicode];
    }];
    UIAlertAction* alertAction6 = [UIAlertAction actionWithTitle:@"JKParseOptionPermitTextAfterValidJSON" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        decoder = [JSONDecoder decoderWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
    }];
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Initialize decoder " message:@"select one of the options." preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:alertAction1];
    [alertController addAction:alertAction2];
    [alertController addAction:alertAction3];
    [alertController addAction:alertAction4];
    [alertController addAction:alertAction5];
    [alertController addAction:alertAction6];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)clearCache {
    [decoder clearCache];
    NSMutableAttributedString* outString = [[NSMutableAttributedString alloc] init];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"cache cleared!."]]];
    [self appendToPrintBuffer:outString];
    [self printAndscrollDelegateTextViewToBottom];
}

-(void)objectWithUTF8String {
    id Object = [decoder objectWithUTF8String:[testString UTF8String] length:testString.length error:nil];
    NSMutableAttributedString* outString = [[NSMutableAttributedString alloc] init];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"created below object from a json string."]]];
    [outString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [outString length])];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" \n%@",Object]]];
    [self appendToPrintBuffer:outString];
    [self printAndscrollDelegateTextViewToBottom];
}

-(void)mutableObjectWithUTF8String {
    id Object = [decoder mutableObjectWithUTF8String:[testString UTF8String] length:testString.length error:nil];
    NSMutableAttributedString* outString = [[NSMutableAttributedString alloc] init];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"created below mutable object from a json string."]]];
    [outString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [outString length])];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" \n%@",Object]]];
    [self appendToPrintBuffer:outString];
    [self printAndscrollDelegateTextViewToBottom];
}

-(void)objectFromData {
    id Object = [decoder objectWithData:[testString dataUsingEncoding:NSUTF8StringEncoding]];
    NSMutableAttributedString* outString = [[NSMutableAttributedString alloc] init];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"created below object from a json data."]]];
    [outString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [outString length])];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" \n%@",Object]]];
    [self appendToPrintBuffer:outString];
    [self printAndscrollDelegateTextViewToBottom];
}

-(void)mutableObjectFromData {
    id Object = [decoder mutableObjectWithData:[testString dataUsingEncoding:NSUTF8StringEncoding]];
    NSMutableAttributedString* outString = [[NSMutableAttributedString alloc] init];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"created below mutable object from a json data."]]];
    [outString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [outString length])];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" \n%@",Object]]];
    [self appendToPrintBuffer:outString];
    [self printAndscrollDelegateTextViewToBottom];
}

@end
