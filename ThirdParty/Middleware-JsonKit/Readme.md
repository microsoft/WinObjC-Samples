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
All the methods listed below are used in sample and are tested on both iOS and Windows environment.
