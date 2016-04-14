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


#import "HHIngredientsCategoryCollectionView.h"
#import "HHIngredientCollectionViewCell.h"

@interface HHIngredientsCategoryCollectionView ()

@end

@implementation HHIngredientsCategoryCollectionView {
    NSArray *_ingredients;
}

static NSString * const kCellIdentifier = @"Cell";

- (instancetype) initWithFrame:(CGRect)frame
                    andSection:(IngredientSection)section
{
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.alwaysBounceVertical = YES;
        self.allowsMultipleSelection = YES;
        self.scrollsToTop = YES;
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor clearColor];
        [self registerClass:[HHIngredientCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
        
        _section = section;
        _ingredients = [[HHConstants sharedInstance] ingredientsForSection:section];
    }
    
    return self;
}

- (void) setSection:(IngredientSection)section
{
    _section = section;
    _ingredients = [[HHConstants sharedInstance] ingredientsForSection:section];
    [self reloadData];
}

#pragma mark UICollectionView Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _ingredients.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HHIngredientCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier
                                                                                     forIndexPath:indexPath];
    
    HHIngredient *ingredient = [_ingredients objectAtIndex:indexPath.row];
    
    if(ingredient.available) {
        [self selectItemAtIndexPath:indexPath
                           animated:NO
                     scrollPosition:UICollectionViewScrollPositionNone];
    }
    
    else {
        [self deselectItemAtIndexPath:indexPath
                             animated:NO];
    }
    
    [cell setUpCellWithIngredient:ingredient];
    
    return cell;
}

#pragma mark UICollectionViewDelegateFlowLayout

- (CGSize) collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
   sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat size = kIngredientCellMaxSize + 1;
    CGFloat split = 2;
    while(size > kIngredientCellMaxSize) {
        size = (collectionView.frame.size.width/split) - ([HHConstants contentPadding]*1.5);
        split++;
    }
    return CGSizeMake(size, size);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    CGFloat pad = [HHConstants contentPadding];
    return UIEdgeInsetsMake(pad, pad, pad, pad);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return [HHConstants contentPadding];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return [HHConstants contentPadding];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.frame.size.width, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.frame.size.width, 0);
}

#pragma mark <UICollectionViewDelegate>

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HHIngredientCollectionViewCell *cell = (HHIngredientCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.ingredient.available = YES;
}

- (void) collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HHIngredientCollectionViewCell *cell = (HHIngredientCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.ingredient.available = NO;
}

@end
