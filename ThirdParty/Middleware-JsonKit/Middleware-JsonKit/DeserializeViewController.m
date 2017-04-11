//
//  DeserializeViewController.m
//  Middleware-JsonKit
//
//  Created by venkat kongara on 4/3/17.
//  Copyright © 2017 microsoft. All rights reserved.
//

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
