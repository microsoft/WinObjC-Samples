//******************************************************************************
//
// Copyright (c) Microsoft. All rights reserved.
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

#import "DemoScenarioTextToPath.h"
#import <CoreGraphics/CoreGraphics.h>
#import <CoreText/CoreText.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DrawnPoly : NSObject
@end

// A container for a sorted, finalized set of "zoomed" characters
@implementation DrawnPoly {
@public
    // The sorted polygons to draw
    NSMutableArray* _polyPaths;
    // The front facing characters to be drawn
    CGPathRef _frontPath;
    // The drawing modes for each set of paths to draw
    CGPathDrawingMode _zoomMode;
    CGPathDrawingMode _frontMode;
    CGPoint _startPoint;
}
@end

@interface ThreeDPoly : NSObject
- (id)initWithAngle:(CGFloat)angle pointToDraw:(CGPoint)firstPoint connectingPoint:(CGPoint)secondPoint;
@end

@implementation ThreeDPoly {
@public
    CGFloat grayScale;
    CGPoint point1;
    CGPoint point2;
}
- (id)initWithAngle:(CGFloat)angle pointToDraw:(CGPoint)firstPoint connectingPoint:(CGPoint)secondPoint {
    if (self = [super init]) {
        grayScale = angle;
        point1 = firstPoint;
        point2 = secondPoint;
    }
    return self;
}
@end

@interface PolyPathWithColors : NSObject
- (id)initWithPath:(CGPathRef)polyPath r:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue;
@end

// A single polygon object with its own set of colors to be drawn with
@implementation PolyPathWithColors {
@public
    CGPathRef path;
    CGFloat r;
    CGFloat g;
    CGFloat b;
}

- (id)initWithPath:(CGPathRef)polyPath r:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue {
    if (self = [super init]) {
        path = polyPath;
        r = red;
        g = green;
        b = blue;
    }
    return self;
}
@end

@implementation DemoScenarioTextToPath {
    // An array of all zoomed text
    NSMutableArray<DrawnPoly*>* _allZoomText;
    // The original bounds this scenario is drawn with to use for scaling the pre-calculated polygons
    CGSize _originalBounds;
};

- (id)init {
    if (self = [super init]) {
        _originalBounds = CGSizeZero;
    }
    return self;
}

- (NSString*)name {
    return @"Text To Path";
}

- (UIColor*)backgroundColor {
    return [UIColor colorWithRed:.6 green:.85 blue:1 alpha:1];
}

// Create a pre-calculated set of characters with zoomed text
- (DrawnPoly*)drawZoomTextWithContext:(CGContextRef)context
                               string:(NSString*)string
                                 font:(CTFontRef)font
                               bounds:(CGRect)bounds
                           startPoint:(CGPoint)startPoint
                              toPoint:(CGPoint)toPoint
                                    r:(CGFloat)r
                                    g:(CGFloat)g
                                    b:(CGFloat)b
                            frontMode:(CGPathDrawingMode)frontMode
                             zoomMode:(CGPathDrawingMode)zoomMode {
    connectingPoint = CGPointZero;
    if (_originalBounds.width == 0) {
        _originalBounds.width = bounds.size.width;
    }
    if (_originalBounds.height == 0) {
        _originalBounds.height = bounds.size.height;
    }
    CGContextSaveGState(context);
    CGRect boundingPath = CGRectMake(0, 0, 0, 0);
    NSMutableArray* threeDPoints = [[NSMutableArray alloc] init];
    CGAffineTransform pathTransform = CGAffineTransformIdentity;
    CGMutablePathRef allGlyphPaths = CGPathCreateMutable();

    // Convert each glyph in the text to a path object
    for (int characterIndex = 0; characterIndex < [string length]; characterIndex++) {
        CGGlyph glyph;
        UniChar theChar = [string characterAtIndex:characterIndex];
        if (CTFontGetGlyphsForCharacters(font, &theChar, &glyph, 1)) {
            pathTransform = CGAffineTransformTranslate(pathTransform, boundingPath.size.width * 1.1, 0);
            CGPathRef path = CTFontCreatePathForGlyph(font, glyph, &pathTransform);
            CGPathAddPath(allGlyphPaths, NULL, path);
            boundingPath = CGPathGetPathBoundingBox(path);

            CGPathApply(path, (__bridge void*)threeDPoints, CGPathApplyCallback);
            CGPathRelease(path);
        }
    }

    // Sort which zoom polygon to draw first from vertical perspective
    for (int polyIndex1 = 0; polyIndex1 < [threeDPoints count]; polyIndex1++) {
        for (int polyIndex2 = 1; polyIndex2 < [threeDPoints count]; polyIndex2++) {
            ThreeDPoly* poly1 = [threeDPoints objectAtIndex:polyIndex1];
            ThreeDPoly* poly2 = [threeDPoints objectAtIndex:polyIndex2];
            if (toPoint.y < 0) {
                if (poly2->point1.y < poly1->point1.y || poly2->point2.y < poly1->point2.y) {
                    [threeDPoints replaceObjectAtIndex:polyIndex1 withObject:poly2];
                    [threeDPoints replaceObjectAtIndex:polyIndex2 withObject:poly1];
                }
            } else {
                if (poly2->point1.y > poly1->point1.y || poly2->point2.y > poly1->point2.y) {
                    [threeDPoints replaceObjectAtIndex:polyIndex1 withObject:poly2];
                    [threeDPoints replaceObjectAtIndex:polyIndex2 withObject:poly1];
                }
            }
        }
    }

    // Sort which zoom polygon to draw first from a horizontal perspective.
    for (int i = 0; i < [threeDPoints count]; i++) {
        for (int j = 1; j < [threeDPoints count]; j++) {
            ThreeDPoly* poly1 = [threeDPoints objectAtIndex:i];
            ThreeDPoly* poly2 = [threeDPoints objectAtIndex:j];
            if (fabs((startPoint.x + toPoint.x) / 2.0 - poly1->point1.x) > fabs((startPoint.x + toPoint.x) / 2.0 - poly2->point1.x)) {
                [threeDPoints replaceObjectAtIndex:i withObject:poly2];
                [threeDPoints replaceObjectAtIndex:j withObject:poly1];
            }
        }
    }

    DrawnPoly* poly = [[DrawnPoly alloc] init];
    poly->_polyPaths = [[NSMutableArray alloc] init];
    // Draw the polygons to a path
    for (int k = 0; k < [threeDPoints count]; k++) {
        ThreeDPoly* polyToDraw = [threeDPoints objectAtIndex:k];

        CGMutablePathRef polyPath = CGPathCreateMutable();
        CGPathMoveToPoint(polyPath, NULL, (polyToDraw->point1.x + toPoint.x) / 2.0, (polyToDraw->point1.y + toPoint.y) / 2.0);
        CGPathAddLineToPoint(polyPath, NULL, (polyToDraw->point2.x + toPoint.x) / 2.0, (polyToDraw->point2.y + toPoint.y) / 2.0);
        CGPathAddLineToPoint(polyPath, NULL, polyToDraw->point2.x, polyToDraw->point2.y);
        CGPathAddLineToPoint(polyPath, NULL, polyToDraw->point1.x, polyToDraw->point1.y);
        CGPathCloseSubpath(polyPath);

        [poly->_polyPaths addObject:[[PolyPathWithColors alloc] initWithPath:polyPath
                                                                           r:r * polyToDraw->grayScale
                                                                           g:g * polyToDraw->grayScale
                                                                           b:b * polyToDraw->grayScale]];
    }

    poly->_frontPath = allGlyphPaths;
    poly->_frontMode = frontMode;
    poly->_zoomMode = zoomMode;
    poly->_startPoint = startPoint;
    return poly;
}

// Create all of the zoom text only once according to this method
- (NSMutableArray*)createAllZoomText:(CGContextRef)context bounds:(CGRect)bounds {
    // Different fonts to show off different paths
    CTFontRef arialFont = CTFontCreateWithName((__bridge CFStringRef) @"Arial Bold", bounds.size.height * .15, NULL);
    CTFontRef gillFont = CTFontCreateWithName((__bridge CFStringRef) @"Palatino", bounds.size.height * .15, NULL);
    CTFontRef parchmentFont = CTFontCreateWithName((__bridge CFStringRef) @"Papyrus", bounds.size.height * .15, NULL);
    CFAutorelease(arialFont);
    CFAutorelease(gillFont);
    CFAutorelease(parchmentFont);

    NSMutableArray* allText = [[NSMutableArray alloc] init];

    // Create all path objects
    DrawnPoly* coreGraphicsPreDrawn = [self drawZoomTextWithContext:context
                                                             string:@"CoreGraphics"
                                                               font:gillFont
                                                             bounds:bounds
                                                         startPoint:CGPointMake(bounds.size.width * .1, bounds.size.height * .75)
                                                            toPoint:CGPointMake(bounds.size.width * .4, -bounds.size.height * .15)
                                                                  r:.5
                                                                  g:.1
                                                                  b:1
                                                          frontMode:kCGPathFillStroke
                                                           zoomMode:kCGPathFillStroke];
    DrawnPoly* winOBJCPreDrawn = [self drawZoomTextWithContext:context
                                                        string:@"WinOBJC"
                                                          font:arialFont
                                                        bounds:bounds
                                                    startPoint:CGPointMake(bounds.size.width * .2, bounds.size.height * .55)
                                                       toPoint:CGPointMake(bounds.size.width * .35, bounds.size.height * .05)
                                                             r:1
                                                             g:1
                                                             b:1
                                                     frontMode:kCGPathEOFillStroke
                                                      zoomMode:kCGPathEOFillStroke];

    DrawnPoly* coreTextPreDrawn = [self drawZoomTextWithContext:context
                                                         string:@"CoreText"
                                                           font:parchmentFont
                                                         bounds:bounds
                                                     startPoint:CGPointMake(bounds.size.width * .15, bounds.size.height * .35)
                                                        toPoint:CGPointMake(bounds.size.width * .3, bounds.size.height * .15)
                                                              r:1
                                                              g:.1
                                                              b:.5
                                                      frontMode:kCGPathFillStroke
                                                       zoomMode:kCGPathFill];

    // Add all path objects to an array
    [allText addObject:coreGraphicsPreDrawn];
    [allText addObject:winOBJCPreDrawn];
    [allText addObject:coreTextPreDrawn];

    return allText;
}

- (void)drawDemoIntoContext:(CGContextRef)context withFrame:(CGRect)bounds {
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CGContextTranslateCTM(context, bounds.size.width * .05, -bounds.size.height * 1.1);
    CGContextSaveGState(context);

    CGContextSetLineWidth(context, 1.0);

    // Only create the paths one time since the sorting and recreation of every path is expensive
    // Cannot be done in init as a context is needed
    if (_allZoomText == nil) {
        _allZoomText = [self createAllZoomText:context bounds:bounds];
    }

    // Calculate the scale to transform the paths by since they've only been created once
    CGAffineTransform windowScale = CGAffineTransformIdentity;
    windowScale =
        CGAffineTransformScale(windowScale, bounds.size.width / _originalBounds.width, bounds.size.height / _originalBounds.height);
    windowScale =
        CGAffineTransformTranslate(windowScale, bounds.size.width - _originalBounds.width, bounds.size.height - _originalBounds.height);
    for (int i = 0; i < _allZoomText.count; i++) {
        CGContextSaveGState(context);
        DrawnPoly* thePolygons = [_allZoomText objectAtIndex:i];
        CGContextTranslateCTM(context, thePolygons->_startPoint.x, thePolygons->_startPoint.y);

        // Draw each "zoom" text effect
        NSMutableArray* polyArray = thePolygons->_polyPaths;
        for (int j = 0; j < polyArray.count; j++) {
            PolyPathWithColors* individualPoly = [polyArray objectAtIndex:j];
            CGContextAddPath(context, CGPathCreateMutableCopyByTransformingPath(individualPoly->path, &windowScale));
            CGContextSetRGBFillColor(context, individualPoly->r, individualPoly->g, individualPoly->b, 1);
            CGContextDrawPath(context, thePolygons->_zoomMode);
        }

        // Draw the actual text on top of the effect
        CGContextSetRGBFillColor(context, 1, 1, 1, 1);
        CGContextAddPath(context, CGPathCreateMutableCopyByTransformingPath(thePolygons->_frontPath, &windowScale));
        CGContextDrawPath(context, thePolygons->_frontMode);
        CGContextRestoreGState(context);
    }
}

static CGPoint connectingPoint;
static void CGPathApplyCallback(void* info, const CGPathElement* element) {
    CGPoint pointToDraw;

    // Get the ending point of each path segment
    switch (element->type) {
        case kCGPathElementMoveToPoint:
            connectingPoint = CGPointZero;
        case kCGPathElementAddLineToPoint:
            pointToDraw = element->points[0];
            break;
        case kCGPathElementAddQuadCurveToPoint:
            pointToDraw = element->points[1];
            break;
        case kCGPathElementAddCurveToPoint:
            pointToDraw = element->points[2];
            break;
    }
    // Compare with the previous segment's ending point
    if (!CGPointEqualToPoint(connectingPoint, CGPointZero)) {
        // Calculate the angle between these two points to create a shading/light perspective effect
        CGFloat angle = fabs(atan2(pointToDraw.y - connectingPoint.y, pointToDraw.x - connectingPoint.x));
        while (angle > M_PI) {
            angle -= M_PI;
        }
        angle = (1 - fabs(angle - M_PI_2) / M_PI_2);

        // Create a Poly struct to be drawn later and add it to our mutable array
        ThreeDPoly* threeD = [[ThreeDPoly alloc] initWithAngle:angle pointToDraw:pointToDraw connectingPoint:connectingPoint];
        [(__bridge NSMutableArray*)info addObject:threeD];
    }
    connectingPoint = pointToDraw;
}

@end
