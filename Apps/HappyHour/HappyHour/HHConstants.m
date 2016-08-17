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


#import "HHConstants.h"

@implementation HHConstants {
    NSMutableArray *_ingredients;
    NSMutableArray *_recipes;
    NSMutableDictionary *_ingredientArrayCache;
    NSMutableDictionary *_recipeArrayCache;
    NSUserDefaults *_userDefaults;
}

static HHConstants* instance = nil;

+ (HHConstants*) sharedInstance
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

+ (CGFloat) contentPadding
{
    return 16.0f;
}

+ (CGFloat) lineWidth
{
    return 1.0f;
}

+ (NSString*) nameOfSection:(IngredientSection)section
{
    switch (section) {
        case IngredientSectionLiqueur:
            return @"Liqueur";
            break;
            
        case IngredientSectionMixers:
            return @"Mixers";
            break;
            
        case IngredientSectionOther:
            return @"Other";
            break;
            
        case IngredientSectionProduce:
            return @"Produce";
            break;
            
        case IngredientSectionSpirits:
            return @"Spirits";
            break;
            
        default:
            return @"";
            break;
    }
}

- (instancetype) init
{
    if(self = [super init]) {
        // Set up colors
        _produceColor = [UIColor colorWithRed:16.0/255.0 green:124.0/255.0 blue:16.0/255.0 alpha:1.0];
        _spiritsColor = [UIColor colorWithRed:209.0/255.0 green:52.0/255.0 blue:56.0/255.0 alpha:1.0];
        _liqueurColor = [UIColor colorWithRed:255.0/255.0 green:185.0/255.0 blue:0.0/255.0 alpha:1.0];
        _mixersColor = [UIColor colorWithRed:0.0/255.0 green:99.0/255.0 blue:177.0/255.0 alpha:1.0];
        _otherColor = [UIColor colorWithRed:154.0/255.0 green:0.0/255.0 blue:137.0/255.0 alpha:1.0];
        
        _darkBackgroundColor = [UIColor colorWithRed:74.0/255.0 green:84.0/255.0 blue:89.0/255.0 alpha:1.0];
        _lightBackgroundColor = [UIColor colorWithRed:240.0/255.0 green:235.0/255.0 blue:238.0/255.0 alpha:1.0];
        
        // Set up ingredients and recipes
        _recipeArrayCache = [NSMutableDictionary new];
        _ingredientArrayCache = [NSMutableDictionary new];
        _userDefaults = [NSUserDefaults standardUserDefaults];
        
        // Read ingredients
        NSString *ingredientPath = [[NSBundle mainBundle] pathForResource:@"Ingredients" ofType:@"plist"];
        NSArray *allIngredients = [NSArray arrayWithContentsOfFile:ingredientPath];
        _ingredients = [[NSMutableArray alloc] initWithCapacity:allIngredients.count];
        for (NSDictionary *dict in allIngredients) {
            HHIngredient *newIngredient = [HHIngredient newIngredientFromDictionary:dict];
            
            // Check for stored ingredient state
            if([_userDefaults objectForKey:newIngredient.name]) {
                BOOL available = [(NSNumber*)[_userDefaults objectForKey:newIngredient.name] boolValue];
                [newIngredient setAvailable:available
                             andWriteToDisk:NO];
            }
            
            NSUInteger newIndex = [_ingredients indexOfObject:newIngredient
                                                inSortedRange:(NSRange){0, _ingredients.count}
                                                      options:NSBinarySearchingInsertionIndex
                                              usingComparator:^NSComparisonResult(HHIngredient* a, HHIngredient* b) {
                                                  return [a compare:b];
                                              }];
            
            [_ingredients insertObject:newIngredient atIndex:newIndex];
        }
        
        // Read recipes
        NSString *recipePath = [[NSBundle mainBundle] pathForResource:@"Recipes" ofType:@"plist"];
        NSArray *allRecipesArray = [NSArray arrayWithContentsOfFile:recipePath];
        _recipes = [[NSMutableArray alloc] initWithCapacity:allRecipesArray.count];
        NSUInteger count = 0;
        for (NSDictionary *dict in allRecipesArray) {
            HHRecipe *newRecipe = [HHRecipe newRecipeFromDictionary:dict
                                               matchedToIngredients:_ingredients];
            NSUInteger newIndex = [_recipes indexOfObject:newRecipe
                                            inSortedRange:(NSRange){0, count}
                                                  options:NSBinarySearchingInsertionIndex
                                          usingComparator:^NSComparisonResult(HHRecipe* a, HHRecipe* b) {
                                              return [a compare:b];
                                          }];
            
            [_recipes insertObject:newRecipe atIndex:newIndex];
            count++;
        }
        
        // TO DO: This should not be necessary, but the binary search insert above isn't working for some reason...
        [_recipes sortUsingComparator:^NSComparisonResult(HHRecipe* a, HHRecipe* b) {
            return [a compare:b];
        }];
        
        NSLog(@"Total ingredients read: %ld", (unsigned long)_ingredients.count);
        NSLog(@"Total recipes read: %ld", (unsigned long)_recipes.count);
    }
    
    return self;
}

- (UIColor*) colorForSection:(IngredientSection)section
{
    switch (section) {
        case IngredientSectionLiqueur:
            return self.liqueurColor;
            break;
            
        case IngredientSectionMixers:
            return self.mixersColor;
            break;
            
        case IngredientSectionOther:
            return self.otherColor;
            break;
            
        case IngredientSectionProduce:
            return self.produceColor;
            break;
            
        case IngredientSectionSpirits:
            return self.spiritsColor;
            break;
            
        default:
            return nil;
            break;
    }
}

#pragma mark Ingredients

- (NSArray*) ingredientsForSection:(IngredientSection)section
                        withOption:(IngredientOption)option
{
    NSString *identifier = [NSString stringWithFormat:@"%@", @(section)];
    
    // Check for cached version for arrays that aren't availability dependent
    if(option == IngredientOptionAny && [_ingredientArrayCache objectForKey:identifier]) {
        return [_ingredientArrayCache objectForKey:identifier];
    }
    
    NSPredicate *predicate;
    
    if(option == IngredientOptionAny) {
        predicate = [NSPredicate predicateWithBlock:^BOOL(HHIngredient *ingredient, NSDictionary *bindings) {
            return ingredient.section == section;
        }];
    }
    
    else if(option == IngredientOptionAvailable) {
        predicate = [NSPredicate predicateWithBlock:^BOOL(HHIngredient *ingredient, NSDictionary *bindings) {
            return ingredient.section == section && ingredient.available;
        }];
    }
    
    else if(option == IngredientOptionUnavailable) {
        predicate = [NSPredicate predicateWithBlock:^BOOL(HHIngredient *ingredient, NSDictionary *bindings) {
            return ingredient.section == section && !ingredient.available;
        }];
    }
    
    else {
        return nil;
    }
    
    NSArray *ingredientArray = [_ingredients filteredArrayUsingPredicate:predicate];
    
    // Cache for reuse if not availability dependent
    if(option == IngredientOptionAny) {
        [_ingredientArrayCache setObject:ingredientArray forKey:identifier];
    }
    
    return ingredientArray;
}

- (NSArray*) produceIngredients { return [self ingredientsForSection:IngredientSectionProduce withOption:IngredientOptionAny]; }
- (NSArray*) spiritIngredients { return [self ingredientsForSection:IngredientSectionSpirits withOption:IngredientOptionAny]; }
- (NSArray*) mixerIngredients { return [self ingredientsForSection:IngredientSectionMixers withOption:IngredientOptionAny]; }
- (NSArray*) liqueurIngredients { return [self ingredientsForSection:IngredientSectionLiqueur withOption:IngredientOptionAny]; }
- (NSArray*) otherIngredients { return [self ingredientsForSection:IngredientSectionOther withOption:IngredientOptionAny]; }
- (NSArray*) ingredientsForSection:(IngredientSection)section { return [self ingredientsForSection:section withOption:IngredientOptionAny]; }
- (NSArray*) allIngredients { return [NSArray arrayWithArray:_ingredients]; }

- (NSArray*) availableIngredients
{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(HHIngredient *ingredient, NSDictionary *bindings) {
        return ingredient.available;
    }];
    return [_ingredients filteredArrayUsingPredicate:predicate];
}

- (HHIngredient*) ingredientWithName:(NSString*)name
{
    if(!name || [name isEqualToString:@"optional"]) {
        return nil;
    }
    
    HHIngredient *ingredient = [[HHIngredient alloc] initWithName:[name capitalizedString]];
    NSUInteger index = [_ingredients indexOfObject:ingredient
                                     inSortedRange:(NSRange){0, _ingredients.count}
                                           options:NSBinarySearchingFirstEqual
                                   usingComparator:^NSComparisonResult(HHRecipe* a, HHRecipe* b) {
                                       return [a compare:b];
                                   }];
    
    return [_ingredients objectAtIndex:index];
}

- (void) updatePreferencesStatusForIngredient:(HHIngredient*)ingredient
{
    [_userDefaults setObject:@(ingredient.available)
                      forKey:ingredient.name];
    
    // Throttle disk writes
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(writePreferencesToDisk)
                                               object:nil];
    [self performSelector:@selector(writePreferencesToDisk)
               withObject:nil
               afterDelay:kDiskWriteInterval];
}

- (void) writePreferencesToDisk
{
    NSLog(@"Saved preferences to disk.");
    [_userDefaults synchronize];
}

#pragma mark Recipes

- (NSArray*) allRecipes
{
    return [NSArray arrayWithArray:_recipes];
}

- (void) recipesWithIngredients:(NSArray*)ingredients
                closenessFactor:(int)closeness
                        success:(void (^)(NSArray *matchedRecipes, NSArray *closeRecipes))success
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Check for cached version of requested array first
        NSString *identifier = [NSString stringWithFormat:@"%lu.%d", ingredients.hash, closeness];
        NSArray *arrayArray = [_recipeArrayCache objectForKey:identifier];
        if(arrayArray) {
            NSMutableArray *matchedRecipes = [arrayArray firstObject];
            NSMutableArray *closeRecipes = [arrayArray lastObject];
            dispatch_async(dispatch_get_main_queue(), ^{
                success(matchedRecipes, closeRecipes);
            });
            return;
        }
        
        NSMutableArray *matchedRecipes = [NSMutableArray new];
        NSMutableArray *closeRecipes = [NSMutableArray new];
        
        for(HHRecipe *recipe in _recipes) {
            int recipeCount = 0;
            int iterationCount = 0;
            for(HHIngredient *ingredient in recipe.ingredients) {
                // If the ingredient is in available or has an alternative that is, increase our count
                if( [ingredients containsObject:ingredient] ||
                    (ingredient.alternativeName &&
                     [ingredients containsObject:[self ingredientWithName:ingredient.alternativeName]]) ) {
                       recipeCount++;
                   }
                
                else if(recipeCount < iterationCount - closeness) {
                    break;
                }
                
                iterationCount++;
            }
            
            if(recipeCount == recipe.ingredients.count) {
                [matchedRecipes addObject:recipe];
            }
            
            else if(recipeCount >= iterationCount - closeness) {
                [closeRecipes addObject:recipe];
            }
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_recipeArrayCache setObject:@[ matchedRecipes, closeRecipes ]
                                  forKey:identifier]; // Cache generated arrays for reuse
            success(matchedRecipes, closeRecipes);
        });
    });
}

@end
