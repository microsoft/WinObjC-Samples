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

#import "StreamWriterViewController.h"
#import "Organization.h"

@interface StreamWriterViewController () {
    SBJson5StreamWriter* jsonWriter;
}

@end

@implementation StreamWriterViewController

-(void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    switch (indexPath.row) {
        case 0: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                BOOL writerOpen = [jsonWriter writeObject:[NSDictionary dictionaryWithObjectsAndKeys:@"sample name",@"name", nil]];
                [weakSelf OpenStreamForWriting:writerOpen];
            });
            break;
        }
        case 1: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                BOOL writerOpen = [jsonWriter writeArray:[NSArray arrayWithObjects:@"one",@"two",@"three", nil]];;
                [weakSelf OpenStreamForWriting:writerOpen];
            });
            break;
        }
        case 2: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                BOOL writerOpen = [jsonWriter writeObjectOpen];
                [weakSelf OpenStreamForWriting:writerOpen];
            });
            break;
        }
        case 3: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                BOOL writerOpen = [jsonWriter writeObjectClose];
                [weakSelf OpenStreamForWriting:writerOpen];
            });
            break;
        }
        case 4: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                BOOL writerOpen = [jsonWriter writeArrayOpen];
                [weakSelf OpenStreamForWriting:writerOpen];
            });
            break;
        }
        case 5: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                BOOL writerOpen = [jsonWriter writeArrayClose];
                [weakSelf OpenStreamForWriting:writerOpen];
            });
            break;
        }
        case 6: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                BOOL writerOpen = [jsonWriter writeNull];
                [weakSelf OpenStreamForWriting:writerOpen];
            });
            break;
        }
        case 7: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                BOOL writerOpen = [jsonWriter writeBool:true];
                [weakSelf OpenStreamForWriting:writerOpen];
            });
            break;
        }
        case 8: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                BOOL writerOpen = [jsonWriter writeNumber:[[NSNumber alloc] initWithInt:1000]];
                [weakSelf OpenStreamForWriting:writerOpen];
            });
            break;
        }
        case 9: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                BOOL writerOpen = [jsonWriter writeString:@"sample string"];
                [weakSelf OpenStreamForWriting:writerOpen];
            });
            break;
        }
        default:
            break;
    }
}

-(void)initializeWriter {
    jsonWriter = [SBJson5StreamWriter writerWithDelegate:self maxDepth:32 humanReadable:true sortKeys:true sortKeysComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [(NSString*)obj1 length] > [(NSString*)obj2 length];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.buttonArray = [[NSArray alloc] initWithObjects:@"writeObject",@"writeArray",@"writeObjectOpen",@"writeObjectClose",@"writeArrayOpen",@"writeArrayClose",@"writeNull",@"writeBool",@"writeNumber",@"writeString",nil];
    [self constructViewWithTableView];
    [self setTitle:@"SBJson5StreamWriter"];
    [self initializeWriter];
}

-(void)OpenStreamForWriting:(BOOL)currentWriterOpen {
     __weak typeof(self) weakSelf = self;
    if(!currentWriterOpen){
        [weakSelf appendToPrintBuffer:jsonWriter.error];
        [weakSelf appendToPrintBuffer:@"try again. we have opened a new stream."];
        [weakSelf initializeWriter];
    }
    [weakSelf printAndscrollDelegateTextViewToBottom];
}

-(void)writer:(SBJson5StreamWriter *)writer appendBytes:(const void *)bytes length:(NSUInteger)length {
    NSMutableAttributedString* outString = [[NSMutableAttributedString alloc] init];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"appended to writer stream with data of size :"]]];
    [outString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [outString length])];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %lu",(unsigned long)length]]];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf appendToPrintBuffer:outString];
        [weakSelf printAndscrollDelegateTextViewToBottom];
    });
}

@end
