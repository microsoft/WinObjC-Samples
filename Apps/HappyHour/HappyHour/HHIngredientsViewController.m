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


#import "UIView+Additions.h"
#import "HHIngredientsViewController.h"
#import "HHIngredientsCategoryCollectionView.h"
#import "HHRecipesTableViewController.h"

@implementation HHIngredientsViewController {
    NSMutableArray *_collectionViews; // Ingredient section collection views for main scroll view area
    NSMutableArray *_titleLabels; // Ingredient section titles for nav bar scroll area
    UIPageControl *_pageControl; // Page control in toolbar at bottom
    UIBarButtonItem *_categoriesButton; // Button to bring up list of ingredient categories
    UIBarButtonItem *_shakeButton; // Make some drinks!
    HHIngredientsCategoryCollectionView *_currentCollectionView; // Currently displayed ingredient section collection view
    UIScrollView *_containerScrollView; // Scroll view container for collection views
    UIScrollView *_titleScrollView; // Scroll view container for title labels
}

- (instancetype) init
{
    if(self = [super init]) {
        // Set up the scroll view that has all the collection views inside it
        _containerScrollView = [[UIScrollView alloc] init];
        _containerScrollView.delegate = self;
        _containerScrollView.pagingEnabled = YES;
        _containerScrollView.showsHorizontalScrollIndicator = YES;
        _containerScrollView.showsVerticalScrollIndicator = NO;
        _containerScrollView.scrollEnabled = YES;
        _containerScrollView.bounces = YES;
        _containerScrollView.backgroundColor = [UIColor clearColor];
        
        // Set up the scroll view that has all of the titles for the nav bar in it
        _titleScrollView = [[UIScrollView alloc] init];
        _titleScrollView.pagingEnabled = YES;
        _titleScrollView.showsHorizontalScrollIndicator = NO;
        _titleScrollView.showsVerticalScrollIndicator = NO;
        _titleScrollView.scrollEnabled = YES;
        _titleScrollView.userInteractionEnabled = NO;
        _titleScrollView.bounces = NO;
        _titleScrollView.backgroundColor = [UIColor clearColor];
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        _collectionViews = [NSMutableArray new];
        _titleLabels = [NSMutableArray new];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray *constraints = [NSMutableArray new];
    
    // Set up title scroll view container
    CGFloat titleWidth = 125.0f;
    CGFloat titleHeight = self.navigationController.navigationBar.frame.size.height;
    _titleScrollView.frame = CGRectMake(0, 0, titleWidth, titleHeight);
    _titleScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _titleScrollView.contentSize = CGSizeMake(kNumIngredientsSections * titleWidth, titleHeight);
    _titleScrollView.clipsToBounds = NO;
    self.navigationItem.titleView = _titleScrollView;
    
    // Set up titles
    for(int i=0; i<kNumIngredientsSections; i++) {
        CGRect frame = _titleScrollView.bounds;
        frame.origin.x = i * titleWidth;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:frame];
        titleLabel.text = [[HHConstants nameOfSection:i] uppercaseString];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
        titleLabel.textColor = [[HHConstants sharedInstance] colorForSection:i];
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.alpha = MAX(2 - ABS(titleLabel.frame.origin.x - _titleScrollView.contentOffset.x) / (_titleScrollView.frame.size.width / 2.0), 0.25);
        [_titleLabels addObject:titleLabel];
        [_titleScrollView addSubview:titleLabel];
    }
    
    // Set up scroll view container for section view controllers
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    _containerScrollView.backgroundColor = [[HHConstants sharedInstance] lightBackgroundColor];
    _containerScrollView.frame = self.view.bounds;
    _containerScrollView.contentSize = CGSizeMake(kNumIngredientsSections * width, height);
    _containerScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_containerScrollView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_containerScrollView);
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_containerScrollView]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_containerScrollView]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    
    // Set up collection views
    for(int i=0; i<kNumIngredientsSections; i++) {
        CGRect frame = self.view.bounds;
        frame.origin.x = i * width;
        HHIngredientsCategoryCollectionView *collectionView = [[HHIngredientsCategoryCollectionView alloc] initWithFrame:frame andSection:i];
        [self setInsetsForCollectionView:collectionView];
        [_collectionViews addObject:collectionView];
        [_containerScrollView addSubview:collectionView];
    }
    _currentCollectionView = [_collectionViews firstObject];
    
    // Set up bottom bar with page control, categories button
    self.navigationController.toolbarHidden = NO;
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.numberOfPages = kNumIngredientsSections;
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    UIBarButtonItem *pageContainer = [[UIBarButtonItem alloc] initWithCustomView:_pageControl];
    _categoriesButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:kListImageIdentifier]
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(categoriesButtonHandler)];
    _shakeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:kMixImageIdentifier]
                                                    style:UIBarButtonItemStylePlain
                                                   target:self
                                                   action:@selector(processIngredients)];
    self.toolbarItems = @[ _categoriesButton, flex, pageContainer, flex, _shakeButton];
    
    [self.view addConstraints:constraints];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:animated];
    
    // Make sure app chrome and scroll offset are correct for this section
    [self skinPageViewControllerAnimated:NO];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

- (void) categoriesButtonHandler
{
    HHIngredientCategoriesTableViewController *destinationVC = [[HHIngredientCategoriesTableViewController alloc] init];
    destinationVC.delegate = self;
    [self presentViewController:destinationVC
                       animated:YES
                     completion:nil];
}

- (void) processIngredients
{
    HHRecipesTableViewController *destinationVC = [[HHRecipesTableViewController alloc] init];
    [self.navigationController pushViewController:destinationVC
                                         animated:YES];
}

#pragma mark - Scroll view delegate

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView == _containerScrollView) {
        int currentIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
        [self setCurrentPageToSection:currentIndex animated:YES];
    }
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(scrollView == _containerScrollView && !decelerate) {
        int currentIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
        [self setCurrentPageToSection:currentIndex animated:YES];
    }
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == _containerScrollView) {
        CGFloat xOffset = (scrollView.contentOffset.x / scrollView.frame.size.width) * _titleScrollView.frame.size.width;
        CGFloat maxOffset = _titleScrollView.contentSize.width-_titleScrollView.frame.size.width;
        _titleScrollView.contentOffset = CGPointMake(MAX(MIN(maxOffset, xOffset), 0), 0);
        
        [_titleLabels enumerateObjectsUsingBlock:^(UILabel *titleLabel, NSUInteger idx, BOOL *block) {
            CGFloat alpha = MAX(2 - ABS(titleLabel.frame.origin.x - _titleScrollView.contentOffset.x) / (_titleScrollView.frame.size.width / 2.0), 0.25);
            titleLabel.alpha = alpha;
        }];
    }
}

#pragma mark - Utility

- (void) setInsetsForCollectionView:(HHIngredientsCategoryCollectionView*)collectionView
{
    CGFloat top = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat bottom = self.navigationController.toolbar.frame.size.height;
    collectionView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(top, 0, bottom, 0);
}

- (void) setCurrentPageToSection:(NSInteger)section
                        animated:(BOOL)animated
{
    // Update scroll view
    CGFloat containerX = section * self.view.frame.size.width;
    CGFloat titleX = section * _titleScrollView.frame.size.width;
    _containerScrollView.contentOffset = CGPointMake(containerX, 0);
    _titleScrollView.contentOffset = CGPointMake(titleX, 0);
    
    // Update current collection view pointer
    _currentCollectionView = [_collectionViews objectAtIndex:section];
    
    // Update page control
    [_pageControl setCurrentPage:section];
    
    // Update skin
    [self skinPageViewControllerAnimated:animated];
}

- (void) skinPageViewControllerAnimated:(BOOL)animated;
{
    NSInteger section = _currentCollectionView.section;
    
#ifndef WINOBJC
    if(animated) {
        CATransition *fadeAnimation = [CATransition animation];
        fadeAnimation.duration = ANIM_DURATION_NOBOUNCE;
        fadeAnimation.type = kCATransitionFade;
        [self.navigationController.navigationBar.layer addAnimation:fadeAnimation forKey: @"fadeAnimation"];
        [self.navigationController.toolbar.layer addAnimation:fadeAnimation forKey: @"fadeAnimation"];
    }
    
    self.navigationController.navigationBar.tintColor = [[HHConstants sharedInstance] colorForSection:section];
    self.navigationController.toolbar.tintColor = [[HHConstants sharedInstance] colorForSection:section];
#endif
    
    _pageControl.currentPageIndicatorTintColor = [[HHConstants sharedInstance] colorForSection:section];
}

- (BOOL) canBecomeFirstResponder
{
    return YES;
}

- (void) motionEnded:(UIEventSubtype)motion
           withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake) {
        [self processIngredients];
    }
}

#pragma mark - Ingredient categories table view delegate

- (void) cellSelectedWithSection:(IngredientSection)section
{
    [self setCurrentPageToSection:section animated:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Responsiveness

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id)coordinator
{
    [super viewWillTransitionToSize:size
          withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id  _Nonnull context) {
        // Update container scroll view size and offset and title scroll view offset
        _containerScrollView.contentSize = CGSizeMake(kNumIngredientsSections * size.width, size.height);
        _containerScrollView.contentOffset = CGPointMake([_collectionViews indexOfObject:_currentCollectionView] * size.width, 0);
        _titleScrollView.contentOffset = CGPointMake([_collectionViews indexOfObject:_currentCollectionView] * _titleScrollView.frame.size.width, 0);
        
        // Update title alphas to reflect new offset
        [_titleLabels enumerateObjectsUsingBlock:^(UILabel *titleLabel, NSUInteger idx, BOOL *block) {
            CGFloat alpha = MAX(2 - ABS(titleLabel.frame.origin.x - _titleScrollView.contentOffset.x) / (_titleScrollView.frame.size.width / 2.0), 0.25);
            titleLabel.alpha = alpha;
        }];
        
        // Update collection views with proper insets and frame and invalidate its layout so cell sizes are recalculated
        [_collectionViews enumerateObjectsUsingBlock:^(HHIngredientsCategoryCollectionView *collectionView, NSUInteger idx, BOOL *stop){
            [self setInsetsForCollectionView:collectionView];
            CGRect frame = CGRectMake(idx * size.width, 0, size.width, size.height);
            collectionView.frame = frame;
            [collectionView.collectionViewLayout invalidateLayout];
        }];
    } completion:nil];
}

@end
