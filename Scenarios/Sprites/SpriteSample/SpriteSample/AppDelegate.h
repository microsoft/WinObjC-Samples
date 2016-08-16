//
//  AppDelegate.h
//  


#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "Renderer.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Renderer *renderer;


@end

