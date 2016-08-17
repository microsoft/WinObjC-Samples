//
// Lasers.m
// Create and draw laser blasts, using SpriteClass.
//

#import "Lasers.h"


@implementation Lasers

NSMutableArray *laserBolts;


CGFloat screenSizeWidth;

- (id)init  :  (CGSize) screensize {
    if ((self = [super init])) {
        {
            screenSizeWidth = screensize.width;
            laserBolts = [NSMutableArray array];
        }
    }
    return self;
}

-(void) shoot : (CGPoint)positionOfShip : (GLKBaseEffect *)effect
{
    SpriteClass *s = [[SpriteClass alloc] initWithFile:@"laser.png" effect:effect];
    s.spritePosition = CGPointMake(50, positionOfShip.y + 16);
    [laserBolts addObject:s];
}

-(void) update
{
    NSMutableArray *oldLasers = [NSMutableArray array];
    
    for (SpriteClass *s in laserBolts)
    {
        CGPoint position = s.spritePosition;
        position.x = position.x + 8;
        s.spritePosition = position;
        if (position.x>screenSizeWidth)
        {
            [oldLasers addObject:s];
        };
    }
    
    [laserBolts removeObjectsInArray:oldLasers];
}

-(void) render
{
    for (SpriteClass *s in laserBolts)
    {
        [s render];
    }
}


// Return an array of lasers, for use in collection testing
-(NSMutableArray *)getAllLasers
{
    NSMutableArray *p = [[NSMutableArray alloc] init];
    
    for (SpriteClass *s in laserBolts)
    {
        [p addObject:s];
    }

    return p;
    
}



@end
