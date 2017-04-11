//
//  SerializingViewController.m
//  Middleware-JsonKit
//
//  Created by venkat kongara on 4/3/17.
//  Copyright © 2017 microsoft. All rights reserved.
//

#import "SerializingViewController.h"
#import "NSStringSerializeViewController.h"
#import "NSArraySerializeViewController.h"
#import "NSDictionarySerializeViewController.h"

@interface SerializingViewController ()

@end

@implementation SerializingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.buttonArray = [[NSArray alloc] initWithObjects:@"NSString",@"NSArray",@"NSDictionary",nil];
    [self constructViewWithTableView];
    [self setTitle:@"Serialize"];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    switch (indexPath.row) {
        case 0:
            [[self navigationController] pushViewController:[[NSStringSerializeViewController alloc] init] animated:true];
            break;
        case 1:
            [[self navigationController] pushViewController:[[NSArraySerializeViewController alloc] init] animated:true];
            break;
        case 2:
            [[self navigationController] pushViewController:[[NSDictionarySerializeViewController alloc] init] animated:true];
            break;
        default:
            break;
    }
}

@end
