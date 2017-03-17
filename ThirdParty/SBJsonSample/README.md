#SBJson5 Sample Application 

##Setup
This project uses SBJson5 as a dependency. When you first clone the repo if you have included ‘--recursive’ skip the next statement. Else navigate to WinObjC-samples root directory and run:
```
> git submodule update --init --recursive
```

Checkout the SBJson v5.0.0 version (SHA: c37ad93a2c1cd29c8a53aab67f4b30454ab03779)
```
> cd ThirdParty/SBJsonSample/SBJson-framework
> git checkout v5.0.0
```

Then follow the steps from WinObjC (https://github.com/Microsoft/WinObjC/#getting-started-with-the-bridge) github repo documentation to create a visual studio solution.

Now Build and run the sample on to emulator.

###Coverage
All the methods listed below are used in sample and are tested on both iOS and Windows environment.
```
SBJson5Parser parserWithBlock: errorHandler:
SBJson5Parser parserWithBlock: allowMultiRoot: unwrapRootArray: maxDepth: errorHandler:
SBJson5Parser multiRootParserWithBlock: errorHandler:
SBJson5Parser unwrapRootArrayParserWithBlock: errorHandler:
SBJson5Parser parse:

SBJson5StreamParser parserWithDelegate:

SBJson5StreamParserDelegate parserFoundObjectStart
SBJson5StreamParserDelegate parserFoundNull
SBJson5StreamParserDelegate parserFoundError:
SBJson5StreamParserDelegate parserFoundNumber:
SBJson5StreamParserDelegate parserFoundString:
SBJson5StreamParserDelegate parserFoundArrayEnd
SBJson5StreamParserDelegate parserFoundBoolean:
SBJson5StreamParserDelegate parserFoundObjectEnd
SBJson5StreamParserDelegate parserFoundArrayStart

SBJson5Writer writerWithMaxDepth: humanReadable: sortKeys:
SBJson5Writer stringWithObject:
SBJson5Writer dataWithObject:
SBJson5Writer writerWithMaxDepth: humanReadable: sortKeysComparator:

SBJson5StreamWriter writerWithDelegate:
SBJson5StreamWriter writeObject:
SBJson5StreamWriter writeArray:
SBJson5StreamWriter writeObjectOpen
SBJson5StreamWriter writeObjectClose
SBJson5StreamWriter writeArrayOpen
SBJson5StreamWriter writeArrayClose
SBJson5StreamWriter writeNull
SBJson5StreamWriter writeBool:
SBJson5StreamWriter writeNumber:
SBJson5StreamWriter writeString:

SBJson5StreamWriterDelegate writer: appendBytes:(const void *)bytes length:

```
