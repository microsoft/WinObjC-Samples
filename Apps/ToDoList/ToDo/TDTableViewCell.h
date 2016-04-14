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


#import <UIKit/UIKit.h>
#import "TDItem.h"

@protocol TDTableViewCellDelegate <NSObject>

// The cell's delegate is notified when the to do item has been deleted
- (void) toDoItemDeleted:(TDItem*) todoItem;

// The cell's delegate is notified when the to do item has been completed
- (void) toDoItemCompleted:(TDItem*) todoItem;

@end


@interface TDTableViewCell : UITableViewCell

@property (nonatomic) TDItem *todoItem;
@property (nonatomic, assign) id<TDTableViewCellDelegate> delegate;

@end
