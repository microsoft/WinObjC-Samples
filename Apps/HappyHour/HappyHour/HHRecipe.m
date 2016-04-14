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


#import "HHRecipe.h"
#import "HHIngredient.h"
#import "HHContainer.h"
#import "HHConstants.h"
#import "UIColor+Additions.h"

@implementation HHRecipe {
    NSMutableDictionary *_ingredientsDictionary;
    NSMutableArray *_ingredients;
}

+ (HHRecipe*) newRecipeFromDictionary:(NSDictionary*)dict
                 matchedToIngredients:(NSArray*)ingredients
{
    NSString *name = [dict objectForKey:@"name"];
    NSString *recipe = [dict objectForKey:@"recipe"];
    
    // Generate image
    NSString *containerString = [dict objectForKey:@"glass"];
    //NSString *colorString = [dict objectForKey:@"color"];
    UIImage *image = [[HHContainer sharedInstance] getContainerWithIdentifier:containerString
                                                                      andFill:nil // colorString
                                                              withCarbonation:NO];
    
    // Generate ingredients
    NSMutableDictionary *ingredientsDictionary = [dict objectForKey:@"ingredients"];
    NSMutableArray *ingredientsUsed = [[NSMutableArray alloc] initWithCapacity:ingredientsDictionary.allKeys.count];
    for(NSString* ingredientString in ingredientsDictionary.allKeys) {
        
        if([ingredientString isEqualToString:@"optional"]) {
            continue;
        }
        
        HHIngredient *temp = [[HHIngredient alloc] initWithName:[ingredientString capitalizedString]];
        for(HHIngredient *ingredient in ingredients) {
            if(![ingredientsUsed containsObject:ingredient] && [temp compare:ingredient] == NSOrderedSame) {
                [ingredientsUsed addObject:ingredient];
                break;
            }
        }
        
    }
    
    return [[HHRecipe alloc] initWithName:name
                                   recipe:recipe
                           numIngredients:ingredientsUsed.count
                                    image:image
                               dictionary:ingredientsDictionary
                                    array:ingredientsUsed];
}

- (id) init
{
    if (self = [super init]) {
        _name = nil;
        _recipe = nil;
        _image = nil;
        _ingredientsDictionary = [NSMutableDictionary new];
        _ingredients = [NSMutableArray new];
        _numIngredients = 0;
    }
    return self;
}

- (id) initWithName:(NSString*)name
             recipe:(NSString*)recipe
     numIngredients:(NSInteger)numIngredients
              image:(UIImage*)image
         dictionary:(NSMutableDictionary*)dictionary
              array:(NSMutableArray*)array
{
    if (self = [super init]) {
        _name = name;
        _recipe = recipe;
        _image = image;
        _ingredientsDictionary = dictionary;
        _ingredients = array;
        _numIngredients = numIngredients;
    }
    return self;
}

- (NSString*) ingredientsString
{
    return [_ingredientsDictionary.allValues componentsJoinedByString:@"\n"];
}

- (NSArray*) ingredients
{
    [_ingredients sortUsingComparator:^NSComparisonResult(HHIngredient *ingredient, HHIngredient *otherIngredient) {
        // Check if the ingredient or its alternative is available
        BOOL oneAvailable = ingredient.available || [[HHConstants sharedInstance] ingredientWithName:ingredient.alternativeName].available;
        BOOL twoAvailable = otherIngredient.available || [[HHConstants sharedInstance] ingredientWithName:otherIngredient.alternativeName].available;
        return (oneAvailable && twoAvailable) ? [ingredient compare:otherIngredient] : twoAvailable;
    }];
    
    return [NSArray arrayWithArray:_ingredients];
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"%@: %ld", self.name, self.numIngredients];
}

- (NSComparisonResult) compare:(HHRecipe*)otherObject
{
    if([otherObject isMemberOfClass:[self class]]) {
        return (self.numIngredients == otherObject.numIngredients) ? [self.name compare:otherObject.name] : self.numIngredients < otherObject.numIngredients;
    }
    
    return NSOrderedSame;
}

@end
