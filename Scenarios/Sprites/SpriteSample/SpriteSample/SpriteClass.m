//
// SpriteClass.m
//
// A 2D rectangular sprite object.
// Properties for size, position, texture and rendered effect.
//


#import "SpriteClass.h"

@interface SpriteClass()

@property GLKBaseEffect * beffect;
@property GLKTextureInfo * textureInfo;

@end


@implementation SpriteClass




@synthesize spritePosition = _spritePosition;
@synthesize spriteSize = _spriteSize;


// Create a sprite object. Provide a .png, and transparency is honored.
- (id)initWithFile:(NSString *)fileName effect:(GLKBaseEffect *)effect {
    if ((self = [super init])) {
        
        _beffect = effect;
        
        NSDictionary * options = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithBool:YES],
                                  GLKTextureLoaderOriginBottomLeft,
                                  nil];
        
        NSError * error;
        NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
        
        if (path!=nil)
            _textureInfo = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
        
        
        if (_textureInfo == nil || path == nil) {
            NSLog(@"Error loading file: %@", fileName);
            return nil;
        }
        
        
        _spriteSize = CGSizeMake(_textureInfo.width, _textureInfo.height);
        
    }
    return self;
}



-(CGRect)getRect
{
    // Used for collision testing
    return CGRectMake(_spritePosition.x, _spritePosition.y, _spriteSize.width, _spriteSize.height);
}

- (GLKMatrix4) modelMatrix {
    
    GLKMatrix4 modelMatrix = GLKMatrix4Identity;
    modelMatrix = GLKMatrix4Translate(modelMatrix, _spritePosition.x, _spritePosition.y, 0);
    return modelMatrix;
    
}


- (void)render {
    
    if (_hidden) return;
    
    _beffect.texture2d0.name = _textureInfo.name;
    _beffect.texture2d0.enabled = YES;
    _beffect.transform.modelviewMatrix = self.modelMatrix;
    
    [_beffect prepareToDraw];
    
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    
    GLfloat squareVertices[] = {
        0, 0,
        _spriteSize.width, 0,
        0, _spriteSize.height,
        _spriteSize.width, _spriteSize.height
    };
    
    GLfloat squareTexture[] = {
        0, 0,
        1, 0,
        0, 1,
        1, 1
    };
    
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, squareVertices);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, squareTexture );
    
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
}

@end
