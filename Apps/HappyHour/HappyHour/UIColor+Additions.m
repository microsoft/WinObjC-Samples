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


#import "UIColor+Additions.h"

@implementation UIColor (Additions)

// Assumes "#000000" or "name" format
+ (UIColor *) colorFromString:(NSString *)hexString
{
    // Check for hash colors
    if([hexString hasPrefix:@"#"]) {
        unsigned rgbValue = 0;
        NSScanner *scanner = [NSScanner scannerWithString:hexString];
        [scanner setScanLocation:1];
        [scanner scanHexInt:&rgbValue];
        return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0
                               green:((rgbValue & 0xFF00) >> 8)/255.0
                                blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
    }
    
    // Check for named colors
    if([hexString isEqualToString:@"clear"]) return [UIColor clearColor];
    else if([hexString isEqualToString:@"grey"]) return [UIColor grayColor];
    else if([hexString isEqualToString:@"orange"]) return [UIColor orangeColor];
    else if([hexString isEqualToString:@"brown"]) return [UIColor brownColor];
    else if([hexString isEqualToString:@"red"]) return [UIColor redColor];
    else if([hexString isEqualToString:@"white"]) return [UIColor whiteColor];
    else if([hexString isEqualToString:@"green"]) return [UIColor greenColor];
    else if([hexString isEqualToString:@"yellow"]) return [UIColor yellowColor];
    else if([hexString isEqualToString:@"pink"]) return [UIColor purpleColor];
    else if([hexString isEqualToString:@"black"]) return [UIColor blackColor];
    else if([hexString isEqualToString:@"blue"]) return [UIColor blueColor];
    
    return [UIColor clearColor];
}

- (BOOL) isEqualToColor:(UIColor *)color
{
    return [self isEqualToColor:color withTolerance:0];
}

- (BOOL) isEqualToColor:(UIColor *)color withTolerance:(CGFloat)tolerance
{
    CGFloat r1, g1, b1, a1, r2, g2, b2, a2;
    [self getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    [color getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
    
    return
        fabs(r1 - r2) <= tolerance &&
        fabs(g1 - g2) <= tolerance &&
        fabs(b1 - b2) <= tolerance &&
        fabs(a1 - a2) <= tolerance;
}

@end
