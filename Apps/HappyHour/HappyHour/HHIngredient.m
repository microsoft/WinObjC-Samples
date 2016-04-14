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


#import "HHIngredient.h"
#import "HHContainer.h"
#import "HHConstants.h"
#import "UIColor+Additions.h"

@implementation HHIngredient

@synthesize available = _available;

+ (HHIngredient*) newIngredientFromDictionary:(NSDictionary*)dict
{
    NSString *imageString = [dict objectForKey:@"Asset"];
    NSString *nameString = [[dict objectForKey:@"Name"] capitalizedString];
    NSString *alternativeString = [[dict objectForKey:@"Alternative"] capitalizedString];
    NSString *sectionString = [dict objectForKey:@"Type"];
    BOOL carbonated = [[dict objectForKey:@"Carbonated"] boolValue];
    
    // Find appropriate image asset
    UIImage *image;
    
    // Use the name of the ingredient as the identifier if nothing specified
    if(!imageString || [imageString isEqualToString:@""] || [imageString isEqualToString:@"Photo"]) {
        image = [UIImage imageNamed:[nameString lowercaseString]];
    }
    
    // Check if we're dealing with a container image; if so, generate
    else if([[HHContainer sharedInstance] nameIsContainerType:imageString]) {
        NSString *colorString = [dict objectForKey:@"Color"];
        image = [[HHContainer sharedInstance] getContainerWithIdentifier:imageString
                                                                 andFill:[UIColor colorFromString:colorString]
                                                         withCarbonation:carbonated];
    }
    
    // Otherwise use the identifier provided
    else {
        image = [UIImage imageNamed:imageString];
    }
    
    // Find the appropriate section
    IngredientSection section = -1;
    
    if([sectionString isEqualToString:@"Liqueur"]) {
        section = IngredientSectionLiqueur;
    }
    
    else if([sectionString isEqualToString:@"Spirit"]) {
        section = IngredientSectionSpirits;
    }
    
    else if([sectionString isEqualToString:@"Mixer"]) {
        section = IngredientSectionMixers;
    }
    
    else if([sectionString isEqualToString:@"Produce"]) {
        section = IngredientSectionProduce;
    }
    
    else if([sectionString isEqualToString:@"Other"]) {
        section = IngredientSectionOther;
    }
    
    return [[HHIngredient alloc] initWithName:nameString
                              alternativeName:alternativeString
                                      section:section
                                        image:image
                                   carbonated:carbonated];
}

- (id) init
{
    if (self = [super init]) {
        _name = nil;
        _alternativeName = nil;
        _section = 0;
        _image = nil;
        _carbonated = NO;
        _available = NO;
    }
    return self;
}

- (id) initWithName:(NSString*)name
{
    if (self = [super init]) {
        _name = name;
        _alternativeName = nil;
        _section = 0;
        _image = nil;
        _carbonated = NO;
        _available = NO;
    }
    return self;
}

- (id) initWithName:(NSString*)name
    alternativeName:(NSString*)altName
            section:(IngredientSection)section
              image:(UIImage*)image
         carbonated:(BOOL)carbonated
{
    if (self = [super init]) {
        _name = name;
        _alternativeName = altName;
        _section = section;
        _image = image;
        _carbonated = carbonated;
        _available = NO;
    }
    return self;
}

- (BOOL) available
{
    return _available;
}

- (void) setAvailable:(BOOL)available
{
    if(available != _available) {
        _available = available;
        [[HHConstants sharedInstance] updatePreferencesStatusForIngredient:self]; // Save the ingredient's state
    }
}

- (void) setAvailable:(BOOL)available
       andWriteToDisk:(BOOL)persist
{
    _available = available;
    
    if(persist) {
        [[HHConstants sharedInstance] updatePreferencesStatusForIngredient:self]; // Save the ingredient's state
    }
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"%@: %@, %@", self.name, [HHConstants nameOfSection:self.section], (self.available) ? @"Available" : @"Not available"];
}

- (NSComparisonResult) compare:(HHIngredient*)otherObject
{
    if([otherObject isMemberOfClass:[self class]]) {
        return [self.name compare:otherObject.name];
    }
    
    return NSOrderedSame;
}

@end
