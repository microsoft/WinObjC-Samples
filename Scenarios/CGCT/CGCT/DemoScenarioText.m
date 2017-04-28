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

#import "DemoScenarioText.h"
#import <CoreGraphics/CoreGraphics.h>
#import <CoreText/CoreText.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@implementation DemoScenarioText

static NSString* patternName;

- (NSString*)name {
    return @"Text";
}

- (UIColor*)backgroundColor {
    return [UIColor colorWithRed:.6 green:.85 blue:1 alpha:1];
}

static void drawPattern(void* info, CGContextRef context) {
    UIImage* patternImage =
        [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[patternName lowercaseString] ofType:@"png"]];
    CGAffineTransform flip = CGAffineTransformMakeScale(1, -1);
    CGAffineTransform shift = CGAffineTransformTranslate(flip, 0, patternImage.size.height * -1);
    CGContextConcatCTM(context, shift);

    CGContextDrawImage(context, CGRectMake(0, 0, patternImage.size.width, patternImage.size.height), patternImage.CGImage);
}

static void drawTextWithImagePattern(
    CGContextRef context, NSString* imageName, CGRect bounds, CGSize imageSize, CGFloat heightLocation, CFStringRef fontName) {
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0, heightLocation * bounds.size.height);

    patternName = imageName;
    CTFontRef myCFFont = CTFontCreateWithName(fontName, bounds.size.height * .15, NULL);
    CFAutorelease(myCFFont);

    NSDictionary* patternDictionary = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)myCFFont, (id)kCTFontAttributeName, nil];

    CFAttributedStringRef attrString =
        CFAttributedStringCreate(kCFAllocatorDefault, (__bridge CFStringRef)imageName, (__bridge CFDictionaryRef)patternDictionary);
    CFAutorelease(attrString);

    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrString);
    CFAutorelease(framesetter);

    CGMutablePathRef textPath = CGPathCreateMutable();
    CGPathAddRect(textPath, NULL, CGRectMake(0, 0, bounds.size.width, bounds.size.height * .3));
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), textPath, NULL);
    CFAutorelease(frame);
    CGContextSetTextDrawingMode(context, kCGTextClip);
    CTFrameDraw(frame, context);

    CGPatternCallbacks callbacks = { 0, &drawPattern, NULL };
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGColorSpaceRef patternSpace = CGColorSpaceCreatePattern(baseSpace);
    CGContextSetFillColorSpace(context, patternSpace);
    CGColorSpaceRelease(patternSpace);
    CGColorSpaceRelease(baseSpace);

    CGPatternRef plaidPattern = CGPatternCreate(
        NULL, bounds, CGAffineTransformIdentity, imageSize.width, imageSize.height, kCGPatternTilingConstantSpacing, false, &callbacks);
    CGFloat colors[4] = { 1, 1, 1, 1 };
    CGContextSetFillPattern(context, plaidPattern, colors);
    CGContextFillRect(context, bounds);

    CGPatternRelease(plaidPattern);
    CGPathRelease(textPath);
    CGContextRestoreGState(context);
}

- (void)drawDemoIntoContext:(CGContextRef)context withFrame:(CGRect)bounds {
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CGContextTranslateCTM(context, 0, -bounds.size.height);
    CGContextSetShadowWithColor(context, CGSizeMake(10.f, 10.f), .6f, [UIColor colorWithRed:0 green:0 blue:0 alpha:.1f].CGColor);
    CGContextSaveGState(context);

    CGContextTranslateCTM(context, .3 * bounds.size.width, 0);

    drawTextWithImagePattern(context, @"PLAID", bounds, CGSizeMake(40, 36), 0.7f, (__bridge CFStringRef) @"Segoe UI Bold");
    drawTextWithImagePattern(context, @"DENIM", bounds, CGSizeMake(16, 12), 0.5f, (__bridge CFStringRef) @"Algerian");
    CGContextTranslateCTM(context, -.27 * bounds.size.width, 0);
    drawTextWithImagePattern(context, @"CHECKERED", bounds, CGSizeMake(16, 16), 0.28f, (__bridge CFStringRef) @"Arial Bold");

    CGContextRestoreGState(context);

    CTTextAlignment alignment = kCTCenterTextAlignment;

    CTParagraphStyleSetting alignmentSetting;
    alignmentSetting.spec = kCTParagraphStyleSpecifierAlignment;
    alignmentSetting.valueSize = sizeof(CTTextAlignment);
    alignmentSetting.value = &alignment;

    CTParagraphStyleSetting settings[1] = { alignmentSetting };

    CTParagraphStyleRef paragraphRef = CTParagraphStyleCreate(settings, 1);

    NSString* textBox = @"This is my attributed string. There are many like it, "
                        @"but this one is mine.\n\nMy font is my best friend. "
                        @"It is my speech. I must MASTER it as I must master my "
                        @"app.";

    NSRange attrRange = [textBox rangeOfString:@"attributed string"];
    NSRange manyRange = [textBox rangeOfString:@"many"];
    NSRange mineRange = [textBox rangeOfString:@"mine"];
    NSRange fontRange = [textBox rangeOfString:@"font"];
    NSRange masterRange = [textBox rangeOfString:@"MASTER"];

    CTFontRef mainFont = CTFontCreateWithName(CFSTR("Times New Roman"), bounds.size.height * .04, NULL);
    CTFontRef fontRangeFont = CTFontCreateWithName(CFSTR("Blackadder ITC"), bounds.size.height * .04, NULL);
    CTFontRef masterRangeFont = CTFontCreateWithName(CFSTR("Magneto Bold"), bounds.size.height * .04, NULL);
    CFAutorelease(mainFont);
    CFAutorelease(fontRangeFont);
    CFAutorelease(masterRangeFont);

    NSDictionary* attributesDict = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)mainFont,
                                                                              (id)kCTFontAttributeName,
                                                                              [UIColor blackColor].CGColor,
                                                                              (id)kCTForegroundColorAttributeName,
                                                                              (__bridge id)paragraphRef,
                                                                              kCTParagraphStyleAttributeName,
                                                                              nil];

    CFAttributedStringRef attrString =
        CFAttributedStringCreate(kCFAllocatorDefault, (__bridge CFStringRef)textBox, (__bridge CFDictionaryRef)attributesDict);
    CFMutableAttributedStringRef mutableAttrString = CFAttributedStringCreateMutableCopy(kCFAllocatorDefault, [textBox length], attrString);

    CFAutorelease(attrString);
    CFAutorelease(mutableAttrString);

    CFAttributedStringBeginEditing(mutableAttrString);
    CFAttributedStringSetAttribute(mutableAttrString,
                                   CFRangeMake(attrRange.location, attrRange.length),
                                   kCTForegroundColorAttributeName,
                                   [UIColor blueColor].CGColor);
    CFAttributedStringSetAttribute(mutableAttrString,
                                   CFRangeMake(mineRange.location, mineRange.length),
                                   kCTForegroundColorAttributeName,
                                   [UIColor redColor].CGColor);
    CFAttributedStringSetAttribute(mutableAttrString,
                                   CFRangeMake(manyRange.location, manyRange.length),
                                   kCTForegroundColorAttributeName,
                                   [UIColor greenColor].CGColor);
    CFAttributedStringSetAttribute(mutableAttrString,
                                   CFRangeMake(fontRange.location, fontRange.length),
                                   kCTFontAttributeName,
                                   fontRangeFont);
    CFAttributedStringSetAttribute(mutableAttrString,
                                   CFRangeMake(masterRange.location, masterRange.length),
                                   kCTFontAttributeName,
                                   masterRangeFont);
    CFAttributedStringEndEditing(mutableAttrString);

    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(mutableAttrString);
    CFAutorelease(framesetter);

    CGMutablePathRef textPath = CGPathCreateMutable();
    CGContextTranslateCTM(context, 0.1 * bounds.size.width, 0.1 * bounds.size.height);
    CGPathAddRect(textPath, NULL, CGRectMake(0, 0, bounds.size.width * .8, bounds.size.height * .3));
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), textPath, NULL);
    CFAutorelease(frame);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CTFrameDraw(frame, context);
}

@end
