//
//  AppDelegate.m
//  ScrollPageVC
//
//  Created by huangjiawang on 2021/3/17.
//

#import "AppDelegate.h"
#import "HomeController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = UIColor.whiteColor;
    
    HomeController * controller = [[HomeController alloc] init];
    UINavigationController *mainNavigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    self.window.rootViewController = mainNavigationController;
    return YES;
}


@end
