//
//  AppDelegate.m
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Create the GLKitViewController, the GLKView, and the Renderer class.
    // All are created programmatially rather than from a Storyboard for now.
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    _window = [[UIWindow alloc] initWithFrame: bounds];
    
    EAGLContext* ctx = [[EAGLContext alloc] initWithAPI: kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext: ctx];
    
    _renderer = [[Renderer alloc] init];
    [_renderer initGLData : bounds.size];
    
    GLKView* view = [[GLKView alloc] initWithFrame: bounds];
    view.context = ctx;
    view.delegate = _renderer;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    
    
    // Define the 'renderer', that is, the class that contains the methods to be called every frame
    // to display the screen and handle updates.
    GLKViewController* ctl = [[GLKViewController alloc] initWithNibName: nil bundle: nil];
    ctl.view = view;
    ctl.delegate = _renderer;
    ctl.preferredFramesPerSecond = 60; // 30 or 60 are good values. 60 is smoother.
    _window.rootViewController = ctl;
    [_window makeKeyAndVisible];
    
    
    // Set up some gesture recognizers for simple control of the player's ship.
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    [view addGestureRecognizer:tapRecognizer];
    
    UISwipeGestureRecognizer *swipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUpFrom:)];
    [swipeUpRecognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [view addGestureRecognizer:swipeUpRecognizer];
    
    UISwipeGestureRecognizer *swipeDownRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDownFrom:)];
    [swipeDownRecognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [view addGestureRecognizer:swipeDownRecognizer];
    
       
    return YES;
}

// Gesture recognizer handlers

- (void)handleSwipeUpFrom:(UISwipeGestureRecognizer *)sender
{
    [_renderer moveShip:TRUE];
}

- (void)handleSwipeDownFrom:(UISwipeGestureRecognizer *)sender
{
    [_renderer moveShip:FALSE];
}


- (void)handleTapFrom:(UITapGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [_renderer shoot];
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
