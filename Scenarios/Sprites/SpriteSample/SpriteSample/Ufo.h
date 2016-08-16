//
//  Ufo.h
//  SpriteSample
//


#import <Foundation/Foundation.h>
#import "SpriteClass.h"

@interface Ufo : SpriteClass


- (id)initUfo  : (GLKBaseEffect *)baseEffect;
-(void)update;
-(void)render;
-(CGFloat) getSize;
-(CGRect)getRect;

@end
