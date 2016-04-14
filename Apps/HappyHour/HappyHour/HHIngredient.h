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

typedef NS_ENUM(NSInteger, IngredientSection) {
    IngredientSectionProduce = 0,
    IngredientSectionSpirits = 1,
    IngredientSectionLiqueur = 2,
    IngredientSectionMixers = 3,
    IngredientSectionOther = 4
};

@interface HHIngredient : NSObject

@property (readonly) NSString *name;
@property (readonly) NSString *alternativeName;
@property (readonly) IngredientSection section;
@property (readonly) UIImage *image;
@property (readonly) BOOL carbonated;
@property BOOL available;

+ (HHIngredient*) newIngredientFromDictionary:(NSDictionary*)dict;

- (id) initWithName:(NSString*)name;
- (id) initWithName:(NSString*)name
    alternativeName:(NSString*)altName
            section:(IngredientSection)section
              image:(UIImage*)image
         carbonated:(BOOL)carbonated;


- (void) setAvailable:(BOOL)available
       andWriteToDisk:(BOOL)persist;
- (NSComparisonResult) compare:(HHIngredient*)otherObject;

@end