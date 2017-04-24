//
//  BaseTableView.m
//  ObjCTableViewNoNib
//
//  Created by Luis Meddrano-Zaldivar on 4/21/17.
//  Copyright © 2017 Luis Meddrano-Zaldivar. All rights reserved.
//

#import "BaseTableView.h"

@interface BaseTableView ()

@property (nonatomic,strong) UIView *topContainer;
@property (nonatomic,strong) UIView *bottomContainer;
@property (nonatomic,strong) UIButton *deleteLogButton;

@end

@implementation BaseTableView


-(void)configurePropertiesAndViews
{
    [self settingProperties];
    [self loadingViews];
    [self settingUIConstrains];

}

#pragma tableView/UITextView delegate methods:

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return NO;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.content.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:self.content[indexPath.row]];
    CGRect rect = [str boundingRectWithSize:CGSizeMake(100, 100) options:NSStringDrawingUsesDeviceMetrics context:nil];
    return rect.size.height + 40;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* cellID = @"buttonCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = self.content[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (void)clearLogFromTextView {
    void (^block)() = ^{
        @synchronized(self) {
            self.bufferedOutText = [[NSMutableAttributedString alloc] initWithString:@"\n"];
            self.delegateOutputTextView.text = @"";
        }
    };
    dispatch_async(dispatch_get_main_queue(), block);
}

- (void)appendToPrintBuffer:(id)format, ... {
    va_list ap;
    va_start(ap, format);
    
    NSString* newString = [[NSString alloc] initWithFormat:[format description] arguments:ap];
    void (^block)() = ^{
        @synchronized(self.bufferedOutText) {
            if ([format isKindOfClass:[NSAttributedString class]]) {
                [self.bufferedOutText appendAttributedString:format];
                [self.bufferedOutText appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
            }else {
                [self.bufferedOutText appendAttributedString:[[NSAttributedString alloc] initWithString:newString]];
                [self.bufferedOutText appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
            }
        }
    };
    dispatch_async(dispatch_get_main_queue(), block);
    va_end(ap);
}

-(void)printColoredDebugInfo:(NSString*) string using:(UIColor*)color {
    __weak typeof(self) weakSelf = self;
    NSMutableAttributedString *printString = [[NSMutableAttributedString alloc] init];
    [printString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", string]]];
    [printString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, [printString length])];
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf appendToPrintBuffer:printString];
    });
}

-(void)printAndscrollDelegateTextViewToBottom {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableAttributedString* textViewString = [self.delegateOutputTextView.attributedText mutableCopy];
        [textViewString appendAttributedString:self.bufferedOutText];
        self.delegateOutputTextView.attributedText = textViewString;
        if(_bufferedOutText.length > 0 ) {
            NSRange bottom = NSMakeRange(self.delegateOutputTextView.text.length -1, 1);
            [self.delegateOutputTextView scrollRangeToVisible:bottom];
            self.bufferedOutText = [[NSMutableAttributedString alloc] initWithString:@"\n"];
        }
    });
}

-(void)settingUIConstrains
{
    NSLayoutConstraint *topContainerTopLayoutConstraints = [NSLayoutConstraint constraintWithItem:self.view
                                                                                        attribute:NSLayoutAttributeTop
                                                                                        relatedBy:NSLayoutRelationEqual
                                                                                           toItem:self.topContainer
                                                                                        attribute:NSLayoutAttributeTop
                                                                                       multiplier:1.f constant:0.f];
    NSLayoutConstraint *topContainerBottomLayoutConstraints = [NSLayoutConstraint constraintWithItem:self.topContainer
                                                                                           attribute:NSLayoutAttributeBottom
                                                                                           relatedBy:NSLayoutRelationEqual
                                                                                              toItem:self.bottomContainer
                                                                                           attribute:NSLayoutAttributeTop
                                                                                          multiplier:1.f constant:0.f];
    NSLayoutConstraint *topContainerLeftLayoutConstraints = [NSLayoutConstraint constraintWithItem:self.view
                                                                                         attribute:NSLayoutAttributeLeft
                                                                                         relatedBy:NSLayoutRelationEqual
                                                                                            toItem:self.topContainer
                                                                                         attribute:NSLayoutAttributeLeft
                                                                                        multiplier:1.f constant:0.f];
    NSLayoutConstraint *topContainerRightLayoutConstraints = [NSLayoutConstraint constraintWithItem:self.view
                                                                                          attribute:NSLayoutAttributeRight
                                                                                          relatedBy:NSLayoutRelationEqual
                                                                                             toItem:self.topContainer
                                                                                          attribute:NSLayoutAttributeRight
                                                                                         multiplier:1.f constant:0.f];
    
    NSLayoutConstraint *bottomContainerHeightLayoutConstraints = [NSLayoutConstraint constraintWithItem:self.bottomContainer
                                                                                              attribute:NSLayoutAttributeHeight
                                                                                              relatedBy:NSLayoutRelationEqual
                                                                                                 toItem:nil
                                                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                                                             multiplier:1.f constant:350.f];
    NSLayoutConstraint *bottomContainerleftLayoutConstraints = [NSLayoutConstraint constraintWithItem:self.view
                                                                                            attribute:NSLayoutAttributeLeft
                                                                                            relatedBy:NSLayoutRelationEqual
                                                                                               toItem:self.bottomContainer
                                                                                            attribute:NSLayoutAttributeLeft
                                                                                           multiplier:1.f constant:0.f];
    NSLayoutConstraint *bottomContainerRightLayoutConstraints = [NSLayoutConstraint constraintWithItem:self.view
                                                                                             attribute:NSLayoutAttributeRight
                                                                                             relatedBy:NSLayoutRelationEqual
                                                                                                toItem:self.bottomContainer
                                                                                             attribute:NSLayoutAttributeRight
                                                                                            multiplier:1.f constant:0.f];
    NSLayoutConstraint *bottomContainerBottomLayoutConstraints = [NSLayoutConstraint constraintWithItem:self.bottomContainer
                                                                                              attribute:NSLayoutAttributeBottom
                                                                                              relatedBy:NSLayoutRelationEqual
                                                                                                 toItem:self.view
                                                                                              attribute:NSLayoutAttributeBottom
                                                                                             multiplier:1.f constant:0.f];
    
    NSDictionary *topContainerviews = NSDictionaryOfVariableBindings(_tableView);
    [self.topContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                  @"H:|[_tableView]|" options:0 metrics:nil views:topContainerviews]];
    [self.topContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                  @"V:|-40-[_tableView]-0-|" options:0 metrics:nil views:topContainerviews]];
    
    NSDictionary *bottomContainerViews = NSDictionaryOfVariableBindings(_delegateOutputTextView);
    [self.bottomContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                     @"H:|[_delegateOutputTextView]|" options:0 metrics:nil views:bottomContainerViews]];
    [self.bottomContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                     @"V:|[_delegateOutputTextView]|" options:0 metrics:nil views:bottomContainerViews]];
    
    [self.view addConstraint:topContainerTopLayoutConstraints];
    [self.view addConstraint:topContainerBottomLayoutConstraints];
    [self.view addConstraint:topContainerLeftLayoutConstraints];
    [self.view addConstraint:topContainerRightLayoutConstraints];
    [self.view addConstraint:bottomContainerHeightLayoutConstraints];
    [self.view addConstraint:bottomContainerleftLayoutConstraints];
    [self.view addConstraint:bottomContainerRightLayoutConstraints];
    [self.view addConstraint:bottomContainerBottomLayoutConstraints];
    
    NSLayoutConstraint *topDLayoutConstraints = [NSLayoutConstraint constraintWithItem:self.bottomContainer
                                                                             attribute:NSLayoutAttributeTop
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.deleteLogButton
                                                                             attribute:NSLayoutAttributeTop
                                                                            multiplier:1.f constant:0.f];
    NSLayoutConstraint *widthDLayoutConstraints = [NSLayoutConstraint constraintWithItem:self.deleteLogButton
                                                                               attribute:NSLayoutAttributeWidth
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:nil
                                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                                              multiplier:1.f constant:60.f];
    NSLayoutConstraint *heightDLayoutConstraints = [NSLayoutConstraint constraintWithItem:self.deleteLogButton
                                                                                attribute:NSLayoutAttributeHeight
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:nil
                                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                                               multiplier:1.f constant:40.f];
    
#if WINOBJC
    NSLayoutConstraint *rightDLayoutConstraints = [NSLayoutConstraint constraintWithItem:_deleteLogButton
                                                                               attribute:NSLayoutAttributeRightMargin
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:_bottomContainer
                                                                               attribute:NSLayoutAttributeRightMargin
                                                                              multiplier:1.f constant:-12.f];
    
#else
    NSLayoutConstraint *rightDLayoutConstraints = [NSLayoutConstraint constraintWithItem:self.deleteLogButton
                                                                               attribute:NSLayoutAttributeRightMargin
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:self.bottomContainer
                                                                               attribute:NSLayoutAttributeRightMargin
                                                                              multiplier:1.f constant:0.f];
    
#endif
    
    [self.bottomContainer addConstraint:widthDLayoutConstraints];
    [self.bottomContainer addConstraint:heightDLayoutConstraints];
    [self.bottomContainer addConstraint:topDLayoutConstraints];
    [self.bottomContainer addConstraint:rightDLayoutConstraints];
}

-(void)loadingViews
{
    [self.topContainer addSubview:self.tableView];
    [self.bottomContainer addSubview:self.delegateOutputTextView];
    [self.bottomContainer addSubview:self.deleteLogButton];
    [self.view addSubview:self.topContainer];
    [self.view addSubview:self.bottomContainer];
}

-(void)settingProperties
{
    // Initilization of properties:
    self.bufferedOutText = [[NSMutableAttributedString alloc] init];
    self.topContainer = [[UIView alloc] init];
    self.tableView = [[UITableView alloc] init];
    self.bottomContainer = [[UIView alloc] init];
    self.deleteLogButton = [[UIButton alloc] init];
    self.delegateOutputTextView = [[UITextView alloc] init];
    
    //Config tableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.translatesAutoresizingMaskIntoConstraints = false;
    self.tableView.tableFooterView  = [[UIView alloc] initWithFrame:CGRectZero];
    
    //Config topContainer:
    self.topContainer.translatesAutoresizingMaskIntoConstraints = false;
    self.topContainer.tag = 111;
    self.topContainer.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    
    //Config bottomContainer:
    self.bottomContainer.translatesAutoresizingMaskIntoConstraints = false;
    self.bottomContainer.tag = 222;
    
    //Config delegateOutputTextView:
    
    self.delegateOutputTextView.translatesAutoresizingMaskIntoConstraints = false;
    self.delegateOutputTextView.backgroundColor = [UIColor whiteColor];
    self.delegateOutputTextView.editable = NO;
    self.delegateOutputTextView.delegate = self;
    
    //Config deleteLogButton
    self.deleteLogButton.backgroundColor = [UIColor redColor];
    self.deleteLogButton.translatesAutoresizingMaskIntoConstraints = false;
    [self.deleteLogButton setTitle:@"clear" forState:UIControlStateNormal];
    [self.deleteLogButton addTarget:self action:@selector(clearLogFromTextView) forControlEvents:UIControlEventTouchDown];
    
}

@end
