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


#import "HHContainer.h"
#import "UIColor+additions.h"

@implementation HHContainer {
    NSMutableDictionary *_containerCache;
    NSArray *_containerNames;
    UIImage *_carbonatedImage;
}

static HHContainer* instance = nil;

+ (HHContainer*) sharedInstance
{
    if(instance == nil) {
        instance = [HHContainer new];
    }
    
    return instance;
}

- (instancetype) init
{
    if(self = [super init]) {
        _carbonatedImage = [UIImage imageNamed:@"bubbles"];
        _containerCache = [NSMutableDictionary new];
        _containerNames = @[
                            @"beer",
                            @"big bottle",
                            @"brandy",
                            @"carafe",
                            @"champagne",
                            @"cocktail",
                            @"collins",
                            @"highball",
                            @"lowball",
                            @"martini",
                            @"shot",
                            @"small bottle",
                            @"wine"
                            ];
    }
    
    return self;
}

- (BOOL) nameIsContainerType:(NSString*)name
{
    for(NSString *str in _containerNames) {
        if ([str isEqualToString:name]) {
            return YES;
        }
    }
    
    return NO;
}

- (UIImage*) getContainerWithIdentifier:(NSString*)containerName
                                andFill:(UIColor*)color
                        withCarbonation:(BOOL)carbonated
{
    // Check to make sure we have a valid container identifier
    if(![self nameIsContainerType:containerName]) {
        return [UIImage new];
    }
    
    // Check if we have a cached version of the requested container
    NSString *cacheIdentifier = [NSString stringWithFormat:@"%@.%lu.%d", containerName, (unsigned long)color.hash, carbonated];
    UIImage *newImage;
    if((newImage = [_containerCache objectForKey:cacheIdentifier])) {
        return newImage;
    }
    
    // Grab foreground (container) and background (fill) images
    UIImage *fgImage = [UIImage imageNamed:containerName];
    UIImage *bgImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@ %@", containerName, @"fill"]];
    
    // If we don't have a color, just return the container
    if(!color) {
        return fgImage;
    }
    
    // If we have a clear color, darken it a bit
    if([color isEqualToColor:[UIColor clearColor]]) {
        color = [UIColor colorWithWhite:0.7 alpha:0.3];
    }
    
    // Check to make sure we successfully grabbed the image resources
    if(!fgImage || !bgImage) {
        return [UIImage new];
    }
    
    // Begin the rendering process
    UIGraphicsBeginImageContextWithOptions(bgImage.size, FALSE, 0.0);
    
    // Get a reference to that context we created and our bounding rect
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, bgImage.size.width, bgImage.size.height);
    
    // CG translation/scale
    CGContextTranslateCTM(context, 0, bgImage.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // Draw the foreground (container) image
    CGContextSetAlpha(context, 0.5);
    CGContextDrawImage(context, rect, fgImage.CGImage);

    // Draw the background (fill) image
    CGContextSetAlpha(context, 1.0);
    CGContextDrawImage(context, rect, bgImage.CGImage);
    
    // Color the image with the specified color
    CGContextBeginTransparencyLayer(context, NULL);
    [color setFill];
    CGContextClipToMask(context, rect, bgImage.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context, kCGPathFill);
    
    // Carbonate if specified
    if(carbonated) {
        CGFloat scale = bgImage.size.height / _carbonatedImage.size.height;
        CGFloat x = (bgImage.size.width / 2.0) - ((_carbonatedImage.size.width * scale) / 2.0);
        CGFloat y = (![containerName isEqualToString:@"big bottle"] &&
                     ![containerName isEqualToString:@"beer"] &&
                     ![containerName isEqualToString:@"champagne"]
                    ) ? -bgImage.size.height/4.0 : 0; // Shimmy the bubbles down for smaller containers
        CGRect bubblesRect = CGRectMake(x, y, _carbonatedImage.size.width * scale, _carbonatedImage.size.height * scale);
        CGContextSetAlpha(context, 0.9);
        CGContextSetBlendMode(context, kCGBlendModeOverlay);
        CGContextDrawImage(context, bubblesRect, _carbonatedImage.CGImage);
    }
    
    CGContextEndTransparencyLayer(context);
    
    // Draw the foreground (container) image again
    CGContextSetAlpha(context, 0.5);
    CGContextDrawImage(context, rect, fgImage.CGImage);
    
    
    // Generate image, end context
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Cache for reuse
    [_containerCache setObject:newImage forKey:cacheIdentifier];
    
    return newImage;
}

@end
