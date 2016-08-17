//
//  SpriteClass.h
//


#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface SpriteClass : NSObject

@property (assign) CGPoint spritePosition;
@property (assign) CGSize spriteSize;
@property bool hidden;

- (id)initWithFile:(NSString *)fileName effect:(GLKBaseEffect *)effect;
- (void)render;
-(CGRect)getRect;


@end



