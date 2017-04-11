#JSONKit Sample Application 

##Setup

This project uses JSONKit as a dependency. The dependency is directky included and it's source code is changed a bit as indicated below:

##Changes made in JSONKIT version 1.4 dependency

Changed 
```
#include <sys/errno.h> to #include <errno.h>

```
imported
```
#import <Foundation/Foundation.h>
```
Defined the type alias

```
#ifdef WINOBJC
typedef unsigned long ssize_t;
#endif

```
Can skip this sanity check.
```
#if (NSUIntegerMax != SIZE_MAX) || (NSIntegerMax != SSIZE_MAX)
//#error JSONKit requires NSInteger and NSUInteger to be the same size as the C 'size_t' type.
#endif

```
Replaced all the occurences of reallocf() c function with _CFReallocf()

Commentd out 
```
va_copy(varArgsListCopy, varArgsList);

```

Follow the steps from WinObjC (https://github.com/Microsoft/WinObjC/#getting-started-with-the-bridge) github repo documentation to create a visual studio solution.

Now Build and run the sample on to Local Machine.

###Coverage
```
+ (id)decoderWithParseOptions:(JKParseOptionFlags)parseOptionFlags;
- (void)clearCache;

- (id)objectWithUTF8String:(const unsigned char *)string length:(NSUInteger)length error:(NSError **)error;
- (id)objectWithData:(NSData *)jsonData;
- (id)mutableObjectWithUTF8String:(const unsigned char *)string length:(NSUInteger)length error:(NSError **)error;
- (id)mutableObjectWithData:(NSData *)jsonData;

////////////
#Deserializing methods
////////////

NSString (JSONKitDeserializing)
    - (id)objectFromJSONStringWithParseOptions:(JKParseOptionFlags)parseOptionFlags error:(NSError **)error;
    - (id)mutableObjectFromJSONStringWithParseOptions:(JKParseOptionFlags)parseOptionFlags error:(NSError **)error;

NSData (JSONKitDeserializing)
    - (id)objectFromJSONDataWithParseOptions:(JKParseOptionFlags)parseOptionFlags error:(NSError **)error;
    - (id)mutableObjectFromJSONDataWithParseOptions:(JKParseOptionFlags)parseOptionFlags error:(NSError **)error;

////////////
#Serializing methods
////////////

NSString (JSONKitSerializing)
    - (NSData *)JSONData;     // Invokes JSONDataWithOptions:JKSerializeOptionNone   includeQuotes:YES
    - (NSData *)JSONDataWithOptions:(JKSerializeOptionFlags)serializeOptions includeQuotes:(BOOL)includeQuotes error:(NSError **)error;
    - (NSString *)JSONString; // Invokes JSONStringWithOptions:JKSerializeOptionNone includeQuotes:YES
    - (NSString *)JSONStringWithOptions:(JKSerializeOptionFlags)serializeOptions includeQuotes:(BOOL)includeQuotes error:(NSError **)error;

NSArray (JSONKitSerializing)
    - (NSData *)JSONData;
    - (NSData *)JSONDataWithOptions:(JKSerializeOptionFlags)serializeOptions error:(NSError **)error;
    - (NSData *)JSONDataWithOptions:(JKSerializeOptionFlags)serializeOptions serializeUnsupportedClassesUsingDelegate:(id)delegate selector:(SEL)selector error:(NSError **)error;
    - (NSString *)JSONString;
    - (NSString *)JSONStringWithOptions:(JKSerializeOptionFlags)serializeOptions error:(NSError **)error;
    - (NSString *)JSONStringWithOptions:(JKSerializeOptionFlags)serializeOptions serializeUnsupportedClassesUsingDelegate:(id)delegate selector:(SEL)selector error:(NSError **)error;


NSDictionary (JSONKitSerializing)
    - (NSData *)JSONData;
    - (NSData *)JSONDataWithOptions:(JKSerializeOptionFlags)serializeOptions error:(NSError **)error;
    - (NSData *)JSONDataWithOptions:(JKSerializeOptionFlags)serializeOptions serializeUnsupportedClassesUsingDelegate:(id)delegate selector:(SEL)selector error:(NSError **)error;
    - (NSString *)JSONString;
    - (NSString *)JSONStringWithOptions:(JKSerializeOptionFlags)serializeOptions error:(NSError **)error;
    - (NSString *)JSONStringWithOptions:(JKSerializeOptionFlags)serializeOptions serializeUnsupportedClassesUsingDelegate:(id)delegate selector:(SEL)selector error:(NSError **)error;


NSArray (JSONKitSerializingBlockAdditions)
    - (NSData *)JSONDataWithOptions:(JKSerializeOptionFlags)serializeOptions serializeUnsupportedClassesUsingBlock:(id(^)(id object))block error:(NSError **)error;
    - (NSString *)JSONStringWithOptions:(JKSerializeOptionFlags)serializeOptions serializeUnsupportedClassesUsingBlock:(id(^)(id object))block error:(NSError **)error;

NSDictionary (JSONKitSerializingBlockAdditions)
    - (NSData *)JSONDataWithOptions:(JKSerializeOptionFlags)serializeOptions serializeUnsupportedClassesUsingBlock:(id(^)(id object))block error:(NSError **)error;
    - (NSString *)JSONStringWithOptions:(JKSerializeOptionFlags)serializeOptions serializeUnsupportedClassesUsingBlock:(id(^)(id object))block error:(NSError **)error;
```
