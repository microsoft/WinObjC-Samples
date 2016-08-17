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


#import "HHRecipesTableViewCell.h"
#import "HHConstants.h"
#import "HHIngredient.h"
#import "HHRecipe.h"

@interface HHRecipesTableViewCell ()

@end

@implementation HHRecipesTableViewCell {
    HHRecipe *_recipe;
    UILabel *_titleLabel;
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style
               reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        _titleLabel = [UILabel new];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.textColor = [UIColor darkTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
        
        [self addSubview:_titleLabel];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_titleLabel);
        NSDictionary *metrics = @{ @"pad": @([HHConstants contentPadding]) };
        [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-pad-[_titleLabel]-pad-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
        [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[_titleLabel]-pad-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    }
    
    return self;
}

- (void) drawRect:(CGRect)rect
{
    [super layoutSubviews];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat pad = 12.0f; // Spacing between indicator squares
    CGFloat size = 12.0f; // Size of indicator squares
    CGFloat dimAmount = 0.2; // Alpha of indicator squares with unavailable ingredients
    
    CGFloat originX = CGRectGetWidth(rect) - [HHConstants contentPadding];
    CGFloat originY = (CGRectGetHeight(rect)/2.0) - size/2.0;
    
    [_recipe.ingredients enumerateObjectsUsingBlock:^(HHIngredient *ingredient, NSUInteger idx, BOOL *stop) {
        BOOL available = ingredient.available ||
                            (ingredient.alternativeName &&
                             [[HHConstants sharedInstance] ingredientWithName:ingredient.alternativeName].available);
        UIColor *color = [[[HHConstants sharedInstance] colorForSection:ingredient.section] colorWithAlphaComponent:(available) ? 1.0 : dimAmount];
        CGFloat x = originX - (size * (idx + 1)) - (pad * idx);
        CGRect rectangle = CGRectMake(x, originY, size, size);
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, rectangle);
    }];
}

- (void) prepareForReuse
{
    [super prepareForReuse];
    [self setNeedsDisplay];
}

- (void) setUpCellWithRecipe:(HHRecipe*)recipe
{
    _titleLabel.text = recipe.name;
    _recipe = recipe;
}

@end
