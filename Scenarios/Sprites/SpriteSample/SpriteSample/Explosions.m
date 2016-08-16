//
//  Explosions.m
// Create and draw explosion, using SpriteClass.
//

#import "Explosions.h"


@implementation Explosions

NSMutableArray *debris;


- (id)init  {
    if ((self = [super init])) {
        {
            debris = [NSMutableArray array];
        }
    }
    return self;
}

-(void) explode : (CGPoint)positionOfExplosion : (GLKBaseEffect *)effect
{
    SpriteClass *s = [[SpriteClass alloc] initWithFile:@"explosion.png" effect:effect];
    s.spritePosition = positionOfExplosion;
    [debris addObject:s];
}

-(void) update
{
    NSMutableArray *oldDebris = [NSMutableArray array];
    
    for (SpriteClass *s in debris)
    {
        CGSize size = s.spriteSize;
        size.height = size.height + 4;
        size.width = size.width + 4;
        s.spriteSize = size;
        
        CGPoint pos = s.spritePosition;
        pos.x = pos.x - 2;
        pos.y = pos.y - 2;
        s.spritePosition = pos;
    
        
        if (size.height > 128)
        {
            [oldDebris addObject:s];
        };
    }
    
    [debris removeObjectsInArray:oldDebris];
}

-(void) render
{
    for (SpriteClass *s in debris)
    {
        [s render];
    }
}




@end
