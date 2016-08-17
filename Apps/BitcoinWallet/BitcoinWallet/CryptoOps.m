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

#import "CryptoOps.h"

@implementation CryptoOps

// sign privbytes with the private key of tag
+ (NSString*)signData:(NSString*)privBytes withAddress:(NSString*)tag {
    
    // get char* representations of privkey
    AddressManager *addrMan = [AddressManager globalManager];
    NSDictionary *tagToPrivDict = [addrMan getTagPrivateKeyMapping];
    NSDictionary *tagToHexPub = [addrMan getTagToHexEncodedPubKeyMap];

    // get correct byte representation of privkey
    NSString *privKey = [tagToPrivDict objectForKey:tag];
    NSData *privkeyAsBytes = [self hexEncodedStringToData:privKey];
    NSData *correctedPrivBytes = [self hexEncodedHashToData:privBytes];
    
    // this needs a char to hex conversion
    // each 2 chars should be interpreted as a byte
	NSData *signedHash;

	// get the ~char representations of our data
	const uint8_t *privateKey = (uint8_t*)[privkeyAsBytes bytes];
	const uint8_t *hashData = (uint8_t*)[correctedPrivBytes bytes];
	uint8_t *result = calloc(100,sizeof(uint8_t));

	// sign with ECC Lib (result is 64 bytes), then DER Encode
	int signingResult = uECC_sign(privateKey,hashData,result);
	NSData* unsignedHash = [[NSData alloc]initWithBytes:result length:64];
	signedHash = [DEREncoder derEncodeSignature:unsignedHash];

    NSString *signedHasAsString = [self dataToHexEncodedString:signedHash];
    return signedHasAsString;
}

// encode utf8 data to data only
+ (NSData*)hexEncodedHashToData:(NSString*)data{
    // priv key always size 32
    int len = [data length]/2.0;
    unsigned char byteArray[len];
    const char *hexEncodedData = [data UTF8String];
    char* tmpPtr = hexEncodedData;
    size_t i;
    
    // iterate over 32 bytes, sscanf 2 chars from byte array, process them
    for (i = 0 ; i < len; i++){
        // scan for 2 unsigned chars (hhx) and interpret them as hex
        sscanf(tmpPtr, "%2hhx",&byteArray[i]);
        // forward the string by 2 char
        tmpPtr = tmpPtr + 2;
    }
    NSData *correctDat = [[NSData alloc]initWithBytes:byteArray length:len];
    return correctDat;
}

// encode utf8 data to data only 
+ (NSData*)hexEncodedStringToData:(NSString*)test{
    // priv key always size 32
    unsigned char byteArray[32];
    const char *hexEncodedPkey = [test UTF8String];
    char* tmpPtr = hexEncodedPkey;
    size_t i;
    
    // iterate over 32 bytes, sscanf 2 chars from byte array, process them
    for (i = 0 ; i < 32; i++){
        // scan for 2 unsigned chars (hhx) and interpret them as hex
        sscanf(tmpPtr, "%2hhx",&byteArray[i]);
        // forward the string by 2 char
        tmpPtr = tmpPtr + 2;
    }
    
    NSData *correctDat = [[NSData alloc]initWithBytes:byteArray length:32];
    return correctDat;
}

// turn data to utf8 string
+ (NSString*)dataToHexEncodedString:(NSData*)test{
    
    NSUInteger len = [test length];
    NSMutableString *toRet = [[NSMutableString alloc]initWithCapacity:(len * 2)];
    
    // undo the above operation, interpret each 4 bits as a char
    const unsigned char *dataBytes = (const unsigned char*)[test bytes];
    for(int i = 0; i < len; i++){
        [toRet appendString:[NSString stringWithFormat:@"%02hhx",dataBytes[i]]];
    }
    return toRet;
    
}

@end
