//
//  MainViewController.m
//  iOSReachability
//
//  Created by Luis Meddrano-Zaldivar on 4/24/17.
//  Copyright © 2017 Luis Meddrano-Zaldivar. All rights reserved.
//

#import "MainViewController.h"
#import "ReachabilityViewController.h"


@interface MainViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *content;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UILabel *mainLabel;


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self generatingListOfContentForTableView];
    [self generatingTitleLabel];
    [self configTableView];
    [self configUILayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)generatingListOfContentForTableView
{
    self.content = @[@"Test Reachability"];
}

-(void)configTableView
{
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.translatesAutoresizingMaskIntoConstraints = false;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _content.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* cellID = @"buttonCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = _content[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.numberOfLines = 0;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    switch (indexPath.row) {
        case 0:
            [[self navigationController] pushViewController:[[ReachabilityViewController alloc] init] animated:true];
            break;
        default:
            break;
    }
}

-(void)configUILayout
{
    NSLayoutConstraint *topCLayoutConstraints = [NSLayoutConstraint constraintWithItem:[self topLayoutGuide]
                                                                             attribute:NSLayoutAttributeBottom
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.mainLabel
                                                                             attribute:NSLayoutAttributeTop
                                                                            multiplier:1.f constant:0.f];
    NSLayoutConstraint *leftCLayoutConstraints = [NSLayoutConstraint constraintWithItem:self.view
                                                                              attribute:NSLayoutAttributeLeft
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.mainLabel
                                                                              attribute:NSLayoutAttributeLeft
                                                                             multiplier:1.f constant:0.f];
    NSLayoutConstraint *rightCLayoutConstraints = [NSLayoutConstraint constraintWithItem:self.view
                                                                               attribute:NSLayoutAttributeRight
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:self.mainLabel
                                                                               attribute:NSLayoutAttributeRight
                                                                              multiplier:1.f constant:0.f];
    NSLayoutConstraint *widthCLayoutConstraints = [NSLayoutConstraint constraintWithItem:self.mainLabel
                                                                               attribute:NSLayoutAttributeBottom
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:[self topLayoutGuide]
                                                                               attribute:NSLayoutAttributeBottom
                                                                              multiplier:1.f constant:40.f];
    
    NSLayoutConstraint *topTLayoutConstraints = [NSLayoutConstraint constraintWithItem:self.tableView
                                                                             attribute:NSLayoutAttributeTop
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.mainLabel
                                                                             attribute:NSLayoutAttributeBottom
                                                                            multiplier:1.f constant:0.f];
    NSLayoutConstraint *leftTLayoutConstraints = [NSLayoutConstraint constraintWithItem:self.tableView
                                                                              attribute:NSLayoutAttributeLeft
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.view
                                                                              attribute:NSLayoutAttributeLeft
                                                                             multiplier:1.f constant:0.f];
    NSLayoutConstraint *rightTLayoutConstraints = [NSLayoutConstraint constraintWithItem:self.tableView
                                                                               attribute:NSLayoutAttributeRight
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:[self view]
                                                                               attribute:NSLayoutAttributeRight
                                                                              multiplier:1.f constant:0.f];
    NSLayoutConstraint *bottomTLayoutConstraints = [NSLayoutConstraint constraintWithItem:self.tableView
                                                                                attribute:NSLayoutAttributeBottom
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:self.view
                                                                                attribute:NSLayoutAttributeBottom
                                                                               multiplier:1.f constant:0.f];
    [self.view addConstraint:topCLayoutConstraints];
    [self.view addConstraint:widthCLayoutConstraints];
    [self.view addConstraint:leftCLayoutConstraints];
    [self.view addConstraint:rightCLayoutConstraints];
    [self.view addConstraint:topCLayoutConstraints];
    [self.view addConstraint:leftTLayoutConstraints];
    [self.view addConstraint:leftTLayoutConstraints];
    [self.view addConstraint:rightCLayoutConstraints];
    [self.view addConstraint:bottomTLayoutConstraints];
    [self.view addConstraint:topTLayoutConstraints];
    [self.view addConstraint:rightTLayoutConstraints];
    
    
}

-(void)generatingTitleLabel
{
    self.mainLabel = [[UILabel alloc] init];
    [self.mainLabel setText:@"iOS Reachability"];
    [self.mainLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.mainLabel setNumberOfLines:0];
    [self.mainLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.mainLabel setBackgroundColor:[UIColor lightGrayColor]];
    [self.mainLabel setTextColor:[UIColor whiteColor]];
    [self.mainLabel setTextAlignment:NSTextAlignmentCenter];
    [[self view] addSubview:self.mainLabel];
}


@end
