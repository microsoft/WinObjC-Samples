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

@implementation DemoScenarioTextToPath

- (NSString*)name {
    return @"Text To Path";
}

- (UIColor*)backgroundColor {
    return [UIColor colorWithRed:.6 green:.85 blue:1 alpha:1];
}

static CGPoint connectingPoint;

static struct ThreeDPoly {
    CGFloat grayScale;
    CGPoint point1;
    CGPoint point2;
};

static void drawZoomText(CGContextRef context,
                         NSString* string,
                         CTFontRef font,
                         CGRect bounds,
                         CGPoint startPoint,
                         CGPoint toPoint,
                         CGFloat r,
                         CGFloat g,
                         CGFloat b,
                         CGPathDrawingMode frontMode,
                         CGPathDrawingMode zoomMode) {
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, startPoint.x, startPoint.y);
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

            connectingPoint = CGPointZero;
            CGPathApply(path, (__bridge void*)threeDPoints, CGPathApplyCallback);
            CGPathRelease(path);
        }
    }

    // Sort which zoom polygon to draw first from vertical perspective
    for (int polyIndex1 = 0; polyIndex1 < [threeDPoints count]; polyIndex1++) {
        for (int polyIndex2 = 1; polyIndex2 < [threeDPoints count]; polyIndex2++) {
            struct ThreeDPoly poly1;
            struct ThreeDPoly poly2;
            NSValue* val1 = [threeDPoints objectAtIndex:polyIndex1];
            NSValue* val2 = [threeDPoints objectAtIndex:polyIndex2];
            [val1 getValue:&poly1];
            [val2 getValue:&poly2];
            if (toPoint.y < 0) {
                if (poly2.point1.y < poly1.point1.y || poly2.point2.y < poly1.point2.y) {
                    [threeDPoints replaceObjectAtIndex:polyIndex1 withObject:val2];
                    [threeDPoints replaceObjectAtIndex:polyIndex2 withObject:val1];
                }
            } else {
                if (poly2.point1.y > poly1.point1.y || poly2.point2.y > poly1.point2.y) {
                    [threeDPoints replaceObjectAtIndex:polyIndex1 withObject:val2];
                    [threeDPoints replaceObjectAtIndex:polyIndex2 withObject:val1];
                }
            }
        }
    }

    // Sort which zoom polygon to draw first from a horizontal perspective.
    for (int i = 0; i < [threeDPoints count]; i++) {
        for (int j = 1; j < [threeDPoints count]; j++) {
            struct ThreeDPoly poly1;
            struct ThreeDPoly poly2;
            NSValue* val1 = [threeDPoints objectAtIndex:i];
            NSValue* val2 = [threeDPoints objectAtIndex:j];
            [val1 getValue:&poly1];
            [val2 getValue:&poly2];
            if (fabs((startPoint.x + toPoint.x) / 2.0 - poly1.point1.x) > fabs((startPoint.x + toPoint.x) / 2.0 - poly2.point1.x)) {
                [threeDPoints replaceObjectAtIndex:i withObject:val2];
                [threeDPoints replaceObjectAtIndex:j withObject:val1];
            }
        }
    }

    // Draw the polygons
    for (int k = 0; k < [threeDPoints count]; k++) {
        struct ThreeDPoly polyToDraw;
        NSValue* valPoly = [threeDPoints objectAtIndex:k];
        [valPoly getValue:&polyToDraw];

        CGContextMoveToPoint(context, (polyToDraw.point1.x + toPoint.x) / 2.0, (polyToDraw.point1.y + toPoint.y) / 2.0);
        CGContextAddLineToPoint(context, (polyToDraw.point2.x + toPoint.x) / 2.0, (polyToDraw.point2.y + toPoint.y) / 2.0);
        CGContextAddLineToPoint(context, polyToDraw.point2.x, polyToDraw.point2.y);
        CGContextAddLineToPoint(context, polyToDraw.point1.x, polyToDraw.point1.y);
        CGContextClosePath(context);

        CGContextSetRGBFillColor(context, polyToDraw.grayScale * r, polyToDraw.grayScale * g, polyToDraw.grayScale * b, 1);
        CGContextDrawPath(context, zoomMode);
    }

    // Fill the front face of the text after the "zoom" effect has been added.
    CGContextSetRGBFillColor(context, .7, .7, .7, 1);
    CGContextAddPath(context, allGlyphPaths);
    CGContextDrawPath(context, frontMode);
    CGPathRelease(allGlyphPaths);
    CGContextRestoreGState(context);
}

- (void)drawDemoIntoContext:(CGContextRef)context withFrame:(CGRect)bounds {
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CGContextTranslateCTM(context, bounds.size.width * .05, -bounds.size.height * 1.1);
    CGContextSaveGState(context);

    // Different fonts to show off different paths
    CTFontRef arialFont = CTFontCreateWithName((__bridge CFStringRef) @"Arial Bold", bounds.size.height * .15, NULL);
    CTFontRef gillFont = CTFontCreateWithName((__bridge CFStringRef) @"Palatino", bounds.size.height * .15, NULL);
    CTFontRef parchmentFont = CTFontCreateWithName((__bridge CFStringRef) @"Papyrus", bounds.size.height * .15, NULL);
    CFAutorelease(arialFont);
    CFAutorelease(gillFont);
    CFAutorelease(parchmentFont);

    CGContextSetLineWidth(context, 1.0);

    NSString* string = @"WinOBJC";
    drawZoomText(context,
                 @"CoreGraphics",
                 gillFont,
                 bounds,
                 CGPointMake(bounds.size.width * .1, bounds.size.height * .75),
                 CGPointMake(bounds.size.width * .4, -bounds.size.height * .15),
                 .5,
                 .1,
                 1,
                 kCGPathFillStroke,
                 kCGPathFillStroke);

    drawZoomText(context,
                 @"WinOBJC",
                 arialFont,
                 bounds,
                 CGPointMake(bounds.size.width * .2, bounds.size.height * .55),
                 CGPointMake(bounds.size.width * .35, bounds.size.height * .05),
                 1,
                 1,
                 1,
                 kCGPathEOFillStroke,
                 kCGPathEOFillStroke);
    drawZoomText(context,
                 @"CoreText",
                 parchmentFont,
                 bounds,
                 CGPointMake(bounds.size.width * .15, bounds.size.height * .35),
                 CGPointMake(bounds.size.width * .3, bounds.size.height * .15),
                 1,
                 .1,
                 .5,
                 kCGPathFillStroke,
                 kCGPathFill);
}

static void CGPathApplyCallback(void* info, const CGPathElement* element) {
    CGPoint pointToDraw;
    // Get the ending point of each path segment
    switch (element->type) {
        case kCGPathElementMoveToPoint:
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
        struct ThreeDPoly threeD = { angle, pointToDraw, connectingPoint };
        [(__bridge NSMutableArray*)info addObject:[NSValue valueWithBytes:&threeD objCType:@encode(struct ThreeDPoly)]];
    }
    connectingPoint = pointToDraw;
}

@end
