//
//  Renderer.m
//
// The methods in the rendered are called 60 times a second, and
// look after drawing and moving the sprites.
//

#import "Renderer.h"
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <GLKit/GLKit.h>
#import "SpriteClass.h"
#import "Starfield.h"
#import "Lasers.h"
#import "Landscape.h"
#import "UfoSwarm.h"
#import "Explosions.h"

@interface Renderer ()

@property GLKBaseEffect * baseEffect;

@end

@implementation Renderer


UfoSwarm * badguys;
SpriteClass * background;
Explosions * explosions;
Starfield * starfield;
Lasers * lasers;
Landscape * landScape;
CGSize _screenSize;
SpriteClass * ship;

-(void)initGLData : (CGSize) screenSize
{
    // Set up the OpenGL view, and create the sprites
    
    _screenSize = screenSize;
    _baseEffect = [[GLKBaseEffect alloc] init];
    
    GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(0, _screenSize.width, 0, _screenSize.height, -1024, 1024);
    
    _baseEffect.transform.projectionMatrix = projectionMatrix;
    ship = [[SpriteClass alloc] initWithFile:@"SpaceShip.png" effect:_baseEffect];
    background = [[SpriteClass alloc] initWithFile:@"starfield.jpg" effect:_baseEffect];
    badguys = [[UfoSwarm alloc]initUfoSwarm:_baseEffect];
    ship.spritePosition = CGPointMake(50, 200);
    
    starfield = [[Starfield alloc] initStars:_baseEffect ScreenSize : _screenSize ];
    lasers = [[Lasers alloc] init: _screenSize];
    landScape = [[Landscape alloc]initLandscape:_baseEffect ScreenSize:_screenSize];
    
    explosions = [[Explosions alloc]init];
}


// Player's ship control

CGFloat ship_Speed = 0;


-(void)moveShip: (BOOL)up
{
    if (up)
    {
        ship_Speed = -5;
    }
    else
    {
        ship_Speed = 5;
    }
}


-(void)updateShip
{
    if (fabs(ship_Speed)<.05)
    {
        ship_Speed = 0;
        return;
    }
    
    // Damping effect so ship slows down gradually
    ship_Speed = ship_Speed * 0.95;
    
    CGPoint position = ship.spritePosition;
    position.y -= ship_Speed;
    ship.spritePosition = position;
    
}


-(void)shoot
{
    // Create a laser, based on player's ship's position
    if (!ship.hidden)
        [lasers shoot:ship.spritePosition : _baseEffect];
}


-(void)glkViewControllerUpdate: (GLKViewController*)controller {
    
    // Called every frame, used to update the position of the player's ship,
    // lasers, the baddies and background
    
    [starfield updateStars];
    [lasers update];
    [landScape update];
    [self updateShip];
    [badguys updateSwarm];
    [explosions update];
}



-(void)explodeAt: (CGPoint) p
{
     [explosions explode:p :_baseEffect];
}


-(void)glkView:(GLKView*)view drawInRect:(CGRect)rect {
    
    // Main draw method
    // This method called every frame to redraw the display
    
    // Clear the screen
    glClearColor(0.5, 0.0, 0.0, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    
    [_baseEffect prepareToDraw];
    
    [background render];

    [starfield renderStars];
    [badguys renderSwarm];
    [landScape render];
    [lasers render];
    [ship render];
    [explosions render];
    
    
    // Check for collisions between lasers and UFOs
    [badguys CollisionTestAndExplode: [lasers getAllLasers] : ^void (CGPoint p) { [self explodeAt : p]; }];
    
    // Check for collections between UFOs and player's ship
    if ([badguys CollisionTestAndExplode: [[NSMutableArray alloc] initWithObjects:ship, nil] : ^void (CGPoint p) { [self explodeAt : p]; }])
    {
        // Hide the player's spaceship
        ship.hidden = true;
        
        // Bring the ship back after a few seconds
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ship.hidden = false;
        });
    }
}


     

-(void)cleanupGLData {
    _baseEffect = nil;
    
}

// Handle the pause state.
-(void)glkViewController: (GLKViewController*)controller willPause:(BOOL)paused {
    if(paused) {
        NSLog(@"GLRenderer got pause event from controller.");
    } else {
        NSLog(@"GLRenderer got unpause event from controller.");
    }
}

@end

