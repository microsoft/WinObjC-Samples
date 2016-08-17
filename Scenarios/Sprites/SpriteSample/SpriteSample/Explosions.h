//
//  Explosions.h
//


#import <Foundation/Foundation.h>
#import "SpriteClass.h"

@interface Explosions : NSObject

-(id) init;
-(void) update;
-(void) render;
-(void) explode : (CGPoint)positionOfExplosion : (GLKBaseEffect *)effect;

@end
