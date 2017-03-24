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

#import "WriterViewController.h"
#import "Organization.h"

@interface WriterViewController ()
@end

@implementation WriterViewController

-(void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    switch (indexPath.row) {
        case 0: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [weakSelf createJsonStringFromModel];
            });
            break;
        }
        case 1: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [weakSelf createJsonDataFromModel];
            });
            break;
        }
        case 2: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [weakSelf createJsonStringFromModelBySortingKeysWithLength];
            });
            break;
        }
        case 3: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [weakSelf createJsonDataFromModelBySortingKeysWithLength];
            });
            break;
        }
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.buttonArray = [[NSArray alloc] initWithObjects:@"create Avengers JSON string with sorted keys from Model Object",@"create Avengers JSON data with sorted keys from model object",@"create Avengers JSON string with custom sorted keys by length from Model Object",@"create Avengers JSON data with custom sorted keys by length from model object",nil];
    [self constructViewWithTableView];
    [self setTitle:@"SBJson5Writer"];
}

-(Organization*)getAvengersOrganizationModel{
    PersonalDetails* thorPersonalDetails = [[PersonalDetails alloc] init];
    thorPersonalDetails.name = @"Thor";
    thorPersonalDetails.phone = 1111111111111;
    thorPersonalDetails.email = @"thor@avengers.com";
    
    PersonIdentification* thorIdentification = [[PersonIdentification alloc] init];
    thorIdentification.identifier = 9987654;
    thorIdentification.speciality = @"thunder god";
    
    Person* thor = [[Person alloc] init];
    thor.personalDetails = thorPersonalDetails;
    thor.personIdentification = thorIdentification;
    
    PersonalDetails* ironManPersonalDetails = [[PersonalDetails alloc] init];
    ironManPersonalDetails.name = @"ironMan";
    ironManPersonalDetails.phone = 1111111111111;
    ironManPersonalDetails.email = @"tony@avengers.com";
    
    PersonIdentification* ironManIdentification = [[PersonIdentification alloc] init];
    ironManIdentification.identifier = 9987654;
    ironManIdentification.speciality = @"excessively smart man in a smart and strong suit";
    
    Person* ironMan = [[Person alloc] init];
    ironMan.personalDetails = ironManPersonalDetails;
    ironMan.personIdentification = ironManIdentification;
    
    PersonalDetails* hulkPersonalDetails = [[PersonalDetails alloc] init];
    hulkPersonalDetails.name = @"hulk";
    hulkPersonalDetails.phone = 1111111111111;
    hulkPersonalDetails.email = @"hulk@avengers.com";
    
    PersonIdentification* hulkIdentification = [[PersonIdentification alloc] init];
    hulkIdentification.identifier = 99878798;
    hulkIdentification.speciality = @"Angry Jumbo";
    
    Person* hulk = [[Person alloc] init];
    hulk.personalDetails = hulkPersonalDetails;
    hulk.personIdentification = hulkIdentification;
    
    PersonalDetails* captainAmericaPersonalDetails = [[PersonalDetails alloc] init];
    captainAmericaPersonalDetails.name = @"captainAmerica";
    captainAmericaPersonalDetails.phone = 1111111111111;
    captainAmericaPersonalDetails.email = @"captain@avengers.com";
    
    PersonIdentification* captainAmericaIdentification = [[PersonIdentification alloc] init];
    captainAmericaIdentification.identifier = 99878798;
    captainAmericaIdentification.speciality = @"gymnast with a sheild";
    
    Person* captainAmerica = [[Person alloc] init];
    captainAmerica.personalDetails = captainAmericaPersonalDetails;
    captainAmerica.personIdentification = captainAmericaIdentification;
    
    PersonalDetails* blackWidowPersonalDetails = [[PersonalDetails alloc] init];
    blackWidowPersonalDetails.name = @"blackWidow";
    blackWidowPersonalDetails.phone = 1111111111111;
    blackWidowPersonalDetails.email = @"blackWidow@avengers.com";
    
    PersonIdentification* blackWidowIdentification = [[PersonIdentification alloc] init];
    blackWidowIdentification.identifier = 9900014848;
    blackWidowIdentification.speciality = @"Icredible ability to control hulk and fight";
    
    Person* blackWidow = [[Person alloc] init];
    blackWidow.personalDetails = blackWidowPersonalDetails;
    blackWidow.personIdentification = blackWidowIdentification;
    
    PersonalDetails* hawkEyePersonalDetails = [[PersonalDetails alloc] init];
    hawkEyePersonalDetails.name = @"hawkEye";
    hawkEyePersonalDetails.phone = 1111111111111;
    hawkEyePersonalDetails.email = @"hawkEye@avengers.com";
    
    PersonIdentification* hawkEyeIdentification = [[PersonIdentification alloc] init];
    hawkEyeIdentification.identifier = 9900014848;
    hawkEyeIdentification.speciality = @"hawks eye at shooting targets";
    
    Person* hawkEye = [[Person alloc] init];
    hawkEye.personalDetails = hawkEyePersonalDetails;
    hawkEye.personIdentification = hawkEyeIdentification;

    Organization* organizationModel = [[Organization alloc] init];
    organizationModel.name = @"Avengers";
    organizationModel.people = [[NSArray alloc] initWithObjects:thor,ironMan,hulk,blackWidow,captainAmerica,hawkEye, nil];
    return organizationModel;
}

-(void)createJsonStringFromModel {
    SBJson5Writer* jsonWriter = [SBJson5Writer writerWithMaxDepth:32 humanReadable:true sortKeys:true];
    NSString* jsonString = [jsonWriter stringWithObject:[self getAvengersOrganizationModel]];
    
    NSMutableAttributedString* outString = [[NSMutableAttributedString alloc] init];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"created json string from Avengers Model object :"]]];
    [outString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [outString length])];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" \n%@",jsonString]]];
    [self appendToPrintBuffer:outString];
    [self printAndscrollDelegateTextViewToBottom];
}

-(void)createJsonDataFromModel {
    SBJson5Writer* jsonWriter = [SBJson5Writer writerWithMaxDepth:32 humanReadable:true sortKeys:true];
    NSData* jsonData = [jsonWriter dataWithObject:[self getAvengersOrganizationModel]];
    
    NSMutableAttributedString* outString = [[NSMutableAttributedString alloc] init];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"created json Data from Avengers Model object and the data size is :"]]];
    [outString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [outString length])];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %lu\n",(unsigned long)[jsonData length]]]];
    [self appendToPrintBuffer:outString];
    [self printAndscrollDelegateTextViewToBottom];
}

-(void)createJsonStringFromModelBySortingKeysWithLength {
    SBJson5Writer* jsonWriter = [SBJson5Writer writerWithMaxDepth:32 humanReadable:true sortKeysComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [(NSString*)obj1 length] > [(NSString*)obj2 length];
    }];
    NSString* jsonString = [jsonWriter stringWithObject:[self getAvengersOrganizationModel]];
    
    NSMutableAttributedString* outString = [[NSMutableAttributedString alloc] init];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"created json string from Avengers Model object with keys sorted by their length :"]]];
    [outString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [outString length])];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" \n%@",jsonString]]];
    [self appendToPrintBuffer:outString];
    [self printAndscrollDelegateTextViewToBottom];
}

-(void)createJsonDataFromModelBySortingKeysWithLength {
    SBJson5Writer* jsonWriter = [SBJson5Writer writerWithMaxDepth:32 humanReadable:true sortKeysComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [(NSString*)obj1 length] > [(NSString*)obj2 length];
    }];
    NSData* jsonData = [jsonWriter dataWithObject:[self getAvengersOrganizationModel]];
    
    NSMutableAttributedString* outString = [[NSMutableAttributedString alloc] init];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"created json data from Avengers Model object with keys sorted by their length and the data size is : "]]];
    [outString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [outString length])];
    [outString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %lu\n",(unsigned long)[jsonData length]]]];
    [self appendToPrintBuffer:outString];
    [self printAndscrollDelegateTextViewToBottom];
}

@end
