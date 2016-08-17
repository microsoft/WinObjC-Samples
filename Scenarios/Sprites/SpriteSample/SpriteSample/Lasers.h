//
//  Lasers.h
//


#import <Foundation/Foundation.h>
#import "SpriteClass.h"

@interface Lasers : NSObject

-(id)init  :  (CGSize) screensize;
-(void) update;
-(void) render;
-(void) shoot : (CGPoint)positionOfShip : (GLKBaseEffect *)effect;
-(NSMutableArray *)getAllLasers;

@end
