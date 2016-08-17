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

#import "APINetworkOps.h"

@implementation APINetworkOps : NSObject

// API Access token for blockcypher restful api
static NSString* apiAccessToken = @"YOUR_BLOCKCYPHER_TOKEN_HERE";

+ (void)generateAddressAndAddToAddressManagerWithTag:(NSString*)tag {
  
    NSString *urlString = [NSString stringWithFormat:@"https://api.blockcypher.com/v1/btc/test3/addrs"];
    NSURL *apiURL =  [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:apiURL];
    [request setHTTPMethod:@"POST"];
    
    NSURLSessionDataTask *tsk = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *stringreturned = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];        
        NSDictionary *jsonData = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:nil error:nil];
        NSString *privateKey = [jsonData objectForKey:@"private"];
        NSString *publicKey = [jsonData objectForKey:@"public"];
        NSString *address = [jsonData objectForKey:@"address"];
        NSString *finalTag = [NSString stringWithFormat:@"%@-",tag];
        NSString *finalData = [NSString stringWithFormat:@"%@,%@,%@\n",privateKey,address,publicKey];
        AddressManager *addrMan = [AddressManager globalManager];
        [addrMan addKeyPair:finalData withTag:finalTag];
    }];
    [tsk resume];
    
}

// get intermediate transaction in blockcypher 2 step transaction
+ (NSString*)getTXSkeletonWithData:(NSData*)jsonSkeleton {
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.blockcypher.com/v1/btc/test3/txs/new"];
    NSURL *apiURL =  [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:apiURL];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:jsonSkeleton];
    __block NSString* retVal = nil;
    
    NSURLSessionDataTask *tsk = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *err = '\0';
		NSString *test = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] retain];
        NSDictionary *jsonData = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:nil error:&err];
            NSData *translatedData = [NSJSONSerialization dataWithJSONObject:jsonData options:0 error:nil];
            retVal = [[[NSString alloc] initWithData:translatedData encoding:NSUTF8StringEncoding] retain];        
    }];
    
    [tsk resume];
    while (retVal == nil) {}
    return retVal;
    
}

// generate initial input to blockcypher 2 step transaction
+ (NSData*)generatePartialTXWithInput:(NSString*)input andOutput:(NSString*)output andValue:(NSNumber*)val; {
    NSMutableDictionary *rootObj = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *inTX = [[NSMutableDictionary alloc]init];
    NSArray *originAddresses = @[input];
    [inTX setValue:originAddresses forKey:@"addresses"];
    NSMutableDictionary *outTX = [[NSMutableDictionary alloc]init];
    NSArray *destAddresses = @[output];
    [outTX setValue:destAddresses forKey:@"addresses"];
    [outTX setValue:val forKey:@"value"];
    
    // inputs and outputs are in the root of the object, they are arrays
    // assemble root objects
    [rootObj setObject:@[inTX] forKey:@"inputs"];
    [rootObj setObject:@[outTX] forKey:@"outputs"];
    
    // check json validity
    if([NSJSONSerialization isValidJSONObject:rootObj]){
        // create json object
        NSData *dictJSON = [NSJSONSerialization dataWithJSONObject:rootObj options:0 error:nil];
        NSString *jsonStr = [[NSString alloc]initWithData:dictJSON encoding:NSUTF8StringEncoding];
        return dictJSON;
    }else {
        return nil;
    }

    
    
}

// sign completed transaction and send to blockcypher propogation endpoint
+ (NSString*)sendCompletedTransaction:(NSData*)transactionData forAddress:(NSString*)addressName {
    NSString *urlString = [NSString stringWithFormat:@"https://api.blockcypher.com/v1/btc/test3/txs/send?token=%@",apiAccessToken];
    NSURL *apiURL =  [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:apiURL];
    
    // string from data
    NSString *toPrint = [[NSString alloc]initWithData:transactionData encoding:NSUTF8StringEncoding];
    // get address information
    AddressManager *addrMan = [AddressManager globalManager];
    NSDictionary *nameToPubKey = [addrMan getTagToHexEncodedPubKeyMap];
    NSString *hexPubKey = [nameToPubKey objectForKey:addressName];
    NSArray *pubkeyArray = @[hexPubKey];    
    NSMutableArray *orderedSignedHashes = [[NSMutableArray alloc] init];
    
    // get dict from json
    NSMutableDictionary *partialTX = (NSMutableDictionary*)[NSJSONSerialization JSONObjectWithData:transactionData options:NSJSONReadingMutableContainers error:nil];
    NSArray *toSignArr = [partialTX objectForKey:@"tosign"];
    for (NSString *unsignedHash in toSignArr) {
        NSString *signedHash = [CryptoOps signData:unsignedHash withAddress:addressName];
        [orderedSignedHashes addObject:signedHash];
        
    }
    
    // add the signed hashes and the pubkeys
	// do data signing, marshall pubkeys

    [partialTX setObject:orderedSignedHashes forKey:@"signatures"];
    [partialTX setObject:pubkeyArray forKey:@"pubkeys"];
    NSData *finalTX = [NSJSONSerialization dataWithJSONObject:partialTX options:0 error:nil];
    NSString *finalTXStr = [[NSString alloc]initWithData:finalTX encoding:NSUTF8StringEncoding];

    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:finalTX];
    __block NSString* retVal = nil;
        
    NSURLSessionDataTask *tsk = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *stringreturned = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        retVal = [stringreturned retain];
    }];
    
    [tsk resume];
    while (retVal == nil) {}
    return retVal;
    
}

// get the hash info from this transaction hash
+ (NSDictionary*)getTXHashInfo:(NSString*)hash {
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.blockcypher.com/v1/btc/test3/txs/%@",hash];
    NSURL *apiURL =  [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:apiURL];
    [request setHTTPMethod:@"GET"];
    __block NSDictionary* retVal = nil;
    
    NSURLSessionDataTask *tsk = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *err;
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *jsonData = [(NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:nil error:&err] retain];
        if (err){
            retVal = [[NSDictionary alloc]init];
        } else {
            retVal = jsonData;
        }
    }];
    
    [tsk resume];
    while (retVal == nil) {}
    return retVal;
    
}

// Unused method? This is similar if not the same as above 
+ (NSString*)scanTXFor:(NSString*)hash {
    NSString *urlString = [NSString stringWithFormat:@"https://api.blockcypher.com/v1/btc/test3/txs/%@",hash];
    NSURL *apiURL =  [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:apiURL];
    [request setHTTPMethod:@"GET"];
    __block NSDictionary* retVal = nil;
    
    NSURLSessionDataTask *tsk = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *err;
        NSDictionary *jsonData = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:nil error:&err];
        if (err){
        } else {
            retVal = jsonData;
        }
    }];
    
    [tsk resume];
    while (retVal == nil) {}
    return retVal;
    
}






@end
