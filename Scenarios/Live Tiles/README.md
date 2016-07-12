# Using Projections: Live Tiles

Live Tiles allow Windows users to see parts of an app’s content directly from the Start menu. Whether the app is in the foreground or not, a developer can use the tile that launches their app to also communicate new messages, events, and images to the user. This is performed by updating the tile with embedded notifications.

There are four steps to updating a tile:

1. Create an XML payload that describes the tile update.
2. Create a tile notification object and pass it the XML payload.
3. Create a tile updater object.
4. Pass the tile notification object to the updater object.

## The Code

The code for creating a Live Tile using Objective-C looks like this:

```Objective-C
    // Create an XML payload that describes the tile - https://msdn.microsoft.com/windows/uwp/controls-and-patterns/tiles-and-notifications-creating-tiles
    WDXDXmlDocument* tileXml = [WDXDXmlDocument make];

    // Build the XML structure
    NSString *xmlDocument = @"<tile><visual>\n";

    // Small Tile
    xmlDocument = [xmlDocument stringByAppendingString:@"<binding template=\"TileSmall\"><group><subgroup><text>Button!</text></subgroup></group></binding>\n"];

    // Medium Tile
    xmlDocument = [xmlDocument stringByAppendingString:[NSString stringWithFormat:@"<binding template=\"TileMedium\"><group><subgroup><text hint-style=\"subtitle\">Pressed at:</text><text hint-style=\"captionSubtle\">%@</text></subgroup></group></binding>\n", timeDateString]];

    // Large Tile
    xmlDocument = [xmlDocument stringByAppendingString:[NSString stringWithFormat:@"<binding template=\"TileWide\"><group><subgroup><text hint-style=\"subtitle\">Button pressed at:</text><text hint-style=\"captionSubtle\">%@</text></subgroup></group></binding>\n", timeDateString]];

    // Cleanup on XML
    xmlDocument = [xmlDocument stringByAppendingString:@"</visual></tile>\n"];

    [tileXml loadXml:xmlDocument];

    WUNTileNotification *notification = [WUNTileNotification makeTileNotification: tileXml];
    // Notify the user via live tile
    WUNTileUpdater* tileUpdater = [WUNTileUpdateManager createTileUpdaterForApplication];
    [tileUpdater update:notification];
```

Read on for a complete explanation of how the above code works.

## Tutorial

[![Video](https://sec.ch9.ms/ch9/1577/fab4cdde-d0a9-4d7d-8e4d-449038841577/LiveTileswithBridgeforiOS_960.jpg)](https://channel9.msdn.com/Blogs/One-Dev-Minute/Live-Tiles-with-the-Windows-Bridge-for-iOS)
###### [*Watch the video tutorial on Channel9*](https://channel9.msdn.com/Blogs/One-Dev-Minute/Live-Tiles-with-the-Windows-Bridge-for-iOS)

You can find the Live Tiles sample project under */Scenarios/Live Tiles/LiveTileSample*. The project consists of a button and a label; when the button is pressed, the label is updated with the date/time that the button was pressed.

```Objective-C
- (void)buttonPressed
{
    // Update label
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"MM-dd HH:mm"];

    NSString *timeDateString = [formatter stringFromDate:[NSDate date]];
    NSString *labelString = [NSString stringWithFormat:@"Button pressed at: %@", timeDateString];
    self.label.text = labelString;
}
```

Let’s update this app to send that information to the tile.

### Setting up
First, open up the *LiveTileSample* directory at your windows prompt. 
You will run the [VSImporter tool](https://github.com/Microsoft/WinObjC/wiki/Using-vsimporter) from the WinObjC SDK on the LiveTileSample project to generate a Windows solution file (.sln).

*Example:*
```
c:\> cd "\winobjc-samples\Scenarios\Live Tiles\LiveTileSample"
c:\winobjc-samples\Scenarios\Live Tiles\LiveTileSample> \winobjc-sdk\bin\vsimporter.exe
Generated c:\winobjc-samples\Scenarios\Live Tiles\LiveTileSample\LiveTileSample.vsimporter\LiveTileSample-Headers-WinStore10\LiveTileSample-Headers.vcxitems
Generated c:\winobjc-samples\Scenarios\Live Tiles\LiveTileSample\LiveTileSample.vsimporter\LiveTileSampleSample-WinStore10\LiveTileSample.vcxproj
Generated c:\winobjc-samples\Scenarios\Live Tiles\LiveTileSample\LiveTileSample-WinStore10.sln

c:\winobjc-samples\Scenarios\Live Tiles\LiveTileSample>
```
Once you've generated the .sln file, open it in Visual Studio.

We need the public headers for the relevant UWP frameworks. In the extracted SDK (or your built SDK directory, if you’ve cloned [WinObjC from GitHub and built the project from source](https://github.com/Microsoft/WinObjC)), go to the [include\Platform\Universal Windows\UWP](https://github.com/Microsoft/WinObjC/tree/master/include/Platform/Universal Windows/UWP) directory and take a look at what you find. Each header file represents a different namespace within the [Windows Runtime APIs](https://msdn.microsoft.com/en-us/library/windows/apps/br211377.aspx). For our purposes, we will need APIs from:

-	[Windows.UI.Notifications](https://msdn.microsoft.com/en-us/library/windows/apps/windows.ui.notifications.aspx)
-	[Windows.Data.Xml.Dom](https://msdn.microsoft.com/en-us/library/windows/apps/windows.data.xml.dom.aspx)

To include these frameworks – and make sure they’re only included when the code is being run on Windows – we’ll start by adding an #ifdef and two #import macros to the top of our view controller implementation file:

```Objective-C
#ifdef WINOBJC
#import <UWP/WindowsUINotifications.h>
#import <UWP/WindowsDataXmlDom.h>
#endif
```

Next, we’ll extend the buttonPressed handler method with an additional #ifdef.
```Objective-C
  [...]
  NSString *timeDateString = [NSString stringWithFormat:@"Button pressed at: %@", [formatter stringFromDate:[NSDate date]]];
  self.updateLabel.text = timeDateString;

  #ifdef WINOBJC
  #endif
}
```

### Create an XML payload
For this example, we'll build an XML doc that fits the adaptive tile schema. Adaptive tiles allow a developer to add rich data to the app's start tile, no matter what size the user decides to use. Add your timeDateString to the text:

```Objective-C
  [...]
  self.label.text = labelString;

#ifdef WINOBJC
    WDXDXmlDocument* tileXml = [WDXDXmlDocument make];

    // Build the XML structure
    NSString *xmlDocument = @"<tile><visual>\n";

    // Small Tile
    xmlDocument = [xmlDocument stringByAppendingString:@"<binding template=\"TileSmall\"><group><subgroup><text>Button!</text></subgroup></group></binding>\n"];

    // Medium Tile
    xmlDocument = [xmlDocument stringByAppendingString:[NSString stringWithFormat:@"<binding template=\"TileMedium\"><group><subgroup><text hint-style=\"subtitle\">Pressed at:</text><text hint-style=\"captionSubtle\">%@</text></subgroup></group></binding>\n", timeDateString]];

    // Large Tile
    xmlDocument = [xmlDocument stringByAppendingString:[NSString stringWithFormat:@"<binding template=\"TileWide\"><group><subgroup><text hint-style=\"subtitle\">Button pressed at:</text><text hint-style=\"captionSubtle\">%@</text></subgroup></group></binding>\n", timeDateString]];

    // Cleanup on XML
    xmlDocument = [xmlDocument stringByAppendingString:@"</visual></tile>\n"];

    [tileXml loadXml:xmlDocument];
#endif
```
For further reading on Adaptive Live Tile format, check out [Create Adaptive Tiles](https://msdn.microsoft.com/en-us/windows/uwp/controls-and-patterns/tiles-and-notifications-create-adaptive-tiles) on MSDN.

As you build using Objective-C projections, you will notice that the standard naming scheme for these objects have been modified to match Objective-C conventions:

-	**Windows.UI.Notifications.TileUpdateManager** becomes **WUNTileUpdateManager**
-	**Windows.Data.Xml.Dom.XmlDocument** becomes **WDXDXmlDocument**

### Create a tile notification object and pass it the XML payload
The next step is to generate a [TileNotification](https://msdn.microsoft.com/en-us/library/windows/apps/windows.ui.notifications.tilenotification.aspx) object. For this step, take a quick look at the [WindowsUINotifications](https://github.com/Microsoft/WinObjC/blob/master/include/Platform/Universal Windows/UWP/WindowsUINotifications.h) header to show you what you need.

```Objective-C
@interface WUNTileNotification : RTObject
+ (WUNTileNotification*)makeTileNotification:(WDXDXmlDocument*)content ACTIVATOR;
```

Take the WDXDXmlDocument you just created and pass it to makeTileNotification:

```Objective-C
  [...]
  xmlDocument = [xmlDocument stringByAppendingString:@"</visual></tile>\n"];

  [tileXml loadXml:xmlDocument];

  WUNTileNotification *notification = [WUNTileNotification makeTileNotification: tileXml];
  [...]
```

### Create a tile updater object
To update the tile, use the WUNTileUpdateManager factory class to create an instance of WUNTileUpdater. Referencing the [Windows UI Notifications](https://msdn.microsoft.com/en-us/library/windows/apps/windows.ui.notifications.tileupdater.aspx) documentation, this is just a call to createTileUpdaterForApplication:

```Objective-C
  [...]
  [tileTextAttributes item:0].innerText = timeDateString;

  WUNTileNotification *notification = [WUNTileNotification makeTileNotification: tileXml];
  WUNTileUpdater* tileUpdater = [WUNTileUpdateManager createTileUpdaterForApplication];
  [...]
```

### Pass the tile notification object to the updater object
Finish it up with an update to WUNTileUpdater you just made, using the notification you built from XML:

```Objective-C
  [...]
  WUNTileNotification *notification = [WUNTileNotification makeTileNotification: tileXml];
  WUNTileUpdater* tileUpdater = [WUNTileUpdateManager createTileUpdaterForApplication];
  [tileUpdater update:notification];
  [...]
```

That’s it! You’re done. Now, press the button and see your Live Tile in action.

## Additional Reading
Want a deeper dive into everything a Live Tile can do? Check out:
- The [Live Tiles developer documentation on MSDN](https://msdn.microsoft.com/windows/uwp/controls-and-patterns/tiles-badges-notifications)
- The iOS bridge [UWP header libraries](https://github.com/Microsoft/WinObjC/tree/master/include/Platform/Universal Windows/UWP) to find the exact API you need.

Microsoft also hosts an excellent [design guide to Live Tile user experience](https://msdn.microsoft.com/en-us/library/windows/apps/hh465403.aspx) on MSDN.
