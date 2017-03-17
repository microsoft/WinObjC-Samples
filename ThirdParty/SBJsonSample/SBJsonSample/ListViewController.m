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

#import "ListViewController.h"
#import "ParserViewController.h"
#import "StreamParserViewController.h"
#import "WriterViewController.h"
#import "StreamWriterViewController.h"

@interface ListViewController (){
    NSArray* buttonArray;
}

@end

@implementation ListViewController

-(void)constructViewWithTableView {
    
    UILabel* label = [[UILabel alloc] init];
    [label setText:@"SBJson5 API Usage Test Application."];
    [label setLineBreakMode:NSLineBreakByWordWrapping];
    [label setNumberOfLines:0];
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    [label setBackgroundColor:[UIColor lightGrayColor]];
    [label setTextColor:[UIColor whiteColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [[self view] addSubview:label];
    
    buttonArray = [[NSArray alloc] initWithObjects:@"SBJson5Parser",@"SBJson5StreamParser",@"SBJson5Writer",@"SBJson5StreamWriter",nil];
    UITableView* APITestTableView = (UITableView*)[[UITableView alloc] init];
    APITestTableView.delegate = self;
    APITestTableView.dataSource = self;
    APITestTableView.translatesAutoresizingMaskIntoConstraints = false;
    APITestTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [[self view] addSubview:APITestTableView];
    
    
    NSLayoutConstraint *topCLayoutConstraints = [NSLayoutConstraint constraintWithItem:[self topLayoutGuide]
                                                                             attribute:NSLayoutAttributeBottom
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:label
                                                                             attribute:NSLayoutAttributeTop
                                                                            multiplier:1.f constant:0.f];
    NSLayoutConstraint *leftCLayoutConstraints = [NSLayoutConstraint constraintWithItem:[self view]
                                                                                attribute:NSLayoutAttributeLeft
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:label
                                                                                attribute:NSLayoutAttributeLeft
                                                                               multiplier:1.f constant:0.f];
    NSLayoutConstraint *rightCLayoutConstraints = [NSLayoutConstraint constraintWithItem:[self view]
                                                                              attribute:NSLayoutAttributeRight
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:label
                                                                              attribute:NSLayoutAttributeRight
                                                                             multiplier:1.f constant:0.f];
    NSLayoutConstraint *widthCLayoutConstraints = [NSLayoutConstraint constraintWithItem:label
                                                                               attribute:NSLayoutAttributeBottom
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:[self topLayoutGuide]
                                                                               attribute:NSLayoutAttributeBottom
                                                                              multiplier:1.f constant:40.f];
    
    NSLayoutConstraint *topTLayoutConstraints = [NSLayoutConstraint constraintWithItem:APITestTableView
                                                                               attribute:NSLayoutAttributeTop
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:label
                                                                               attribute:NSLayoutAttributeBottom
                                                                              multiplier:1.f constant:0.f];
    NSLayoutConstraint *leftTLayoutConstraints = [NSLayoutConstraint constraintWithItem:APITestTableView
                                                                              attribute:NSLayoutAttributeLeft
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:[self view]
                                                                              attribute:NSLayoutAttributeLeft
                                                                             multiplier:1.f constant:0.f];
    NSLayoutConstraint *rightTLayoutConstraints = [NSLayoutConstraint constraintWithItem:APITestTableView
                                                                               attribute:NSLayoutAttributeRight
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:[self view]
                                                                               attribute:NSLayoutAttributeRight
                                                                              multiplier:1.f constant:0.f];
    NSLayoutConstraint *bottomTLayoutConstraints = [NSLayoutConstraint constraintWithItem:APITestTableView
                                                                                attribute:NSLayoutAttributeBottom
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:[self view]
                                                                                attribute:NSLayoutAttributeBottom
                                                                               multiplier:1.f constant:0.f];
    [[self view] addConstraint:topCLayoutConstraints];
    [[self view] addConstraint:widthCLayoutConstraints];
    [[self view] addConstraint:leftCLayoutConstraints];
    [[self view] addConstraint:rightCLayoutConstraints];
    [[self view] addConstraint:topTLayoutConstraints];
    [[self view] addConstraint:leftTLayoutConstraints];
    [[self view] addConstraint:rightTLayoutConstraints];
    [[self view] addConstraint:bottomTLayoutConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self constructViewWithTableView];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    switch (indexPath.row) {
        case 0:            
            [[self navigationController] pushViewController:[[ParserViewController alloc] init] animated:true];
            break;
        case 1:
            [[self navigationController] pushViewController:[[StreamParserViewController alloc] init] animated:true];
            break;
        case 2:
            [[self navigationController] pushViewController:[[WriterViewController alloc] init] animated:true];
            break;
        case 3:
            [[self navigationController] pushViewController:[[StreamWriterViewController alloc] init] animated:true];
            break;
        default:
            break;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [buttonArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* cellID = @"buttonCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [[cell textLabel] setText:[buttonArray objectAtIndex:[indexPath row]]];
    [[cell textLabel] setTextAlignment:NSTextAlignmentCenter];
    [[cell textLabel] setNumberOfLines:0];
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}

@end
