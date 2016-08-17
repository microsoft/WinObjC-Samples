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

@interface HHRecipe : NSObject

@property (readonly) NSString *name;
@property (readonly) NSString *recipe;
@property (readonly) UIImage *image;
@property (readonly) NSString *ingredientsString;
@property (readonly) NSArray *ingredients;
@property (readonly) NSInteger numIngredients;

+ (HHRecipe*) newRecipeFromDictionary:(NSDictionary*)dict
                 matchedToIngredients:(NSArray*)ingredients;

- (id) initWithName:(NSString*)name
             recipe:(NSString*)recipe
     numIngredients:(NSInteger)numIngredients
              image:(UIImage*)image
         dictionary:(NSMutableDictionary*)dictionary
              array:(NSMutableArray*)array;
- (NSComparisonResult) compare:(HHRecipe*)otherObject;

@end
