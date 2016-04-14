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


#import "HHIngredientCategoriesTableViewController.h"
#import "HHIngredientsViewController.h"
#import "HHIngredient.h"
#import "HHRecipe.h"
#import "HHIngredientsCategoryTableViewCell.h"

@interface HHIngredientCategoriesTableViewController ()

@end

@implementation HHIngredientCategoriesTableViewController

static NSString * const kCellIdentifier = @"Cell";

- (instancetype) init
{
    if(self = [super init]) {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[HHIngredientsCategoryTableViewCell class]
           forCellReuseIdentifier:kCellIdentifier];
    
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [[HHConstants sharedInstance] lightBackgroundColor];
    
    [self recalculateInset];
}

- (void) recalculateInset
{
    CGFloat statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    self.tableView.contentInset = UIEdgeInsetsMake(statusHeight, 0, 0, 0);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kNumIngredientsSections;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (tableView.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height)/kNumIngredientsSections;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HHIngredientsCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier
                                                                               forIndexPath:indexPath];
    [cell setUpWithSection:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(cellSelectedWithSection:)]) {
        [self.delegate cellSelectedWithSection:indexPath.row];
    }
}

#pragma mark - Responsiveness

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id)coordinator
{
    [super viewWillTransitionToSize:size
          withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id  _Nonnull context) {
        [self recalculateInset];
    } completion:nil];
}

@end
