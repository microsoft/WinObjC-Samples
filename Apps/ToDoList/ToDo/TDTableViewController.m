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


#import "TDTableViewController.h"

#define INPUT_SECTION 0
#define TODO_SECTION 1
#define COMPLETE_SECTION 2

@implementation TDTableViewController {
    NSMutableArray *_toDoItems;
    NSMutableArray *_completedItems;
}

static NSString *kCellIdentifier = @"Cell";
static NSString *kInputCellIdentifier = @"InputCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _toDoItems = [[NSMutableArray alloc] init];
    _completedItems = [[NSMutableArray alloc] init];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[TDTableViewCell class]
           forCellReuseIdentifier:kCellIdentifier];
    [self.tableView registerClass:[TDInputTableViewCell class]
           forCellReuseIdentifier:kInputCellIdentifier];
    
    [self readToDosFromDisk];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case INPUT_SECTION:
            return 1; // Add new item section
            break;
            
        case TODO_SECTION:
            return _toDoItems.count; // Pending items section
            break;
            
        case COMPLETE_SECTION:
            return _completedItems.count; // Completed items section
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Input cell
    if(indexPath.section==INPUT_SECTION) {
        TDInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kInputCellIdentifier
                                                                forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }
    
    // To do cells
    else {
        TDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier
                                                                forIndexPath:indexPath];
        TDItem *item = (indexPath.section==TODO_SECTION) ? _toDoItems[[indexPath row]] : _completedItems[[indexPath row]];
        cell.delegate = self;
        cell.todoItem = item;
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == INPUT_SECTION) {
        return 80.0f;
    }
    
    return 60.0f;
}

#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES]; // Dismiss keyboard when table view scrolls
}

#pragma mark - TDTableViewCell delegate methods

- (void)toDoItemDeleted:(id)todoItem
{
    
#ifdef WINOBJC
	[_toDoItems removeObject:todoItem];
    [self.tableView reloadData];
#else
	NSUInteger index = [_toDoItems indexOfObject:todoItem];
    [self.tableView beginUpdates];
    [_toDoItems removeObject:todoItem];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:TODO_SECTION]]
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
#endif
    
    [self writeToDosToDisk];
}

- (void)toDoItemCompleted:(id)todoItem
{
    
#ifdef WINOBJC
	[_toDoItems removeObject:todoItem];
    [_completedItems insertObject:todoItem atIndex:0];
    [self.tableView reloadData];
#else
	NSUInteger index = [_toDoItems indexOfObject:todoItem];
    [self.tableView beginUpdates];
    [_toDoItems removeObject:todoItem];
    [_completedItems insertObject:todoItem atIndex:0];
	[self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:TODO_SECTION]]
                          withRowAnimation:UITableViewRowAnimationLeft];
	[self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:COMPLETE_SECTION]]
                          withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView endUpdates];
#endif
    
    [self writeToDosToDisk];
}

#pragma mark - TDInputTableViewCell delegate methods

- (void)toDoItemAdded:(TDItem*) todoItem
{
    
#ifdef WINOBJC
	[_toDoItems insertObject:todoItem atIndex:0];
    [self.tableView reloadData];
#else
    [self.tableView beginUpdates];
    [_toDoItems insertObject:todoItem atIndex:0];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:TODO_SECTION]]
                          withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
#endif
    
    [self writeToDosToDisk];
}

#pragma mark - Utility

- (IBAction)clearAllTodos:(id)sender
{
    [_toDoItems removeAllObjects];
    [_completedItems removeAllObjects];
    [self.tableView reloadData];
    [self writeToDosToDisk];
}

- (void)writeToDosToDisk
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        NSMutableArray *allItems = [[NSMutableArray alloc] init];
        
        
        [_toDoItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            TDItem *item = obj;
            [allItems addObject:[item serialize]];
        }];
        
        [_completedItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            TDItem *item = obj;
            [allItems addObject:[item serialize]];
        }];
        
        NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documents = [directories firstObject];
        NSString *filePath = [documents stringByAppendingPathComponent:@"todos.plist"];
        
        if([allItems writeToFile:filePath atomically:YES]) {
            NSLog(@"Successfully wrote to dos to disk.");
        }
        
    });
}

- (void)readToDosFromDisk
{
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [directories firstObject];
    NSString *filePath = [documents stringByAppendingPathComponent:@"todos.plist"];
    
    NSArray *loadedToDos = [NSArray arrayWithContentsOfFile:filePath];
    [loadedToDos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dict = obj;
        NSString *string = [[dict allKeys] firstObject];
        BOOL complete = ((NSNumber*)[[dict allValues] firstObject]).boolValue;
        TDItem *toDo = [TDItem todoItemWithText:string isComplete:complete];
        
        if(toDo.completed) {
            [_completedItems addObject:toDo];
        }
        
        else {
            [_toDoItems addObject:toDo];
        }
    }];
    
    [self.tableView reloadData];
}

@end
