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


#import "TDTableViewCell.h"
#import "TDLabel.h"

@implementation TDTableViewCell {
    CGPoint _originalCenter;
    BOOL _deleteOnDragRelease;
    BOOL _markCompleteOnDragRelease;
    TDLabel *_label;
    UILabel *_archiveLabel;
    UILabel *_deleteLabel;
}

const float UI_CUES_MARGIN = 8.0f;
const float UI_CUES_PAD = 4.0f;
const float LABEL_LEFT_MARGIN = 15.0f;
const float SWIPE_THRESHHOLD = 80.0f;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        // Set up labels
        _archiveLabel = [self createCueLabel];
        _archiveLabel.text = @"ARCHIVE";
        _archiveLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_archiveLabel];
        
        _deleteLabel = [self createCueLabel];
        _deleteLabel.text = @"DELETE";
        _deleteLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_deleteLabel];
        
        _label = [[TDLabel alloc] initWithFrame:CGRectNull];
        _label.textColor = [UIColor blackColor];
        _label.font = [UIFont boldSystemFontOfSize:16];
        _label.backgroundColor = [UIColor clearColor];
        [self addSubview:_label];
        
        // Clear default selection style
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // Add a pan recognizer for archive and delete swipes
        UIGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(handlePan:)];
        recognizer.delegate = self;
        [self addGestureRecognizer:recognizer];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _label.frame = CGRectMake(LABEL_LEFT_MARGIN, 0,
                              self.bounds.size.width - (LABEL_LEFT_MARGIN * 2), self.bounds.size.height);
    
    CGSize archiveSize = [_archiveLabel.text sizeWithAttributes:@{NSFontAttributeName: _archiveLabel.font}];
    _archiveLabel.frame = CGRectMake(-archiveSize.width - UI_CUES_MARGIN, 0,
                                  archiveSize.width + UI_CUES_PAD, self.bounds.size.height);
    
    CGSize deleteSize = [_deleteLabel.text sizeWithAttributes:@{NSFontAttributeName: _deleteLabel.font}];
    _deleteLabel.frame = CGRectMake(self.bounds.size.width + UI_CUES_MARGIN, 0,
                                   deleteSize.width + UI_CUES_PAD, self.bounds.size.height);
}

- (void)setTodoItem:(TDItem *)todoItem
{
    _todoItem = todoItem;
    _label.text = todoItem.text;
    _label.strikethrough = todoItem.completed;
    _label.textColor = (todoItem.completed) ? [UIColor lightGrayColor] : [UIColor blackColor];
}

// Utility method for creating the contextual cues
- (UILabel*)createCueLabel
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectNull];
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont boldSystemFontOfSize:11.0];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

#pragma mark - Pan gesture recognizer

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = [gestureRecognizer translationInView:[self superview]];
    
    // Check for horizontal gesture and disallow swiping completed to dos
    return !self.todoItem.completed && fabs(translation.x) > fabs(translation.y);
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _originalCenter = self.center;
        _markCompleteOnDragRelease = NO;
        _deleteOnDragRelease = NO;
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        // Determine whether the item has been dragged far enough to initiate a delete / archive
        _markCompleteOnDragRelease = self.frame.origin.x > SWIPE_THRESHHOLD;
        _deleteOnDragRelease = self.frame.origin.x < -SWIPE_THRESHHOLD;
        
        _archiveLabel.textColor = _markCompleteOnDragRelease ? [UIColor greenColor] : [UIColor lightGrayColor];
        _deleteLabel.textColor = _deleteOnDragRelease ? [UIColor redColor] : [UIColor lightGrayColor];
        
        // Translate the center, with more resistance to panning after action threshhold is crossed
        CGPoint translation = [recognizer translationInView:self];
        if(_markCompleteOnDragRelease) {
            self.center = CGPointMake(_originalCenter.x + translation.x/2 + SWIPE_THRESHHOLD/2, _originalCenter.y);
        }
        
        else if(_deleteOnDragRelease) {
            self.center = CGPointMake(_originalCenter.x + translation.x/2 - SWIPE_THRESHHOLD/2, _originalCenter.y);
        }
        
        else {
            self.center = CGPointMake(_originalCenter.x + translation.x, _originalCenter.y);
        }
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (!_deleteOnDragRelease) {
            // If the item is not being deleted, snap back to the original frame
            CGRect originalFrame = CGRectMake(0, self.frame.origin.y,
                                              self.bounds.size.width, self.bounds.size.height);
            [UIView animateWithDuration:0.2
                             animations:^{
                                 self.frame = originalFrame;
                             }
            ];
        }
        
        else {
            [self.delegate toDoItemDeleted:self.todoItem]; // Notify the delegate that this item should be deleted
        }
        
        if (_markCompleteOnDragRelease) {
            // Mark the item as complete and update the UI state
            self.todoItem.completed = YES;
            _label.strikethrough = YES;
            _label.textColor = [UIColor lightGrayColor];
            
            // Notify the delegate that this item should be completed
            [self.delegate toDoItemCompleted:self.todoItem];
        }
    }
}

@end
