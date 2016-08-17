//
//  UfoSwarm - manage an array of UFO objects, including collision testing.
//


#import "UfoSwarm.h"



@implementation UfoSwarm


@synthesize ufos = _ufos;

- (id)initUfoSwarm  : (GLKBaseEffect *)baseEffect
{
    if ((self = [super init])) {
        {
            _ufos = [NSMutableArray array];
            
            for (int i = 0; i<10; i++)
            {
                [_ufos addObject:[[Ufo alloc] initUfo: baseEffect]];
            }
        }
    }
    return self;
    
}

-(void)updateSwarm
{
    for (Ufo *u in _ufos)
    {
        [u update];
    }
}

-(void)renderSwarm
{
    for (Ufo *u in _ufos)
    {
        [u render];
    }
    
}


// The array of sprites is provided, and checked against the UFO array.
// If there is a collection, the object is deleted, and explosion triggered.

-(bool)CollisionTestAndExplode: (NSMutableArray *) targetSprites : (void (^)(CGPoint p))explodeAt
{
bool collision = false;

NSMutableArray *destroyed = [NSMutableArray array];

for (SpriteClass *s in targetSprites)
{
    for (Ufo *u in _ufos)
    {
        if (CGRectIntersectsRect( [u getRect] , [s getRect] ))
        {
             explodeAt(s.spritePosition);
            
            [destroyed addObject:u];
            
            collision = true;
        }
    }
}

[_ufos removeObjectsInArray:destroyed];

return collision;
    
}


-(bool)CollisionTest: (NSMutableArray *) targetSprites
{
    bool collision = false;
    
    NSMutableArray *destroyed = [NSMutableArray array];
    
    for (SpriteClass *s in targetSprites)
    {
        for (Ufo *u in _ufos)
        {
            if (CGRectIntersectsRect( [u getRect] , [s getRect] ))
            {
                [destroyed addObject:u];
                collision = true;
            }
        }
    }
    
    [_ufos removeObjectsInArray:destroyed];
    
    return collision;
}


@end
