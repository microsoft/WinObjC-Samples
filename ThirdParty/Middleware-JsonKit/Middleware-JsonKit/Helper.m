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

#import "Helper.h"

@implementation Helper

+(Organization*)getAvengersOrganizationModel{
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

+(NSString*)getJSONStringFromModel{
    //TBD. do this return in a better way.
    return @"{\"organizationName\":\"Avengers\",\"people\":[{\"personIdentification\":{\"speciality\":\"thunder god\",\"UUID\":9987654},\"personalDetails\":{\"name\":\"Thor\",\"phone\":1111111111111,\"email\":\"thor@avengers.com\"}},{\"personIdentification\":{\"speciality\":\"excessively smart man in a smart and strong suit\",\"UUID\":9987654},\"personalDetails\":{\"name\":\"ironMan\",\"phone\":1111111111111,\"email\":\"tony@avengers.com\"}},{\"personIdentification\":{\"speciality\":\"Angry Jumbo\",\"UUID\":99878798},\"personalDetails\":{\"name\":\"hulk\",\"phone\":1111111111111,\"email\":\"hulk@avengers.com\"}},{\"personIdentification\":{\"speciality\":\"Icredible ability to control hulk and fight\",\"UUID\":9900014848},\"personalDetails\":{\"name\":\"blackWidow\",\"phone\":1111111111111,\"email\":\"blackWidow@avengers.com\"}},{\"personIdentification\":{\"speciality\":\"gymnast with a sheild\",\"UUID\":99878798},\"personalDetails\":{\"name\":\"captainAmerica\",\"phone\":1111111111111,\"email\":\"captain@avengers.com\"}},{\"personIdentification\":{\"speciality\":\"hawks eye at shooting targets\",\"UUID\":9900014848},\"personalDetails\":{\"name\":\"hawkEye\",\"phone\":1111111111111,\"email\":\"hawkEye@avengers.com\"}}]}";
}

@end
