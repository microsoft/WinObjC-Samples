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

+(NSString*)convertParseStatusToString:(int)parseStatus {
    switch (parseStatus) {
        case 0:
            return @"SBJson5ParserComplete";
            break;
        case 1:
            return @"SBJson5ParserStopped";
            break;
        case 2:
            return @"SBJson5ParserWaitingForData";
            break;
        case 3:
            return @"SBJson5ParserError";
            break;
        default:
            return @"unknown";
            break;
    }
}

@end
