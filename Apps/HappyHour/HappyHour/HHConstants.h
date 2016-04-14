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


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HHIngredient.h"
#import "HHRecipe.h"

typedef NS_ENUM(NSInteger, IngredientOption) {
    IngredientOptionAny = 0,
    IngredientOptionAvailable = 1,
    IngredientOptionUnavailable = 2
};

// Utility constants
static NSString * const kMixImageIdentifier = @"mix";
static NSString * const kListImageIdentifier = @"list";
static NSString * const kIngredientAvailabilityIdentifier = @"list";
static NSInteger const kNumIngredientsSections = 5;
static CGFloat const kDiskWriteInterval = 2.5f;

// Recipes constants
static NSString * const kReadyDrinksString = @"Ready to make";
static NSString * const kCloseDrinksString = @"Close but no cigar";
static NSString * const kNoRecipesMessage = @"No recipes found. Try selecting some more ingredients.";
static NSInteger const kDrinkClosenessFactor = 1;

// Sizing constants
static CGFloat const kDrinkImageMaxSize = 200.0f;
static CGFloat const kHeaderCellHeight = 60.0f;
static CGFloat const kRecipeCellHeight = 60.0f;
static CGFloat const kIngredientCellMaxSize = 220.0f;

@interface HHConstants : NSObject

// Colors
@property (readonly) UIColor* produceColor;
@property (readonly) UIColor* spiritsColor;
@property (readonly) UIColor* liqueurColor;
@property (readonly) UIColor* mixersColor;
@property (readonly) UIColor* otherColor;
@property (readonly) UIColor* darkBackgroundColor;
@property (readonly) UIColor* lightBackgroundColor;

// Ingredients
@property (readonly) NSArray* produceIngredients;
@property (readonly) NSArray* spiritIngredients;
@property (readonly) NSArray* liqueurIngredients;
@property (readonly) NSArray* mixerIngredients;
@property (readonly) NSArray* otherIngredients;
@property (readonly) NSArray* availableIngredients;
@property (readonly) NSArray* allIngredients;

// Recipes
@property (readonly) NSArray* allRecipes;

///////////////////
// Class methods //
///////////////////

+ (HHConstants*) sharedInstance;
+ (CGFloat) lineWidth;
+ (CGFloat) contentPadding;
+ (NSString*) nameOfSection:(IngredientSection)section;

//////////////////////
// Instance methods //
//////////////////////

- (UIColor*) colorForSection:(IngredientSection)section;

// Ingredients
- (NSArray*) ingredientsForSection:(IngredientSection)section;
- (NSArray*) ingredientsForSection:(IngredientSection)section
                        withOption:(IngredientOption)option;
- (HHIngredient*) ingredientWithName:(NSString*)name;
- (void) updatePreferencesStatusForIngredient:(HHIngredient*)ingredient;

// Recipes
- (void) recipesWithIngredients:(NSArray*)ingredients
                closenessFactor:(int)closeness
                        success:(void (^)(NSArray *matchedRecipes, NSArray *closeRecipes))success;

@end
