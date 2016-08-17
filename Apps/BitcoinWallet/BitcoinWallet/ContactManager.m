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

#include "ContactManager.h"

@implementation ContactManager : NSObject

static ContactManager *globalManager = nil;

+ (id)globalManager {
    if (globalManager == nil){
        globalManager = [[ContactManager alloc] init];
        return globalManager;
    }
    return globalManager;
}

// create dummy data
- (void)createKeyPairsWithDummyData {
    NSString *line1 = [[NSString alloc]initWithFormat:@"testNetAddr,mv8x2Z64QHWEqi1STgyE3CaLUoiagebTFU\n"];
    [self addKeyPair:line1];
}

// gets mapping of privkey(k) -> (pubkey)(v)
- (NSDictionary*)getKeyPairs {
    // process file kp (private,public)
    NSFileManager *fileman = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docurl = [paths objectAtIndex:0];
    NSString *fileurl = [docurl stringByAppendingString:@"/contacts.txt"];
    NSData *pwdData = [fileman contentsAtPath:fileurl];
    NSString *csvString = [[NSString alloc]initWithData:pwdData encoding:NSUTF8StringEncoding];
    
    NSCharacterSet *splitSet = [NSCharacterSet characterSetWithCharactersInString:@"\n,"];
    NSArray *splitString = [[NSArray alloc] init];
    splitString = [csvString componentsSeparatedByCharactersInSet:splitSet];
    
    NSMutableDictionary *returnDict = [[NSMutableDictionary alloc] init];
    
    // splitstring count is going to be +1 more, since there is a sentinel
    for(int i = 0; i < [splitString count] - 1; i = i + 2){
        id privkey = [splitString objectAtIndex:(i+0)];
        id pubkey = [splitString objectAtIndex:(i+1)];
        [returnDict setObject:pubkey forKey:privkey];
    }
    return returnDict;
}

// assume tags are NAME-. need to append  + toAdd
- (int)addKeyPair:(NSString*)toAdd {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docurl = [paths objectAtIndex:0];
    NSString *fileurl = [docurl stringByAppendingString:@"/contacts.txt"];
    
    // ready addressData
    NSFileManager *fileman = [NSFileManager defaultManager];
    NSData *dat1 = [fileman contentsAtPath:fileurl];
    NSData *toWrite = [NSData dataWithBytes:[toAdd UTF8String] length:[toAdd length]];
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

