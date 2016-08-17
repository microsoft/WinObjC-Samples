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


#import "HHRecipesTableViewController.h"
#import "HHConstants.h"
#import "HHRecipeViewController.h"
#import "HHIngredient.h"
#import "HHRecipe.h"
#import "HHRecipesTableViewCell.h"

@interface HHRecipesTableViewController ()

@end

@implementation HHRecipesTableViewController {
    NSArray *_matchedRecipes;
    NSArray *_closeRecipes;
}

static NSString * const kCellIdentifier = @"Cell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame
                                                  style:UITableViewStyleGrouped];
    
    [self.tableView registerClass:[HHRecipesTableViewCell class]
           forCellReuseIdentifier:kCellIdentifier];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [[HHConstants sharedInstance] lightBackgroundColor];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:nil
                                                                  action:nil];
    self.navigationController.navigationBar.topItem.backBarButtonItem = backButton;
    self.navigationItem.title = @"RECIPES";
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.navigationController.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName: [UIColor darkTextColor],
                                                                     NSFontAttributeName: [UIFont boldSystemFontOfSize:[UIFont systemFontSize]]
                                                                     };
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Refresh matched recipes
    [[HHConstants sharedInstance] recipesWithIngredients:[[HHConstants sharedInstance] availableIngredients]
                                         closenessFactor:kDrinkClosenessFactor
                                                 success:^(NSArray *matchedRecipes, NSArray *closeRecipes) {
                                                     _matchedRecipes = matchedRecipes;
                                                     _closeRecipes = closeRecipes;
                                                     [self.tableView reloadData];
                                                     
                                                     // Set up empty state if no recipes matched
                                                     if(_matchedRecipes.count == 0 && _closeRecipes.count == 0) {
                                                         UILabel *noRecipesLabel = [UILabel new];
                                                         noRecipesLabel.text = kNoRecipesMessage;
                                                         noRecipesLabel.backgroundColor = [UIColor clearColor];
                                                         noRecipesLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
                                                         noRecipesLabel.textColor = [UIColor lightGrayColor];
                                                         noRecipesLabel.textAlignment = NSTextAlignmentCenter;
                                                         noRecipesLabel.numberOfLines = 0;
                                                         noRecipesLabel.lineBreakMode = NSLineBreakByWordWrapping;
                                                         noRecipesLabel.translatesAutoresizingMaskIntoConstraints = NO;
                                                         
                                                         self.tableView.scrollEnabled = NO;
                                                         [self.view addSubview:noRecipesLabel];
                                                         
                                                         NSDictionary *views = NSDictionaryOfVariableBindings(noRecipesLabel);
                                                         NSDictionary *metrics = @{ @"pad": @([HHConstants contentPadding]),
                                                                                    @"size": @(self.view.frame.size.width - ([HHConstants contentPadding] * 2.0))};
                                                         
                                                         [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=pad)-[noRecipesLabel(size)]-(>=pad)-|"
                                                                                                                           options:0
                                                                                                                           metrics:metrics
                                                                                                                             views:views]];
                                                         [self.view addConstraint:[NSLayoutConstraint constraintWithItem:noRecipesLabel
                                                                                                               attribute:NSLayoutAttributeCenterX
                                                                                                               relatedBy:NSLayoutRelationEqual
                                                                                                                  toItem:self.view
                                                                                                               attribute:NSLayoutAttributeCenterX
                                                                                                              multiplier:1
                                                                                                                constant:0]];
                                                         [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[noRecipesLabel(==size)]-(>=pad)-|"
                                                                                                                           options:0
                                                                                                                           metrics:metrics
                                                                                                                             views:views]];
                                                     }
                                                 }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_closeRecipes.count > 0 && _matchedRecipes.count > 0) {
        return 2;
    }
    
    else if(_closeRecipes.count > 0 || _matchedRecipes.count > 0) {
        return 1;
    }
    
    else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_closeRecipes.count > 0 && _matchedRecipes.count > 0) {
        return (section == 0) ? _matchedRecipes.count : _closeRecipes.count;
    }
    
    else if(_matchedRecipes.count > 0) {
        return _matchedRecipes.count;
    }
    
    else if(_closeRecipes.count > 0) {
        return _closeRecipes.count;
    }
    
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kHeaderCellHeight;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kRecipeCellHeight;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, [self tableView:tableView heightForHeaderInSection:section])];
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.text = [[self tableView:tableView titleForHeaderInSection:section] uppercaseString];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [headerView addSubview:titleLabel];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(titleLabel);
    NSDictionary *metrics = @{ @"pad": @([HHConstants contentPadding]),
                               @"height": @(titleLabel.font.lineHeight) };
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-pad-[titleLabel]-pad-|"
                                                                       options:0
                                                                       metrics:metrics
                                                                         views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[titleLabel(height)]-pad-|"
                                                                       options:0
                                                                       metrics:metrics
                                                                         views:views]];
    
    return headerView;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(_closeRecipes.count > 0 && _matchedRecipes.count > 0) {
        return (section == 0) ? kReadyDrinksString : kCloseDrinksString;
    }
    
    else if(_matchedRecipes.count > 0) {
        return kReadyDrinksString;
    }
    
    else if(_closeRecipes.count > 0) {
        return kCloseDrinksString;
    }
    
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HHRecipesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier
                                                                   forIndexPath:indexPath];
    
    if(indexPath.section == 1 || (_closeRecipes.count > 0 && _matchedRecipes.count == 0)) {
        [cell setUpCellWithRecipe:[_closeRecipes objectAtIndex:indexPath.row]];
    }
    
    else if(_closeRecipes.count > 0) {
        [cell setUpCellWithRecipe:[_matchedRecipes objectAtIndex:indexPath.row]];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HHRecipeViewController *destinationVC = [[HHRecipeViewController alloc] init];
    
    if(indexPath.section == 1 || (indexPath.section==0 && _matchedRecipes.count==0)) {
        destinationVC.recipe = [_closeRecipes objectAtIndex:indexPath.row];
    }
    else {
        destinationVC.recipe = [_matchedRecipes objectAtIndex:indexPath.row];
    }
    
    [self.navigationController pushViewController:destinationVC
                                         animated:YES];
}

#pragma mark - Responsiveness

//- (void)viewWillTransitionToSize:(CGSize)size
//       withTransitionCoordinator:(id)coordinator
//{
//    [super viewWillTransitionToSize:size
//          withTransitionCoordinator:coordinator];
//    
//    [coordinator animateAlongsideTransition:^(id  _Nonnull context) {
//    
//    } completion:nil];
//}

@end
