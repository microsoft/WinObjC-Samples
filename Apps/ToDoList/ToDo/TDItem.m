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


#import "TDItem.h"

@implementation TDItem

+ (id)toDoItemWithText:(NSString *)text
{
    return [[TDItem alloc] initWithText:text];
}

+ (id)todoItemWithText:(NSString*)text isComplete:(BOOL)complete
{
    TDItem *item = [[TDItem alloc] initWithText:text];
    item.completed = complete;
    return item;
}

- (id)initWithText:(NSString*)text
{
    if (self = [super init]) {
        self.text = text;
    }
    return self;
}

- (NSDictionary*)serialize
{
    return @{ self.text : @(self.completed) };
}

@end