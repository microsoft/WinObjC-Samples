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


#import "HHIngredientsCategoryTableViewCell.h"
#import "HHIngredient.h"

@interface HHIngredientsCategoryTableViewCell ()

@property UILabel *mainLabel;
@property UILabel *countLabel;

@end

@implementation HHIngredientsCategoryTableViewCell {
    IngredientSection _section;
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.mainLabel = [UILabel new];
        self.mainLabel.textColor = [UIColor whiteColor];
        self.mainLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
        self.mainLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.countLabel = [UILabel new];
        self.countLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.6];
        self.countLabel.textAlignment = NSTextAlignmentRight;
#ifdef WINOBJC
        self.countLabel.font = [UIFont systemFontOfSize:self.frame.size.height/3.0];
#else
        self.countLabel.font = [UIFont systemFontOfSize:self.frame.size.height/3.0
                                            weight:UIFontWeightUltraLight];
#endif
        self.countLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:self.mainLabel];
        [self addSubview:self.countLabel];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_countLabel, _mainLabel);
        NSDictionary *metrics = @{ @"pad": @([HHConstants contentPadding]),
                                   @"halfPad": @([HHConstants contentPadding]/2.0)};
        [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-pad-[_mainLabel]-halfPad-[_countLabel(100)]-pad-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
        [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_mainLabel]|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
        [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_countLabel]|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
#ifdef WINOBJC
    self.countLabel.font = [UIFont systemFontOfSize:self.frame.size.height/3.0];
#else
    self.countLabel.font = [UIFont systemFontOfSize:self.frame.size.height/3.0
                                             weight:UIFontWeightUltraLight];
#endif
}

- (void) drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef cxt = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(cxt, [HHConstants lineWidth]);
    CGContextSetStrokeColorWithColor(cxt, [[HHConstants sharedInstance] colorForSection:_section].CGColor);
    CGContextMoveToPoint(cxt, 0, rect.size.height - [HHConstants lineWidth]);
    CGContextAddLineToPoint(cxt, rect.size.width, rect.size.height - [HHConstants lineWidth]);
    CGContextStrokePath(cxt);
}

- (void) setUpWithSection:(IngredientSection)section
{
    _section = section;
    self.mainLabel.text = [HHConstants nameOfSection:section];
    self.mainLabel.textColor = [[HHConstants sharedInstance] colorForSection:section];
    self.countLabel.textColor = [[HHConstants sharedInstance] colorForSection:section];
    
    unsigned long count = [[HHConstants sharedInstance] ingredientsForSection:section withOption:IngredientOptionAvailable].count;
    self.countLabel.text = [NSString stringWithFormat:@"%ld", count];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
