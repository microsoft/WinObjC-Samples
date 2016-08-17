//
//  Starfield.h
//

#import <Foundation/Foundation.h>
#import "SpriteClass.h"

@interface Starfield : NSObject

- (id)initStars  : (GLKBaseEffect *)baseEffect ScreenSize : (CGSize) screensize;
-(void) updateStars;
-(void) renderStars;

@end
