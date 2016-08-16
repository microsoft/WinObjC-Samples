//
//  Renderer.h
//

// This class contains the setup and rendering code for the GLKView


#import <GLKit/GLKit.h>

@interface Renderer : NSObject <GLKViewDelegate, GLKViewControllerDelegate>


-(void) shoot;
-(void)moveShip: (BOOL)up;

-(void)initGLData : (CGSize) screenSize;

-(void)cleanupGLData;

-(void)glkViewController: (GLKViewController*)controller willPause:(BOOL)paused;
-(void)glkViewControllerUpdate: (GLKViewController*)controller;
-(void)glkView:(GLKView*)view drawInRect:(CGRect)rect;

@end


