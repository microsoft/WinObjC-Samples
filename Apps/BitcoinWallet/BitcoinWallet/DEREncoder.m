//
//  Found at ricmoo/GMEllipticCurveCrypto on github
//
//  BSD 2-Clause License
//
//  Copyright (c) 2014 Richard Moore.
//
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification,
//  are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this
//     list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice,
//     this list of conditions and the following disclaimer in the documentation
//     and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
//  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
//  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
//  NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
//  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
//  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//

#import "DEREncoder.h"

@implementation DEREncoder 

+ (NSData*) derEncodeInteger:(NSData*)value {

    int length = [value length];
    const unsigned char *data = [value bytes];
    int outputIndex = 0;
    unsigned char output[[value length] + 3];
    output[outputIndex++] = 0x02;


    // Find the first non-zero entry in value
    int start = 0;
    while (start < length && data[start] == 0){ start++; }

    // Add the length and zero padding to preserve sign
    if (start == length || data[start] >= 0x80) {
        output[outputIndex++] = length - start + 1;
        output[outputIndex++] = 0x00;
    } else {
        output[outputIndex++] = length - start;
    }

    [value getBytes:&output[outputIndex] range:NSMakeRange(start, length - start)];
    outputIndex += length - start;
    return [NSData dataWithBytes:output length:outputIndex];

}



+ (NSData*) derEncodeSignature:(NSData*)signature {
    int length = [signature length];
    if (length % 2) { return nil; }
    NSData *rValue = [self derEncodeInteger:[signature subdataWithRange:NSMakeRange(0, length / 2)]];
    NSData *sValue = [self derEncodeInteger:[signature subdataWithRange:NSMakeRange(length / 2, length / 2)]];
    
	// Begin with the sequence tag and sequence length
    unsigned char header[2];
    header[0] = 0x30;
    header[1] = [rValue length] + [sValue length];

    // This requires a long definite octet stream (signatures aren't this long)
    if (header[1] >= 0x80) { return nil; }
    NSMutableData *encoded = [NSMutableData dataWithBytes:header length:2];
    [encoded appendData:rValue];
    [encoded appendData:sValue];
    return [encoded copy];

}

@end
