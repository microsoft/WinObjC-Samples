//
//  Landscape.h
//

#import <Foundation/Foundation.h>
#import "SpriteClass.h"


@interface Landscape : NSObject

- (id)initLandscape : (GLKBaseEffect *)baseEffect ScreenSize : (CGSize) screensize;
-(void) update;
-(void) render;

@end
