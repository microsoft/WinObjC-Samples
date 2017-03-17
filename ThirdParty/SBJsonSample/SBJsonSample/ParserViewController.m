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

#import "ParserViewController.h"
#import "Helper.h"

@interface ParserViewController () {
    SBJson5ValueBlock block;
    SBJson5ErrorBlock eh;
}

@end

@implementation ParserViewController

-(void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    switch (indexPath.row) {
        case 0: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [weakSelf parserWithBlock];
            });
            break;
        }
        case 1: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [weakSelf parserWithBlockAndAllowMultiRootunwrapRootArray];
            });
            break;
        }
        case 2: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [weakSelf multiRootParserWithBlock];
            });
            break;
        }
        case 3: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [weakSelf unwrapRootArrayParserWithBlock];
            });
            break;
        }
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeParsingBlocks];
    self.buttonArray = [[NSArray alloc] initWithObjects:@"parser with block",@"parser with block and allow multiRoot unwrap root array",@"multiRoot parser with block",@"unwrap root array Parser With block",nil];
    [self constructViewWithTableView];
    [self setTitle:@"SBJson5Parser"];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)initializeParsingBlocks{
    __weak typeof(self) weakSelf = self;
    self->block = ^(id v, BOOL *stop) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"Parsed:"];
            [text addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, 7)];
            NSMutableAttributedString* outString = [[NSMutableAttributedString alloc] init];
            [outString appendAttributedString:text];
            [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",v]]];
            [weakSelf appendToPrintBuffer:outString];
            [weakSelf printAndscrollDelegateTextViewToBottom];
        });
    };
    
    self->eh = ^(NSError* err) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableAttributedString* outString = [[NSMutableAttributedString alloc] init];
            [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"OOPS: %@", err]]];
            [outString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, [outString length])];
            [weakSelf appendToPrintBuffer:outString];
            [weakSelf printAndscrollDelegateTextViewToBottom];
        });
    };
}

-(void)parserWithBlock {
    id parser = [SBJson5Parser parserWithBlock:block errorHandler:eh];
    id data = [@"[true,false]" dataUsingEncoding:NSUTF8StringEncoding];
    [parser parse:data];
}

-(void)parserWithBlockAndAllowMultiRootunwrapRootArray {
    id parser = [SBJson5Parser parserWithBlock:block allowMultiRoot:true unwrapRootArray:true maxDepth:32 errorHandler:eh];
    
    NSString* dataStringBegin = [self readJsonFrom:@"test2" withExtension:@"json"];
    id data = [dataStringBegin dataUsingEncoding:NSUTF8StringEncoding];
    [parser parse:data];
}

-(void)multiRootParserWithBlock {
    id parser = [SBJson5Parser multiRootParserWithBlock:block errorHandler:eh];
    NSString* dataStringBegin = [self readJsonFrom:@"test1_begin" withExtension:@"json"];
    id data = [dataStringBegin dataUsingEncoding:NSUTF8StringEncoding];
    [parser parse:data];

    // ok, now we add another value and close the array
    NSString* dataStringEnd = [self readJsonFrom:@"test1_end" withExtension:@"json"];
    data = [dataStringEnd dataUsingEncoding:NSUTF8StringEncoding];
    [parser parse:data];
}

-(void)unwrapRootArrayParserWithBlock {
    id parser = [SBJson5Parser unwrapRootArrayParserWithBlock:block errorHandler:eh];
    
    NSString* dataStringBegin = [self readJsonFrom:@"test2" withExtension:@"json"];
    id data = [dataStringBegin dataUsingEncoding:NSUTF8StringEncoding];
    [parser parse:data];
}

@end
