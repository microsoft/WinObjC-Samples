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
#ifndef APINetworkOps_h
#define APINetworkOps_h

#import "AddressManager.h"
#import "CryptoOps.h"
#import <Foundation/Foundation.h>


@interface APINetworkOps : NSObject

+ (void)generateAddressAndAddToAddressManagerWithTag:(NSString*)tag;
+ (NSData*)generatePartialTXWithInput:(NSString*)input andOutput:(NSString*)output andValue:(NSNumber*)val;
+ (NSString*)sendCompletedTransaction:(NSData*)transactionData forAddress:(NSString*)addressName;
+ (NSString*)getTXSkeletonWithData:(NSData*)jsonSkeleton;
+ (NSDictionary*)getTXHashInfo:(NSString*)hash;

@end


#endif /* APINetworkOps_h */
