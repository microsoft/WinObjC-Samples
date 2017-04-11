//******************************************************************************
//
// Copyright (c) 2017 Microsoft Corporation. All rights reserved.
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

#import "DeserializeViewController.h"
#import "NSStringDeserializeViewController.h"
#import "NSDataDeserializeViewController.h"

@interface DeserializeViewController ()

@end

@implementation DeserializeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.buttonArray = [[NSArray alloc] initWithObjects:@"NSString",@"NSArray",nil];
    [self constructViewWithTableView];
    [self setTitle:@"Deserialize"];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    switch (indexPath.row) {
        case 0:
            [[self navigationController] pushViewController:[[NSStringDeserializeViewController alloc] init] animated:true];
            break;
        case 1:
            [[self navigationController] pushViewController:[[NSDataDeserializeViewController alloc] init] animated:true];
            break;
        default:
            break;
    }
}

@end
