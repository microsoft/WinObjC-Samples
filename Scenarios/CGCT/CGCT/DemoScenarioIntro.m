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

#import "DemoScenarioIntro.h"
#import <CoreGraphics/CoreGraphics.h>
#import <CoreText/CoreText.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@implementation DemoScenarioIntro
- (NSString *)name {
    return @"Intro";
}

-(UIColor *)backgroundColor {
    return[UIColor colorWithRed : .1 green : .3 blue : 1 alpha : 1];
}

-(void)drawDemoIntoContext:(CGContextRef)context withFrame : (CGRect)bounds {
    CGContextSaveGState(context);

    CGMutablePathRef light = CGPathCreateMutable();
    CGPathMoveToPoint(light, NULL, bounds.size.width * .9, bounds.size.height * .1);
    CGPathAddLineToPoint(light, NULL, 0, 0);
    CGPathAddLineToPoint(light, NULL, 0, bounds.size.height);
    CGPathAddLineToPoint(light, NULL, bounds.size.width * .9, bounds.size.height * .81);

    CGContextSetRGBFillColor(context, .7, .7, 1, .5);
    CGContextAddPath(context, light);
    CGContextDrawPath(context, kCGPathFill);
    CGPathRelease(light);

    CGMutablePathRef windowTR = CGPathCreateMutable();

    CGPoint windowsCorners[] = {
        CGPointMake(bounds.size.width * .9, bounds.size.height * .1),
        CGPointMake(bounds.size.width * .9, bounds.size.height * .45),
        CGPointMake(bounds.size.width * .6, bounds.size.height * .45),
        CGPointMake(bounds.size.width * .6, bounds.size.height * .2),
        CGPointMake(bounds.size.width * .9, bounds.size.height * .1) };

    CGPathAddLines(windowTR, NULL, windowsCorners, 4);

    CGAffineTransform windowTransform = CGAffineTransformIdentity;
    windowTransform = CGAffineTransformScale(windowTransform, 1, -1);
    windowTransform = CGAffineTransformTranslate(windowTransform, 0, -.91 * bounds.size.height);

    CGPathRef windowBR = CGPathCreateCopyByTransformingPath(windowTR, &windowTransform);

    windowTransform = CGAffineTransformTranslate(windowTransform, -bounds.size.width * .05, bounds.size.height * .136);
    windowTransform = CGAffineTransformScale(windowTransform, .7, .7);

    CGPathRef windowBL = CGPathCreateCopyByTransformingPath(windowBR, &windowTransform);

    windowTransform = CGAffineTransformTranslate(windowTransform, 0, .908 * bounds.size.height);
    windowTransform = CGAffineTransformScale(windowTransform, 1, -1);

    CGPathRef windowTL = CGPathCreateCopyByTransformingPath(windowBR, &windowTransform);

    CGContextSetRGBFillColor(context, 1, 1, 1, 1);

    CGContextAddPath(context, windowTL);
    CGContextAddPath(context, windowTR);
    CGContextAddPath(context, windowBL);
    CGContextAddPath(context, windowBR);
    CGContextSetShadow(context, CGSizeMake(10.f, 10.f), 1.0);
    CGContextDrawPath(context, kCGPathFill);
    CGContextRestoreGState(context);
    CGPathRelease(windowTR);
    CGPathRelease(windowTL);
    CGPathRelease(windowBR);
    CGPathRelease(windowBL);

    // draw some dashed lines coming out as well
    CGFloat dashes[] = { 5.0, 2.0 };
    CGMutablePathRef dottedLine = CGPathCreateMutable();
    CGPathMoveToPoint(dottedLine, NULL, bounds.size.width * .5, bounds.size.height * .9);
    CGPathAddCurveToPoint(dottedLine, NULL, bounds.size.width * .4, bounds.size.height * .8, bounds.size.width * .3, bounds.size.height, bounds.size.width * .2, bounds.size.height * .9);
    CGPathAddArc(dottedLine, NULL, bounds.size.width * .24, bounds.size.height * .87, bounds.size.width * .05, M_PI * .8, 0, false);

    CGAffineTransform dottedLineMirrorTransform = CGAffineTransformIdentity;
    dottedLineMirrorTransform = CGAffineTransformScale(dottedLineMirrorTransform, -1, 1);
    dottedLineMirrorTransform = CGAffineTransformTranslate(dottedLineMirrorTransform, -bounds.size.width, 0);
    CGPathRef dottedLineMirror = CGPathCreateCopyByTransformingPath(dottedLine, &dottedLineMirrorTransform);
    CGContextSaveGState(context);

    CGContextSetLineDash(context, 0, dashes, 2);
    CGContextSetLineWidth(context, 3);
    CGContextAddPath(context, dottedLine);
    CGContextAddPath(context, dottedLineMirror);

    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(dottedLine);
    CGPathRelease(dottedLineMirror);

    CGContextRestoreGState(context);

    CGFloat colors[12] = { .3, .3, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, .3, .3, 1.0, 1.0 };

    CGFloat locations[3] = { 0.0, 0.65, 1.0 };

    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, locations, 3);
    CGColorSpaceRelease(baseSpace);

    CGContextSaveGState(context);
    CGMutablePathRef ribbon = CGPathCreateMutable();
    CGPathMoveToPoint(ribbon, NULL, bounds.size.width * .2, bounds.size.height * .6);
    CGPathAddArcToPoint(ribbon, NULL, bounds.size.width * .08, bounds.size.height * .7, bounds.size.width * .14, bounds.size.height * .9, bounds.size.width * .15);
    CGPathAddArc(ribbon, NULL, bounds.size.width * .06, bounds.size.height * .81, bounds.size.width * .05, M_PI * 1.9, M_PI * .4, false);
    CGPathAddLineToPoint(ribbon, NULL, bounds.size.width * .1, bounds.size.height * .86);
    CGPathAddArc(ribbon, NULL, bounds.size.width * .06, bounds.size.height * .81, bounds.size.width * .09, M_PI * .4, M_PI * 1.9, true);
    CGPathAddArc(ribbon, NULL, bounds.size.width * .21, bounds.size.height * .75, bounds.size.width * .07, M_PI * .9, M_PI * 1.32, false);
    CGPathAddLineToPoint(ribbon, NULL, bounds.size.width * .23, bounds.size.height * .65);
    CGPathAddLineToPoint(ribbon, NULL, bounds.size.width * .2, bounds.size.height * .64);
    CGPathCloseSubpath(ribbon);
    CGContextAddPath(context, ribbon);

    CGAffineTransform reverseRibbon = CGAffineTransformIdentity;
    reverseRibbon = CGAffineTransformScale(reverseRibbon, -1, 1);
    reverseRibbon = CGAffineTransformTranslate(reverseRibbon, -bounds.size.width, 0);
    CGPathRef reversedRibbon = CGPathCreateCopyByTransformingPath(ribbon, &reverseRibbon);
    CGContextAddPath(context, reversedRibbon);

    CGContextClip(context);

    CGRect gradientRect = CGRectMake(bounds.size.width * .05, bounds.size.height * .6, bounds.size.width * .8, bounds.size.height * .4);
    CGPoint startPoint = CGPointMake(CGRectGetMinX(gradientRect), CGRectGetMaxY(gradientRect));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(gradientRect), CGRectGetMinY(gradientRect));

    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient), gradient = NULL;

    CGContextRestoreGState(context);

    CGContextAddPath(context, ribbon);
    CGContextAddPath(context, reversedRibbon);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(ribbon);
    CGPathRelease(reversedRibbon);

    CGMutablePathRef textPath = CGPathCreateMutable();
    CGPathAddRect(textPath, NULL, CGRectMake(0, 0, bounds.size.width, bounds.size.height * .3));

    CGContextSaveGState(context);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CGContextTranslateCTM(context, bounds.size.width * .25, -bounds.size.height);

    CTFontRef myCFFont = CTFontCreateWithName((__bridge CFStringRef) @"Segoe UI", bounds.size.height * .1, NULL);
    CFAutorelease(myCFFont);

    NSDictionary *attributesDict = [NSDictionary dictionaryWithObjectsAndKeys :
    (__bridge id)myCFFont,
        (id)kCTFontAttributeName,
        [UIColor blackColor].CGColor,
        (id)kCTForegroundColorAttributeName, nil];

    CFAttributedStringRef attrString = CFAttributedStringCreate(kCFAllocatorDefault, (__bridge CFStringRef) @"Core Demo", (__bridge CFDictionaryRef)attributesDict);
    CFAutorelease(attrString);

    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrString);
    CFAutorelease(framesetter);

    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), textPath, NULL);
    CFAutorelease(frame);

    CTFrameDraw(frame, context);
    CGPathRelease(textPath);
}

@end
