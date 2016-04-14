//******************************************************************************
//
// Copyright (c) 2016 Microsoft Corporation. All rights reserved.
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


#import "TDInputTableViewCell.h"

@implementation TDInputTableViewCell {
    UITextField *_textInput;
    CALayer *_underlineLayer;
}

const float INPUT_LEFT_MARGIN = 15.0f;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        // Set up input
        _textInput = [[UITextField alloc] initWithFrame:CGRectNull];
        _textInput.placeholder = @"New to do...";
        _textInput.textAlignment = NSTextAlignmentLeft;
        _textInput.textColor = [UIColor blackColor];
        _textInput.font = [UIFont systemFontOfSize:16];
        _textInput.delegate = self; // Capture enter event for new to do item
        [self addSubview:_textInput];
        
        // Set up bottom separator
        _underlineLayer = [CALayer layer];
        _underlineLayer.backgroundColor = [[UIColor lightGrayColor] CGColor];
        [self.layer addSublayer:_underlineLayer];
        
        // Clear default selection style
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _textInput.frame = CGRectMake(INPUT_LEFT_MARGIN, 0,
                              self.bounds.size.width - (INPUT_LEFT_MARGIN * 2), self.bounds.size.height);
    
    _underlineLayer.frame = CGRectMake(0, self.bounds.size.height-1.0, self.bounds.size.width, 1.0);
}

#pragma mark - Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // Dismiss keyboard if text field is empty; otherwise notify the delegate that a new item has been created
    if([textField.text isEqualToString:@""]) {
        [_textInput resignFirstResponder];
    }
    
    else {
        [self.delegate toDoItemAdded:[TDItem toDoItemWithText:textField.text]];
        textField.text = @"";
    }
    
    return NO;
}

@end
