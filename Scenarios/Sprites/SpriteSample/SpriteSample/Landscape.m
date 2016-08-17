//
//  Landscape.m
//
//  Create and draw a scrolling tiled background
//

#import "Landscape.h"


@implementation Landscape

int step = 32;
int stepCounter = 32;
int speed = 1;

GLKBaseEffect *leffect;
NSMutableArray *landscapeCubes;
CGSize landscapescreenSize;

- (id)initLandscape  : (GLKBaseEffect *)baseEffect ScreenSize: (CGSize) screensize{
    if ((self = [super init])) {
        {
            leffect = baseEffect;
            landscapescreenSize = screensize;
            
            landscapeCubes = [NSMutableArray array];
            
            for (int x = 1; x<(int)landscapescreenSize.width; x+=step)
            {
                [self MakeBrickAt:CGPointMake(x, landscapescreenSize.height - step )];
                [self MakeBrickAt:CGPointMake(x, 0)];
                
            }
        }
    }
    return self;
}


-(void)MakeBrickAt : (CGPoint) position
{
    
    SpriteClass *s = [[SpriteClass alloc] initWithFile:@"LandscapeBlock.png" effect:leffect];
    s.spritePosition = position;
    [landscapeCubes addObject:s];
    
}

-(void) update
{
    
    NSMutableArray *oldLandscape = [NSMutableArray array];
    
    for (SpriteClass *s in landscapeCubes)
    {
        CGPoint position = s.spritePosition;
        position.x = position.x - speed;
        s.spritePosition = position;
        
        if (position.x < -step)
        {
            [oldLandscape addObject:s];
        }
        
    }
    
    [landscapeCubes removeObjectsInArray:oldLandscape];
    
    
    if (stepCounter>=(step/speed))
    {
        stepCounter = 0;
        
        // Make new bricks
        
        int n1 = 1+arc4random()%4;
        int n2 = 1+arc4random()%4;
        
        for (int y = 0; y<n1; y++)
        {
            [self MakeBrickAt:CGPointMake(landscapescreenSize.width, landscapescreenSize.height - step - step*y)];
        }
        
        for (int y = 0; y<n2; y++)
        {
            [self MakeBrickAt:CGPointMake(landscapescreenSize.width, step*y)];
        }
        
    }
    
    stepCounter++;
    
}

-(void) render
{
    for (SpriteClass *s in landscapeCubes)
    {
        [s render];
    }
}


@end
