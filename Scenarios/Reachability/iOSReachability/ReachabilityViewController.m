//
//  ReachabilityViewController.m
//  iOSReachability
//
//  Created by Luis Meddrano-Zaldivar on 4/24/17.
//  Copyright © 2017 Luis Meddrano-Zaldivar. All rights reserved.
//

#import "ReachabilityViewController.h"
#import "Reachability.h"


@interface ReachabilityViewController ()

@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;

@end

@implementation ReachabilityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Testing Reachability";
    self.content = @[@"Reachability Output:"];
    [self configurePropertiesAndViews];
    [self configAndSettingReachability];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kReachabilityChangedNotification
                                                  object:nil];
}

-(void)configAndSettingReachability
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    NSString *remoteHostName = @"luduscella.com";
    NSString *remoteHostLabelFormatString = NSLocalizedString(@"Remote Host: %@", @"Remote host label format string");
    [self logToBottonView:[NSString stringWithFormat:remoteHostLabelFormatString, remoteHostName]];
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [self.hostReachability startNotifier];
    [self updateInterfaceWithReachability:self.hostReachability];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self updateInterfaceWithReachability:self.internetReachability];
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    if (reachability == self.hostReachability)
    {
        [self updateReachabilityStatus:reachability];
        BOOL connectionRequired = [reachability connectionRequired];
        
        NSString *baseLabelText = @"";
        
        if (connectionRequired)
        {
            baseLabelText = NSLocalizedString(@"Cellular data network is available.\nInternet traffic will be routed through it after a connection is established.", @"Reachability text if a connection is required");
        }
        else
        {
            baseLabelText = NSLocalizedString(@"Cellular data network is active.\nInternet traffic will be routed through it.", @"Reachability text if a connection is not required");
        }
        [self logToBottonView:baseLabelText];
    }
    
    if (reachability == self.internetReachability)
    {
        [self updateReachabilityStatus:reachability];
    }
}

-(void)updateReachabilityStatus:(Reachability *)reachability
{
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    BOOL connectionRequired = [reachability connectionRequired];
    NSString *statusString = @"";
    
    switch (netStatus)
    {
        case NotReachable:        {
            statusString = NSLocalizedString(@"Access Not Available", @"Text field text for access is not available");
            
            connectionRequired = NO;
            break;
        }
        case ReachableViaWWAN:        {
            statusString = NSLocalizedString(@"Reachable WWAN", @"");
            
            break;
        }
        case ReachableViaWiFi:        {
            statusString= NSLocalizedString(@"Reachable WiFi", @"");
            break;
        }
    }
    if (connectionRequired)
    {
        NSString *connectionRequiredFormatString = NSLocalizedString(@"%@, Connection Required", @"Concatenation of status string with connection requirement");
        statusString= [NSString stringWithFormat:connectionRequiredFormatString, statusString];
    }
    
    [self logToBottonView:statusString];
}

- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

-(void)logToBottonView:(NSString*)msg
{
    __weak typeof(self) weakSelf = self;
    NSLog(@"%@",msg);
    [weakSelf appendToPrintBuffer:msg];
    [weakSelf printAndscrollDelegateTextViewToBottom];
    
}




@end
