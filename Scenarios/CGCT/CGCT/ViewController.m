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

#import "ViewController.h"
#import "PathDemoTableViewCell.h"
#import "CGView.h"

#define VC_WIDTH self.view.frame.size.width
#define VC_HEIGHT self.view.frame.size.height

@interface ViewController ()
@property UITableView* CGMenu;
@property CGContextRef stageContext;
@property CGRect stageBounds;
@property CGView* stage;
@end

@implementation ViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewWillLayoutSubviews {
    _stageBounds = self.view.bounds;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [_CGMenu setNeedsLayout];
    [_CGMenu layoutIfNeeded];
    [_stage setNeedsLayout];
    [_stage setNeedsDisplay];

    CGRect newMenuFrame = CGRectMake(0, 0, _stageBounds.size.width / 5.0, _stageBounds.size.height);
    _CGMenu.frame = newMenuFrame;

    CGFloat stageSize = _stageBounds.size.width / 5 * 4;
    if (stageSize > _stageBounds.size.height) {
        stageSize = _stageBounds.size.height;
    }
    CGRect newStageFrame =
        CGRectMake(_stageBounds.size.width / 5.0, _stageBounds.size.height / 2.0 - stageSize / 2.0, stageSize, stageSize);
    _stage.frame = newStageFrame;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _CGMenu = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, VC_WIDTH / 5.0, VC_HEIGHT) style:UITableViewStylePlain];
    _CGMenu.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    _CGMenu.rowHeight = 30;
    _CGMenu.scrollEnabled = YES;
    _CGMenu.userInteractionEnabled = YES;
    _CGMenu.bounces = NO;

    _CGMenu.delegate = self;
    _CGMenu.dataSource = self;

    _stage = [[CGView alloc] initWithFrame:self.view.bounds];

    [self.view addSubview:_stage];
    [self.view addSubview:_CGMenu];
}

- (void)viewWillAppear:(BOOL)animated {
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    if (tableView == _CGMenu) {
        _stage.backgroundColor = [UIColor colorWithRed:.1 green:.3 blue:1 alpha:1];
        [_stage updateCurrentDemo:[tableView cellForRowAtIndexPath:indexPath]];
        [_stage setNeedsDisplay];
    }
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(nonnull NSIndexPath*)indexPath {
    if (tableView == _CGMenu) {
        UITableViewCell* aCell = [tableView dequeueReusableCellWithIdentifier:@"CGStory1"];
        if (aCell == nil) {
            aCell = [[PathDemoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CGStory1"];
        }
        aCell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        aCell.textLabel.text = @"CoreDemo1";

        return aCell;
    }

    return nil;
}

@end
