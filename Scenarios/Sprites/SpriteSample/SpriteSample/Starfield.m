//
// Starfield
//
// Use SpriteClass to draw some stars, with a simple parallax effect
//
 

#import "Starfield.h"

@interface Starfield()

@property (strong) NSMutableArray *stars;
@property (strong) GLKBaseEffect * effect;
@property CGSize screenSize;

@end

@implementation Starfield

- (id)initStars  : (GLKBaseEffect *)baseEffect ScreenSize: (CGSize) screensize{
    if ((self = [super init])) {
        {
            _effect = baseEffect;
            _screenSize = screensize;
            
           self.stars = [NSMutableArray array];
            
            for (int i=0; i<20; i++)
            {
                SpriteClass *s = [[SpriteClass alloc] initWithFile:@"star.png" effect:_effect];
                s.spritePosition = CGPointMake(arc4random()%(int)_screenSize.width, arc4random()%(int)_screenSize.height);
                [_stars addObject:s];
            }
            
            for (int i=0; i<30; i++)
            {
                SpriteClass *s = [[SpriteClass alloc] initWithFile:@"starLittle.png" effect:_effect];
                s.spritePosition = CGPointMake(arc4random()%(int)_screenSize.width, arc4random()%(int)_screenSize.height);
                [_stars addObject:s];
            }
        }
    }
      return self;
}

-(void) updateStars
{
    for (int i=0; i<50; i++)
    {
        SpriteClass *s = (SpriteClass*) [_stars objectAtIndex:i];
        
        CGPoint position = s.spritePosition;
        
        if (i<20)
            position.x = position.x - 3;
        else
             position.x = position.x - 2;
        
        if (position.x<0)
        {
            position = CGPointMake(position.x+(int)_screenSize.width, arc4random()%(int)_screenSize.height);
        }
        
        s.spritePosition = position;
    }
}

-(void) renderStars
{
    for (SpriteClass *s in _stars)
    {
        [s render];
    }
}

@end
