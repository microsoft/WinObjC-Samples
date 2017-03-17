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

#import "StreamParserViewController.h"
#import "Helper.h"

@interface StreamParserViewController (){
    NSMutableData *data;
}

@end

@implementation StreamParserViewController

-(void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    switch (indexPath.row) {
        case 0: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [weakSelf parserWithDelegate];
            });
            break;
        }
        case 1: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [weakSelf parseInitialDataStream];
            });
            break;
        }
        case 2: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [weakSelf parseRemainingDataStream];
            });
            break;
        }
        case 3: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [weakSelf parseLargeDataStream];
            });
            break;
        }
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.buttonArray = [[NSArray alloc] initWithObjects:@"parse simple array",@"parse initial half data stream",@"parse remaining half data Stream to complete",@"parse large DataStream",nil];
    [self constructViewWithTableView];
    [self setTitle:@"SBJson5StreamParser"];
    data = [NSMutableData data];
}

-(void)parserWithDelegate {
    id parser = [SBJson5StreamParser parserWithDelegate:self];
    id data = [@"[true,false]" dataUsingEncoding:NSUTF8StringEncoding];
    SBJson5ParserStatus parseStatus = [parser parse:data];
    NSMutableString* parseStatusString = [NSMutableString stringWithFormat:@"status for parsing is : %@",[Helper convertParseStatusToString:parseStatus]];
    [self printColoredDebugInfo:parseStatusString using:[UIColor grayColor]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self printAndscrollDelegateTextViewToBottom];
    });
}

-(void)parseInitialDataStream {
    id parser = [SBJson5StreamParser parserWithDelegate:self];
    NSString* dataStringBegin = [self readJsonFrom:@"test1_begin" withExtension:@"json"];
    
    [data appendData:[dataStringBegin dataUsingEncoding:NSUTF8StringEncoding]];
    SBJson5ParserStatus parseStatus = [parser parse:data];
    NSMutableString* parseStatusString = [NSMutableString stringWithFormat:@"parsing status is : %@",[Helper convertParseStatusToString:parseStatus]];
    [self printColoredDebugInfo:parseStatusString using:[UIColor grayColor]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self printAndscrollDelegateTextViewToBottom];
    });
}

-(void)parseRemainingDataStream {
    id parser = [SBJson5StreamParser parserWithDelegate:self];
    NSString* dataStringEnd = [self readJsonFrom:@"test1_end" withExtension:@"json"];
    
    [data appendData:[dataStringEnd dataUsingEncoding:NSUTF8StringEncoding]];
    SBJson5ParserStatus parseStatus = [parser parse:data];
    NSMutableString* parseStatusString = [NSMutableString stringWithFormat:@"parsing status is : %@",[Helper convertParseStatusToString:parseStatus]];
    [self printColoredDebugInfo:parseStatusString using:[UIColor grayColor]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self printAndscrollDelegateTextViewToBottom];
    });
}

-(void)parseLargeDataStream {
    id parser = [SBJson5StreamParser parserWithDelegate:self];
    NSString* dataStringBegin = [self readJsonFrom:@"test2" withExtension:@"json"];
    
    id data = [dataStringBegin dataUsingEncoding:NSUTF8StringEncoding];
    SBJson5ParserStatus parseStatus = [parser parse:data];
    NSMutableString* parseStatusString = [NSMutableString stringWithFormat:@"status for parsing is : %@",[Helper convertParseStatusToString:parseStatus]];
    [self printColoredDebugInfo:parseStatusString using:[UIColor grayColor]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self printAndscrollDelegateTextViewToBottom];
    });
}

-(void)parserFoundObjectStart{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [weakSelf printColoredDebugInfo:@"parser found object start" using:[UIColor greenColor]];
    });
}

-(void)parserFoundNull {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [weakSelf printColoredDebugInfo:@"parser found null object" using:[UIColor orangeColor]];
    });
}

-(void)parserFoundError:(NSError *)err {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [weakSelf printColoredDebugInfo:[[NSString alloc] initWithFormat:@"parser found Error %@",err] using:[UIColor redColor]];
    });
    [data setLength:0];
}

-(void)parserFoundNumber:(NSNumber *)num {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [weakSelf printColoredDebugInfo:[[NSString alloc] initWithFormat:@"%@",num] using:[UIColor blackColor]];
    });
}

-(void)parserFoundString:(NSString *)string {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [weakSelf printColoredDebugInfo:[[NSString alloc] initWithFormat:@"%@",string] using:[UIColor blackColor]];
    });
}

-(void)parserFoundArrayEnd {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [weakSelf printColoredDebugInfo:@"]" using:[UIColor brownColor]];
    });
}

-(void)parserFoundBoolean:(BOOL)x {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [weakSelf printColoredDebugInfo:[[NSString alloc] initWithFormat:@"%@",(x ? @"true":@"false")] using:[UIColor magentaColor]];
    });
}

-(void)parserFoundObjectEnd {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [weakSelf printColoredDebugInfo:@"parser found object end" using:[UIColor greenColor]];
    });
}

-(void)parserFoundArrayStart {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
       [weakSelf printColoredDebugInfo:@"[" using:[UIColor brownColor]];
    });
}

-(void)parserFoundObjectKey:(NSString *)key {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [weakSelf printColoredDebugInfo:[[NSString alloc] initWithFormat:@"%@",key] using:[UIColor orangeColor]];
    });
}

@end
