# Using Projections: In-App Purchases

*Work in progress.*

This xcodeproj can be processed by VSImporter and run on a Windows 10 machine using VS 2015 Update 2.

The calls to the mock store are being performed with less granularity than I would like, but they are valid patterns that can be substituted with real Windows Store IAP.


### Setting up
First, open up the *IAP-Sample* directory at your windows prompt. 
You will run the [VSImporter tool](https://github.com/Microsoft/WinObjC/wiki/Using-vsimporter) from the WinObjC SDK on the LiveTileSample project to generate a Windows solution file (.sln).

- Open the .sln file in Visual Studio.
- Upon opening the IAP-sample project, open the IAP-sample directory under *IAP-sample (Universal Windows)*.
- Right-click on the directory and select *Add Existing Item...*
- Add IAP-Sample\IAP-sample\in-app-purchase.xml

Build. 
