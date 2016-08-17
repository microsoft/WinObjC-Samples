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
#include "AddressManager.h"



@implementation AddressManager : NSObject 

static AddressManager *globalManager = nil;


// global singleton manager
+ (id)globalManager {
    if (globalManager == nil){
        globalManager = [[AddressManager alloc] init];
        return globalManager;
    }
    return globalManager;
}

// create dummy test data
- (void)createKeyPairsWithDummyData {
    NSString *line1 = [[NSString alloc]initWithFormat:@"bit1,1JdJQftq3kQRTBVBMRJ4dcZe5yBJCuz6MR\n"];
    NSString *tag1 = [[NSString alloc] initWithFormat:@"TEST1-"];
    NSString *line2 = [[NSString alloc]initWithFormat:@"bit2,1wuyDWpAzcz84XBWB5WLzHtHxnHb5Kqwo\n"];
    NSString *tag2 = [[NSString alloc] initWithFormat:@"TEST2-"];
    [self addKeyPair:line1 withTag:tag1];
    [self addKeyPair:line2 withTag:tag2];
}

// gets mapping of privkey(k) -> (pubkey)(v)
- (NSDictionary*)getKeyPairs {
    // process file kp (private,public)
    NSFileManager *fileman = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docurl = [paths objectAtIndex:0];
    NSString *fileurl = [docurl stringByAppendingString:@"/keypairs.txt"];
    NSData *pwdData = [fileman contentsAtPath:fileurl];
    NSString *csvString = [[NSString alloc]initWithData:pwdData encoding:NSUTF8StringEncoding];

    NSCharacterSet *splitSet = [NSCharacterSet characterSetWithCharactersInString:@"-\n,"];
    NSArray *splitString = [[NSArray alloc] init];
    splitString = [csvString componentsSeparatedByCharactersInSet:splitSet];
    
    NSMutableDictionary *returnDict = [[NSMutableDictionary alloc] init];
    
    // splitstring count is going to be +1 more, since there is a sentinel
    for(int i = 0; i < [splitString count] - 1; i = i + 4){
        id privkey = [splitString objectAtIndex:(i+1)];
        id pubkey = [splitString objectAtIndex:(i+2)];
        [returnDict setObject:pubkey forKey:privkey];
    }
    return returnDict;
}

// gets mapping of name(k) -> pubkey(v)
- (NSDictionary*)getKeyTagMapping {
    // process file kp (private,public)
    NSFileManager *fileman = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docurl = [paths objectAtIndex:0];
    NSString *fileurl = [docurl stringByAppendingString:@"/keypairs.txt"];
    NSData *pwdData = [fileman contentsAtPath:fileurl];
    NSString *csvString = [[NSString alloc]initWithData:pwdData encoding:NSUTF8StringEncoding];
    
    NSCharacterSet *splitSet = [NSCharacterSet characterSetWithCharactersInString:@"-\n,"];
    NSArray *splitString = [[NSArray alloc] init];
    splitString = [csvString componentsSeparatedByCharactersInSet:splitSet];
    
    NSMutableDictionary *returnDict = [[NSMutableDictionary alloc] init];
    
    // splitstring count is going to be +1 more, since there is a sentinel
    for(int i = 0; i < [splitString count] - 1; i = i + 4){
        id mappingTag = [splitString objectAtIndex:(i)];
        id pubkey = [splitString objectAtIndex:(i+2)];
        [returnDict setObject:pubkey forKey:mappingTag];
    }
    return returnDict;
}

// gets mapping of name(k) -> privkey(v)
- (NSDictionary*)getTagPrivateKeyMapping {
    // process file kp (private,public)
    NSFileManager *fileman = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docurl = [paths objectAtIndex:0];
    NSString *fileurl = [docurl stringByAppendingString:@"/keypairs.txt"];
    NSData *pwdData = [fileman contentsAtPath:fileurl];
    NSString *csvString = [[NSString alloc]initWithData:pwdData encoding:NSUTF8StringEncoding];
    
    NSCharacterSet *splitSet = [NSCharacterSet characterSetWithCharactersInString:@"-\n,"];
    NSArray *splitString = [[NSArray alloc] init];
    splitString = [csvString componentsSeparatedByCharactersInSet:splitSet];
    
    NSMutableDictionary *returnDict = [[NSMutableDictionary alloc] init];
    
    // splitstring count is going to be +1 more, since there is a sentinel
    for(int i = 0; i < [splitString count] - 1; i = i + 4){
        id mappingTag = [splitString objectAtIndex:(i)];
        id pubkey = [splitString objectAtIndex:(i+1)];
        [returnDict setObject:pubkey forKey:mappingTag];
    }
    return returnDict;
}

// gets mapping of name(k) -> hex encoded pubkey(v)
- (NSDictionary*)getTagToHexEncodedPubKeyMap {
    // process file kp (private,public)
    NSFileManager *fileman = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docurl = [paths objectAtIndex:0];
    NSString *fileurl = [docurl stringByAppendingString:@"/keypairs.txt"];
    NSData *pwdData = [fileman contentsAtPath:fileurl];
    NSString *csvString = [[NSString alloc]initWithData:pwdData encoding:NSUTF8StringEncoding];

    NSCharacterSet *splitSet = [NSCharacterSet characterSetWithCharactersInString:@"-\n,"];
    NSArray *splitString = [[NSArray alloc] init];
    splitString = [csvString componentsSeparatedByCharactersInSet:splitSet];
    
    NSMutableDictionary *returnDict = [[NSMutableDictionary alloc] init];
    
    // splitstring count is going to be +1 more, since there is a sentinel
    for(int i = 0; i < [splitString count] - 1; i = i + 4){
        id mappingTag = [splitString objectAtIndex:(i)];
        id hexPubkey = [splitString objectAtIndex:(i+3)];
        [returnDict setObject:hexPubkey forKey:mappingTag];
    }
    return returnDict;
}

// assume tags are NAME-. need to append  + toAdd 
- (int)addKeyPair:(NSString*)toAdd withTag:(NSString*)keypairTagName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docurl = [paths objectAtIndex:0];
    NSString *fileurl = [docurl stringByAppendingString:@"/keypairs.txt"];
    
    // ready addressData
    NSFileManager *fileman = [NSFileManager defaultManager];
    NSString *finalString = [keypairTagName stringByAppendingString:toAdd];
    NSData *dat1 = [fileman contentsAtPath:fileurl];
    NSData *toWrite = [NSData dataWithBytes:[finalString UTF8String] length:[finalString length]];
    NSMutableData *concatData = [NSMutableData dataWithData:dat1];
    [concatData appendData:toWrite];
    

    // remove keypair file if it exists
    if ([fileman fileExistsAtPath:fileurl]) {
        [fileman removeItemAtPath:fileurl error:nil];
    }
    
    
    // write new file with full data
    BOOL filecreat = [fileman createFileAtPath:fileurl contents:concatData attributes:nil];
    
    return 1;
}




@end

