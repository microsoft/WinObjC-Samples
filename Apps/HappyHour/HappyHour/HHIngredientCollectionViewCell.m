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


#import "HHIngredientCollectionViewCell.h"
#import "UIView+Additions.h"
#import "UIColor+Additions.h"

@interface HHIngredientCollectionViewCell ()

@end

@implementation HHIngredientCollectionViewCell {
    UIImageView *_imageView;
    UILabel *_textLabel;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        _imageView = [UIImageView new];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        
        _textLabel = [UILabel new];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textColor = [UIColor darkTextColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        _textLabel.numberOfLines = 0;
        _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:_imageView];
        [self addSubview:_textLabel];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_textLabel, _imageView);
        NSDictionary *metrics = @{ @"pad": @([HHConstants contentPadding]/2.0),
                                   @"margin": @([HHConstants contentPadding]/8.0) };
        [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-pad-[_textLabel]-pad-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
        [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[_imageView]-margin-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
        [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[_imageView]-margin-[_textLabel]-margin-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeHeight
                                                        multiplier:0.25
                                                          constant:0]];
    }
    
    return self;
}

- (void) setUpCellWithIngredient:(HHIngredient*)ingredient
{
    self.ingredient = ingredient;
    self.selected = ingredient.available;
    _imageView.image = ingredient.image;
    _textLabel.text = ingredient.name;
    
    self.layer.borderColor = [[HHConstants sharedInstance] colorForSection:ingredient.section].CGColor;
}

// Selection

- (void) setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.layer.borderWidth = (selected) ? [HHConstants lineWidth] : 0;
}

- (void) setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    self.layer.borderWidth = (highlighted) ? [HHConstants lineWidth] : 0;
}

@end
