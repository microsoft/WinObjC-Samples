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
#include "TransactionManager.h"

@implementation TransactionManager

static TransactionManager *globalManager;

// transactions will have the signature [recipient,amount(in satoshi),success\n]

+ (id)globalManager {
    if (globalManager == nil){
        globalManager = [[TransactionManager alloc]init];
        return globalManager;
    } else {
        return globalManager;
    }
}

- (void)createKeyPairsWithDummyData {
    NSString *line1 = [[NSString alloc]initWithFormat:@"e6a0e05e79b8534aacfb4298ea54d26bc15e0a0f1ecda63ea7882614fa51a20e\n"];
    NSString *line2 = [[NSString alloc]initWithFormat:@"610d0edae2d813bad3c95d71f43080c17f1dd9234d92caacdcd86df39a1d4670\n"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docurl = [paths objectAtIndex:0];
    NSString *fileurl = [docurl stringByAppendingString:@"/transactions.txt"];
    NSFileManager *fileman = [NSFileManager defaultManager];

    if ([fileman fileExistsAtPath:fileurl]) {
        [fileman removeItemAtPath:fileurl error:nil];
    }
}


- (int)addTransHash:(NSString*)toAdd {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docurl = [paths objectAtIndex:0];
    NSString *fileurl = [docurl stringByAppendingString:@"/transactions.txt"];
    NSFileManager *fileman = [NSFileManager defaultManager];
    
    NSData *dat1 = [fileman contentsAtPath:fileurl];
    NSData *toWrite = [NSData dataWithBytes:[toAdd UTF8String] length:[toAdd length]];
    NSMutableData *concatData = [NSMutableData dataWithData:dat1];
    [concatData appendData:toWrite];
    
    // remove file if it exists
    if ([fileman fileExistsAtPath:fileurl]) {
        [fileman removeItemAtPath:fileurl error:nil];
    }
    
    // write new file with full data
    BOOL filecreat = [fileman createFileAtPath:fileurl contents:concatData attributes:nil];
    if (filecreat) {
		return 1;
    }else {
		return 0;
    }
    
    return 1;
}

// gets mapping of trans hash -> contact who was paid
- (NSDictionary*)getTransHashToContactMap {
    // process file kp (private,public)
    NSFileManager *fileman = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docurl = [paths objectAtIndex:0];
    NSString *fileurl = [docurl stringByAppendingString:@"/transactions.txt"];
    NSData *pwdData = [fileman contentsAtPath:fileurl];
    NSString *csvString = [[NSString alloc]initWithData:pwdData encoding:NSUTF8StringEncoding];
    
    NSCharacterSet *splitSet = [NSCharacterSet characterSetWithCharactersInString:@"\n,"];
    NSArray *splitString = [[NSArray alloc] init];
    splitString = [csvString componentsSeparatedByCharactersInSet:splitSet];
    
    NSMutableDictionary *returnDict = [[NSMutableDictionary alloc] init];
    
    // splitstring count is going to be +1 more, since there is a sentinel
    for(int i = 0; i < [splitString count] - 1; i = i + 3){
        id contact = [splitString objectAtIndex:(i+1)];
        id transaction = [splitString objectAtIndex:(i+2)];
        [returnDict setObject:contact forKey:transaction];
    }
    return returnDict;
}

// gets mapping of trans hash -> address who was paid
- (NSDictionary*)getTransHashToAddressMap {
    // process file kp (private,public)
    NSFileManager *fileman = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docurl = [paths objectAtIndex:0];
    NSString *fileurl = [docurl stringByAppendingString:@"/transactions.txt"];
    NSData *pwdData = [fileman contentsAtPath:fileurl];
    NSString *csvString = [[NSString alloc]initWithData:pwdData encoding:NSUTF8StringEncoding];
    
    NSCharacterSet *splitSet = [NSCharacterSet characterSetWithCharactersInString:@"\n,"];
    NSArray *splitString = [[NSArray alloc] init];
    splitString = [csvString componentsSeparatedByCharactersInSet:splitSet];
    
    NSMutableDictionary *returnDict = [[NSMutableDictionary alloc] init];
    
    // splitstring count is going to be +1 more, since there is a sentinel
    for(int i = 0; i < [splitString count] - 1; i = i + 3){
        id address = [splitString objectAtIndex:(i)];
        id transaction = [splitString objectAtIndex:(i+2)];
        [returnDict setObject:address forKey:transaction];
    }
    return returnDict;
}

// gets mapping of trans hash -> address who was paid
- (NSSet*)getTransactionSet {
    // process file kp (private,public)
    NSFileManager *fileman = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docurl = [paths objectAtIndex:0];
    NSString *fileurl = [docurl stringByAppendingString:@"/transactions.txt"];
    NSData *pwdData = [fileman contentsAtPath:fileurl];
    NSString *csvString = [[NSString alloc]initWithData:pwdData encoding:NSUTF8StringEncoding];
    
    NSCharacterSet *splitSet = [NSCharacterSet characterSetWithCharactersInString:@"\n,"];
    NSArray *splitString = [[NSArray alloc] init];
    splitString = [csvString componentsSeparatedByCharactersInSet:splitSet];
    
    NSMutableSet *returnSet = [[NSMutableSet alloc] init];
    
    // splitstring count is going to be +1 more, since there is a sentinel
    for(int i = 0; i < [splitString count] - 1; i = i + 3){
        id transaction = [splitString objectAtIndex:(i+2)];
        [returnSet addObject:transaction];
    }
    return returnSet;
}




@end
