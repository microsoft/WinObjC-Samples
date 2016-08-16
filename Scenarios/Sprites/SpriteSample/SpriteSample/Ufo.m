//
//  Ufo.m
//  SpriteSample
//


#import "Ufo.h"

@interface Ufo()

@property SpriteClass *ufo1, *ufo2;
@property CGFloat ufo_x ;
@property CGFloat ufo_y;
@property CGFloat ufo_dx;
@property CGFloat ufo_dy;
@property CGFloat ufo_height;
@property CGFloat ufo_height_delta;


@end

@implementation Ufo


CGSize screenSize;


// Ufo control


- (id)initUfo  : (GLKBaseEffect *)baseEffect  {
    
    if ((self = [super init])) {
        {
          
            _ufo_dx = 4;
            _ufo_dy = 3;
            _ufo_height_delta = -5;
            
            _ufo_x = 200 + arc4random()%256;
            _ufo_y = 100 + arc4random()%256;
            _ufo_height = arc4random()%32;
            
            _ufo1 = [[SpriteClass alloc] initWithFile:@"FlyingDisk.png" effect:baseEffect];
            _ufo_height = _ufo1.spriteSize.height;
            _ufo1.spritePosition = CGPointMake(_ufo_x, _ufo_y);
            
            _ufo2 = [[SpriteClass alloc] initWithFile:@"FlyingDisk.png" effect:baseEffect];
            _ufo2.spritePosition = _ufo1.spritePosition;
            
        }
    }
    return self;
}

-(CGFloat) getSize
{
    return _ufo_x;
}

-(CGRect)getRect
{
    return [_ufo1 getRect];
}

-(void)render
{
    [_ufo1 render];
    [_ufo2 render];
}

-(void)update
{
    _ufo_x += _ufo_dx;
    _ufo_y += _ufo_dy;
    if (_ufo_x<0 || _ufo_x>600 || arc4random()%50 > 48) _ufo_dx=-_ufo_dx;
    if (_ufo_y<0 || _ufo_y>600 || arc4random()%50 > 48) _ufo_dy=-_ufo_dy;
    
    
    CGFloat h = _ufo1.spriteSize.height;
    h += _ufo_height_delta;
    if (h<2 || h> _ufo_height) _ufo_height_delta = -_ufo_height_delta;
    
    _ufo1.spriteSize = CGSizeMake(_ufo1.spriteSize.width, h);
    _ufo1.spritePosition = CGPointMake(_ufo_x, _ufo_y - h/2);
   
    _ufo2.spriteSize = CGSizeMake(h, _ufo2.spriteSize.height);
    _ufo2.spritePosition = CGPointMake(_ufo_x - h/2 + _ufo2.spriteSize.height/2, _ufo_y - _ufo2.spriteSize.height/2);
    

}





@end
