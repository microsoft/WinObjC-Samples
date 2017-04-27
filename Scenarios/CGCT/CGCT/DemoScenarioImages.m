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

#import "DemoScenarioImages.h"
#import <CoreGraphics/CoreGraphics.h>
#import <CoreText/CoreText.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@implementation DemoScenarioImages {
    UIImage* _sunsetImage;
};

static NSString* patternName;
static CGBlendMode blendModes[] = { kCGBlendModeNormal,    kCGBlendModeScreen,     kCGBlendModeDarken,    kCGBlendModeHue,
                                    kCGBlendModeXOR,       kCGBlendModeSaturation, kCGBlendModeOverlay,   kCGBlendModeSoftLight,
                                    kCGBlendModeHardLight, kCGBlendModeLuminosity, kCGBlendModeDifference };

- (NSString*)name {
    return @"Images";
}

- (UIColor*)backgroundColor {
    return [UIColor colorWithRed:.66 green:.65 blue:.8 alpha:1];
}

- (instancetype)init {
    if (self = [super init]) {
        _sunsetImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sunset" ofType:@"png"]];
    }
    return self;
}

- (void)drawDemoIntoContext:(CGContextRef)context withFrame:(CGRect)bounds {
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CGContextTranslateCTM(context, bounds.size.width * .03, -bounds.size.height * .98);
    CGContextSaveGState(context);

    CGFloat aspectRatio = _sunsetImage.size.height / _sunsetImage.size.width;
    CGFloat imageSize = bounds.size.width / 3.75;
    CGContextSetRGBFillColor(context, 1, 0, 0, .3);
    int colorIndex = 0;

    CGFloat fillColors[64];
    for (CGFloat r = .4; r < 1; r += .4) {
        for (CGFloat g = .4; g < 1; g += .4) {
            for (CGFloat b = .4; b < 1; b += .4) {
                for (CGFloat a = .4; a < 1; a += .4) {
                    fillColors[colorIndex] = r;
                    fillColors[colorIndex + 1] = g;
                    fillColors[colorIndex + 2] = b;
                    fillColors[colorIndex + 3] = a;
                    colorIndex += 4;
                }
            }
        }
    }

    int blendModeIndex = 0;
    for (CGFloat x = 0; x < 1; x += .34) {
        for (CGFloat y = 0; y < 1; y += .25) {
            CGContextSaveGState(context);
            CGContextSetRGBFillColor(context,
                                     fillColors[blendModeIndex * 4],
                                     fillColors[blendModeIndex * 4 + 1],
                                     fillColors[blendModeIndex * 4 + 2],
                                     fillColors[blendModeIndex * 4 + 3]);
            CGRect pane = CGRectMake(x * bounds.size.width, y * bounds.size.height, imageSize, imageSize * aspectRatio);
            CGContextDrawImage(context, pane, _sunsetImage.CGImage);

            CGContextSetBlendMode(context, blendModes[blendModeIndex]);
            CGContextFillRect(context, pane);
            blendModeIndex++;
            CGContextRestoreGState(context);
        }
    }
}

@end
