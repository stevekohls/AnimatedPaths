//
//  AnimatedPathAppDelegate.m
//  AnimatedPath
//

#import "AnimatedPathAppDelegate.h"
#import "AnimatedPathViewController.h"

@implementation AnimatedPathAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

	return YES;
}

@end
