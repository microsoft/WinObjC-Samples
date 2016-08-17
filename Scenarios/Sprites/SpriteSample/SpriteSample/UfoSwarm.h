//
//  UfoSwarm.h
//  SpriteSample
//


#import <Foundation/Foundation.h>
#import "Ufo.h"

@interface UfoSwarm : NSObject

@property NSMutableArray *ufos;


-(id)initUfoSwarm  : (GLKBaseEffect *)baseEffect;
-(void)updateSwarm;
-(void)renderSwarm;
-(bool)CollisionTest: (NSMutableArray *) targetSprites;



//-(bool)CollisionTestBlock: (NSMutableArray *) targetSprites : (void (^)())myBlock ;

-(bool)CollisionTestAndExplode: (NSMutableArray *) targetSprites : (void (^)(CGPoint p))explodeAt;

@end
