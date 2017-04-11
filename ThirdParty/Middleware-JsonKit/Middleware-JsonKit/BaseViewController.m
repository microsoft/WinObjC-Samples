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

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)clearLogFromTextView {
    void (^block)() = ^{
        @synchronized(self) {
            _bufferedOutText = [[NSMutableAttributedString alloc] initWithString:@"\n"];
            _delegateOutputTextView.text = @"";
        }
    };
    dispatch_async(dispatch_get_main_queue(), block);
}

- (void)appendToPrintBuffer:(id)format, ... {
    va_list ap;
    va_start(ap, format);
    
    NSString* newString = [[NSString alloc] initWithFormat:[format description] arguments:ap];
    void (^block)() = ^{
        @synchronized(_bufferedOutText) {
            if ([format isKindOfClass:[NSAttributedString class]]) {
                [_bufferedOutText appendAttributedString:format];
                [_bufferedOutText appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
            }else {
                [_bufferedOutText appendAttributedString:[[NSAttributedString alloc] initWithString:newString]];
                [_bufferedOutText appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
            }
        }
    };
    dispatch_async(dispatch_get_main_queue(), block);
    va_end(ap);
}

-(void)printColoredDebugInfo:(NSString*) string using:(UIColor*)color {
    __weak typeof(self) weakSelf = self;
    NSMutableAttributedString* printString = [[NSMutableAttributedString alloc] init];
    [printString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", string]]];
    [printString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, [printString length])];
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf appendToPrintBuffer:printString];
    });
}

-(NSString*)readJsonFrom:(NSString*)file withExtension:(NSString*)extension {
    NSString *filepath = [[NSBundle mainBundle] pathForResource:file ofType:extension];
    NSError *error;
    NSString *fileContents = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
    
    if (error)
        return [NSString stringWithFormat:@"Error reading file: %@", error.localizedDescription];
    else
        return fileContents;
}

-(void)printAndscrollDelegateTextViewToBottom {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableAttributedString* textViewString = [_delegateOutputTextView.attributedText mutableCopy];
        [textViewString appendAttributedString:_bufferedOutText];
        _delegateOutputTextView.attributedText = textViewString;
        if(_bufferedOutText.length > 0 ) {
            NSRange bottom = NSMakeRange(_delegateOutputTextView.text.length -1, 1);
            [_delegateOutputTextView scrollRangeToVisible:bottom];
            _bufferedOutText = [[NSMutableAttributedString alloc] initWithString:@"\n"];
        }
    });
}

-(void)constructViewWithTableView {
    _bufferedOutText = [[NSMutableAttributedString alloc] init];
    //defines all views
    UIView* topContainer = [[UIView alloc] init];
    topContainer.translatesAutoresizingMaskIntoConstraints = false;
    [topContainer setTag:000];
    
    _APITestTableView = (UITableView*)[[UITableView alloc] init];
    [_APITestTableView setBackgroundColor:[UIColor clearColor]];
    _APITestTableView.delegate = self;
    _APITestTableView.dataSource = self;
    _APITestTableView.translatesAutoresizingMaskIntoConstraints = false;
    _APITestTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [topContainer setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:1.0]];
    [_APITestTableView setBackgroundColor:[UIColor clearColor]];
    
    
    UIView* bottomContainer = [[UIView alloc] init];
    bottomContainer.translatesAutoresizingMaskIntoConstraints = false;
    [bottomContainer setTag:111];
    
    _delegateOutputTextView = [[UITextView alloc] init];
    _delegateOutputTextView.translatesAutoresizingMaskIntoConstraints = false;
    [_delegateOutputTextView setBackgroundColor:[UIColor whiteColor]];
    [_delegateOutputTextView setEditable:NO];
    _delegateOutputTextView.delegate = self;
    
    [[self view] addSubview:topContainer];
    [[self view] addSubview:bottomContainer];
    [topContainer addSubview:_APITestTableView];
    [bottomContainer addSubview:_delegateOutputTextView];
    
    
    NSLayoutConstraint *topContainerTopLayoutConstraints = [NSLayoutConstraint constraintWithItem:[self view]
                                                                             attribute:NSLayoutAttributeTop
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:topContainer
                                                                             attribute:NSLayoutAttributeTop
                                                                            multiplier:1.f constant:0.f];
    NSLayoutConstraint *topContainerBottomLayoutConstraints = [NSLayoutConstraint constraintWithItem:topContainer
                                                                                attribute:NSLayoutAttributeBottom
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:bottomContainer
                                                                                attribute:NSLayoutAttributeTop
                                                                               multiplier:1.f constant:0.f];
    NSLayoutConstraint *topContainerLeftLayoutConstraints = [NSLayoutConstraint constraintWithItem:[self view]
                                                                              attribute:NSLayoutAttributeLeft
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:topContainer
                                                                              attribute:NSLayoutAttributeLeft
                                                                             multiplier:1.f constant:0.f];
    NSLayoutConstraint *topContainerRightLayoutConstraints = [NSLayoutConstraint constraintWithItem:[self view]
                                                                               attribute:NSLayoutAttributeRight
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:topContainer
                                                                               attribute:NSLayoutAttributeRight
                                                                              multiplier:1.f constant:0.f];
    
    NSLayoutConstraint *bottomContainerHeightLayoutConstraints = [NSLayoutConstraint constraintWithItem:bottomContainer
                                                                               attribute:NSLayoutAttributeHeight
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:nil
                                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                                              multiplier:1.f constant:350.f];
    NSLayoutConstraint *bottomContainerleftLayoutConstraints = [NSLayoutConstraint constraintWithItem:[self view]
                                                                              attribute:NSLayoutAttributeLeft
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:bottomContainer
                                                                              attribute:NSLayoutAttributeLeft
                                                                             multiplier:1.f constant:0.f];
    NSLayoutConstraint *bottomContainerRightLayoutConstraints = [NSLayoutConstraint constraintWithItem:[self view]
                                                                               attribute:NSLayoutAttributeRight
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:bottomContainer
                                                                               attribute:NSLayoutAttributeRight
                                                                              multiplier:1.f constant:0.f];
    NSLayoutConstraint *bottomContainerBottomLayoutConstraints = [NSLayoutConstraint constraintWithItem:bottomContainer
                                                                                attribute:NSLayoutAttributeBottom
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:[self view]
                                                                                attribute:NSLayoutAttributeBottom
                                                                               multiplier:1.f constant:0.f];
    
    NSDictionary *topContainerviews = NSDictionaryOfVariableBindings(_APITestTableView);
    [topContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"H:|[_APITestTableView]|" options:0 metrics:nil views:topContainerviews]];
    [topContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"V:|-40-[_APITestTableView]-0-|" options:0 metrics:nil views:topContainerviews]];
    
    NSDictionary *bottomContainerViews = NSDictionaryOfVariableBindings(_delegateOutputTextView);
    [bottomContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                  @"H:|[_delegateOutputTextView]|" options:0 metrics:nil views:bottomContainerViews]];
    [bottomContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                  @"V:|[_delegateOutputTextView]|" options:0 metrics:nil views:bottomContainerViews]];
    
    [[self view] addConstraint:topContainerTopLayoutConstraints];
    [[self view] addConstraint:topContainerBottomLayoutConstraints];
    [[self view] addConstraint:topContainerLeftLayoutConstraints];
    [[self view] addConstraint:topContainerRightLayoutConstraints];
    [[self view] addConstraint:bottomContainerHeightLayoutConstraints];
    [[self view] addConstraint:bottomContainerleftLayoutConstraints];
    [[self view] addConstraint:bottomContainerRightLayoutConstraints];
    [[self view] addConstraint:bottomContainerBottomLayoutConstraints];
    
    
    UIButton* deleteLogButton = [[UIButton alloc] init];
    [deleteLogButton setBackgroundColor:[UIColor redColor]];
    [[deleteLogButton layer] setCornerRadius:10];
    [deleteLogButton setTitle:@"clear" forState:UIControlStateNormal];
    deleteLogButton.translatesAutoresizingMaskIntoConstraints = false;
    [bottomContainer addSubview:deleteLogButton];
    [deleteLogButton addTarget:self action:@selector(clearLogFromTextView) forControlEvents:UIControlEventTouchDown];
    
    NSLayoutConstraint *topDLayoutConstraints = [NSLayoutConstraint constraintWithItem:bottomContainer
                                                                             attribute:NSLayoutAttributeTop
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:deleteLogButton
                                                                             attribute:NSLayoutAttributeTop
                                                                            multiplier:1.f constant:0.f];
    NSLayoutConstraint *widthDLayoutConstraints = [NSLayoutConstraint constraintWithItem:deleteLogButton
                                                                               attribute:NSLayoutAttributeWidth
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:nil
                                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                                              multiplier:1.f constant:60.f];
    NSLayoutConstraint *heightDLayoutConstraints = [NSLayoutConstraint constraintWithItem:deleteLogButton
                                                                                attribute:NSLayoutAttributeHeight
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:nil
                                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                                               multiplier:1.f constant:40.f];
    
    #if WINOBJC
    NSLayoutConstraint *rightDLayoutConstraints = [NSLayoutConstraint constraintWithItem:deleteLogButton
                                                                               attribute:NSLayoutAttributeRightMargin
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:bottomContainer
                                                                               attribute:NSLayoutAttributeRightMargin
                                                                              multiplier:1.f constant:-12.f];

    #else
    NSLayoutConstraint *rightDLayoutConstraints = [NSLayoutConstraint constraintWithItem:deleteLogButton
                                                                               attribute:NSLayoutAttributeRightMargin
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:bottomContainer
                                                                               attribute:NSLayoutAttributeRightMargin
                                                                              multiplier:1.f constant:0.f];

    #endif
    
    [bottomContainer addConstraint:widthDLayoutConstraints];
    [bottomContainer addConstraint:heightDLayoutConstraints];
    [bottomContainer addConstraint:topDLayoutConstraints];
    [bottomContainer addConstraint:rightDLayoutConstraints];
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return NO;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_buttonArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSAttributedString* string = [[NSAttributedString alloc] initWithString:[_buttonArray objectAtIndex:indexPath.row]];
    CGRect rect = [string boundingRectWithSize:CGSizeMake(100, 100) options:NSStringDrawingUsesDeviceMetrics context:nil];
    return rect.size.height + 40;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* cellID = @"buttonCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    [[cell textLabel] setNumberOfLines:0];
    [[cell textLabel] setText:[_buttonArray objectAtIndex:[indexPath row]]];
    [[cell textLabel] setTextAlignment:NSTextAlignmentCenter];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

@end
