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


#import "TDLabel.h"

@implementation TDLabel {
    bool _strikethrough;
    CALayer *_strikethroughLayer;
}

const float STRIKEOUT_THICKNESS = 2.0f;

- (id)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        _strikethroughLayer = [CALayer layer];
        _strikethroughLayer.backgroundColor = [self.textColor CGColor];
        _strikethroughLayer.hidden = YES;
        [self.layer addSublayer:_strikethroughLayer];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self resizeStrikeThrough];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self resizeStrikeThrough];
}

- (void)setTextColor:(UIColor *)textColor
{
    [super setTextColor:textColor];
    _strikethroughLayer.backgroundColor = [textColor CGColor];
}

- (void)resizeStrikeThrough
{
    CGSize textSize = [self.text sizeWithAttributes:@{NSFontAttributeName: self.font}];
    _strikethroughLayer.frame = CGRectMake(0, self.bounds.size.height/2.0 - STRIKEOUT_THICKNESS/2.0,
                                           textSize.width, STRIKEOUT_THICKNESS);
}

- (void)setStrikethrough:(bool)strikethrough
{
    _strikethrough = strikethrough;
    _strikethroughLayer.hidden = !strikethrough;
}

@end
