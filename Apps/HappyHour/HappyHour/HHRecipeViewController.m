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


#import "HHRecipeViewController.h"
#import "HHConstants.h"

@interface HHRecipeViewController ()

@end

@implementation HHRecipeViewController {
    UIScrollView *_containerScrollView;
    UIImageView *_recipeImage;
    UILabel *_recipeIngredients;
    UILabel *_ingredientsLabel;
    UILabel *_recipeInstructions;
    UILabel *_instructionsLabel;
    NSLayoutConstraint *_recipeIngredientsHeightConstraint;
    NSLayoutConstraint *_recipeInstructionsHeightConstraint;
    NSLayoutConstraint *_recipeIngredientsWidthConstraint;
    NSLayoutConstraint *_recipeInstructionsWidthConstraint;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [[HHConstants sharedInstance] lightBackgroundColor];
    self.navigationItem.title = [self.recipe.name uppercaseString];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:nil
                                                                  action:nil];
    self.navigationController.navigationBar.topItem.backBarButtonItem = backButton;
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.navigationController.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName: [UIColor darkTextColor],
                                                                     NSFontAttributeName: [UIFont boldSystemFontOfSize:[UIFont systemFontSize]]
                                                                     };
    
    _containerScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _containerScrollView.scrollEnabled = YES;
    _containerScrollView.scrollsToTop = YES;
    _containerScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _recipeImage = [[UIImageView alloc] initWithImage:self.recipe.image];
    _recipeImage.backgroundColor = [UIColor clearColor];
    _recipeImage.translatesAutoresizingMaskIntoConstraints = NO;
    
    _recipeIngredients = [UILabel new];
    _recipeIngredients.backgroundColor = [UIColor clearColor];
    _recipeIngredients.text = self.recipe.ingredientsString;
    _recipeIngredients.numberOfLines = 0;
    _recipeIngredients.lineBreakMode = NSLineBreakByWordWrapping;
    _recipeIngredients.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
    _recipeIngredients.textColor = [UIColor darkTextColor];
    _recipeIngredients.translatesAutoresizingMaskIntoConstraints = NO;
    
    _recipeInstructions = [UILabel new];
    _recipeInstructions.backgroundColor = [UIColor clearColor];
    _recipeInstructions.text = self.recipe.recipe;
    _recipeInstructions.numberOfLines = 0;
    _recipeInstructions.lineBreakMode = NSLineBreakByWordWrapping;
    _recipeInstructions.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
    _recipeInstructions.textColor = [UIColor darkTextColor];
    _recipeInstructions.translatesAutoresizingMaskIntoConstraints = NO;
    
    _ingredientsLabel = [UILabel new];
    _ingredientsLabel.backgroundColor = [UIColor clearColor];
    _ingredientsLabel.text = @"INGREDIENTS";
    _ingredientsLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    _ingredientsLabel.textColor = [UIColor lightGrayColor];
    _ingredientsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    _instructionsLabel = [UILabel new];
    _instructionsLabel.backgroundColor = [UIColor clearColor];
    _instructionsLabel.text = @"INSTRUCTIONS";
    _instructionsLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    _instructionsLabel.textColor = [UIColor lightGrayColor];
    _instructionsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:_containerScrollView];
    [_containerScrollView addSubview:_recipeImage];
    [_containerScrollView addSubview:_recipeIngredients];
    [_containerScrollView addSubview:_recipeInstructions];
    [_containerScrollView addSubview:_ingredientsLabel];
    [_containerScrollView addSubview:_instructionsLabel];

    CGFloat pad = [HHConstants contentPadding];
    CGFloat contentWidth = self.view.frame.size.width - (pad * 2.0);
    NSDictionary *views = NSDictionaryOfVariableBindings(_containerScrollView,
                                                         _recipeImage,
                                                         _ingredientsLabel,
                                                         _recipeIngredients,
                                                         _instructionsLabel,
                                                         _recipeInstructions);
    NSDictionary *metrics = @{ @"pad": @(pad),
                               @"halfPad": @(pad/2.0),
                               @"twoPad": @(pad*2.0),
                               @"threePad": @(pad*3.0),
                               @"fourPad": @(pad*4.0),
                               @"ingredientsLabelHeight": @(_ingredientsLabel.font.lineHeight),
                               @"instructionsLabelHeight": @(_instructionsLabel.font.lineHeight),
                               @"contentWidth": @(contentWidth) };
    // Container, vertical alignment
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_containerScrollView]|"
                                                                       options:0
                                                                       metrics:metrics
                                                                         views:views]];
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_containerScrollView]|"
                                                                       options:0
                                                                       metrics:metrics
                                                                         views:views]];
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[_recipeImage]-threePad-[_ingredientsLabel(ingredientsLabelHeight)]-halfPad-[_recipeIngredients]-threePad-[_instructionsLabel(instructionsLabelHeight)]-halfPad-[_recipeInstructions]-pad-|"
                                                                       options:0
                                                                       metrics:metrics
                                                                         views:views]];
    
    // Image
    NSLayoutConstraint *proportionalWidthConstraint = [NSLayoutConstraint constraintWithItem:_recipeImage
                                                                                   attribute:NSLayoutAttributeWidth
                                                                                   relatedBy:NSLayoutRelationEqual
                                                                                      toItem:_containerScrollView
                                                                                   attribute:NSLayoutAttributeWidth
                                                                                  multiplier:0.4
                                                                                    constant:0];
    proportionalWidthConstraint.priority = UILayoutPriorityDefaultHigh;
    NSLayoutConstraint *maxWidthConstraint = [NSLayoutConstraint constraintWithItem:_recipeImage
                                                                          attribute:NSLayoutAttributeWidth
                                                                          relatedBy:NSLayoutRelationLessThanOrEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                                         multiplier:1
                                                                           constant:kDrinkImageMaxSize];
    maxWidthConstraint.priority = UILayoutPriorityRequired;
    [self.view addConstraints:@[ proportionalWidthConstraint, maxWidthConstraint ]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_recipeImage
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_recipeImage
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_recipeImage
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_containerScrollView
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:0]];
    
    // Ingredients label, instructions label, ingredients and instructions horizontal constraints
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-pad-[_ingredientsLabel]-pad-|"
                                                                       options:0
                                                                       metrics:metrics
                                                                         views:views]];
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-pad-[_recipeIngredients]-pad@900-|"
                                                                       options:0
                                                                       metrics:metrics
                                                                         views:views]];
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-pad-[_instructionsLabel]-pad-|"
                                                                       options:0
                                                                       metrics:metrics
                                                                         views:views]];
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-pad-[_recipeInstructions]-pad@900-|"
                                                                       options:0
                                                                       metrics:metrics
                                                                         views:views]];
    
    // Ingredients and instructions heights/widths, keep track of to recalculate on view size change
    CGFloat ingredientsHeight = [_recipeIngredients sizeThatFits:CGSizeMake(contentWidth, MAXFLOAT)].height + pad;
    CGFloat instructionsHeight = [_recipeInstructions sizeThatFits:CGSizeMake(contentWidth, MAXFLOAT)].height + pad;
    _recipeIngredientsHeightConstraint = [NSLayoutConstraint constraintWithItem:_recipeIngredients
                                                                      attribute:NSLayoutAttributeHeight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1
                                                                       constant:ingredientsHeight];
    
    _recipeInstructionsHeightConstraint = [NSLayoutConstraint constraintWithItem:_recipeInstructions
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1
                                                                        constant:instructionsHeight];
    
    _recipeIngredientsWidthConstraint = [NSLayoutConstraint constraintWithItem:_recipeIngredients
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1
                                                                      constant:contentWidth];
    
    _recipeInstructionsWidthConstraint = [NSLayoutConstraint constraintWithItem:_recipeInstructions
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1
                                                                       constant:contentWidth];
    [self.view addConstraints:@[
                                _recipeIngredientsHeightConstraint,
                                _recipeInstructionsHeightConstraint,
                                _recipeIngredientsWidthConstraint,
                                _recipeInstructionsWidthConstraint
                                ]];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view layoutIfNeeded];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self calculateContentSize];
}

- (void) calculateContentSize
{
    CGFloat height = _recipeInstructions.frame.origin.y
        + _recipeInstructionsHeightConstraint.constant
        + ([HHConstants contentPadding]);
    _containerScrollView.contentSize = CGSizeMake(_containerScrollView.frame.size.width, height);
}

#pragma mark - Responsiveness

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id)coordinator
{
    [super viewWillTransitionToSize:size
          withTransitionCoordinator:coordinator];
    
    CGFloat pad = [HHConstants contentPadding];
    CGFloat contentWidth = size.width - (pad * 2.0);
    _recipeIngredientsWidthConstraint.constant = contentWidth;
    _recipeInstructionsWidthConstraint.constant = contentWidth;
    _recipeIngredientsHeightConstraint.constant = [_recipeIngredients sizeThatFits:CGSizeMake(contentWidth, MAXFLOAT)].height + pad;
    _recipeInstructionsHeightConstraint.constant = [_recipeInstructions sizeThatFits:CGSizeMake(contentWidth, MAXFLOAT)].height + pad;
    
    [coordinator animateAlongsideTransition:^(id  _Nonnull context) {
        [self.view layoutIfNeeded];
        [self calculateContentSize];
    } completion:nil];
}

@end
