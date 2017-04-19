//
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

#import "CGView.h"

@implementation CGView {
    DemoTableViewCell* demoToDraw;
};

- (void)updateCurrentDemo:(DemoTableViewCell*)newDemo {
    demoToDraw = newDemo;
}

- (void)drawRect:(CGRect)pos {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [demoToDraw drawDemoIntoContext:context withFrame:self.frame view:self];
}

@end
