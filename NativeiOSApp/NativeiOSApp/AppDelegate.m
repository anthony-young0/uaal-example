//
//  AppDelegate.m
//  NativeiOSApp
//
//  Created by anthony on 2023/01/02.
//  Copyright © 2023 unity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#include "UnityManager.h"
#include "NativeiOsApp-Swift.h"


@interface AppDelegate : UIResponder<UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UINavigationController *navVC;
@property (nonatomic, strong) UIViewController *viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions;
- (void)applicationWillResignActive:(UIApplication *)application;
- (void)applicationDidEnterBackground:(UIApplication *)application;
- (void)applicationWillEnterForeground:(UIApplication *)application;
- (void)applicationDidBecomeActive:(UIApplication *)application;
- (void)applicationWillTerminate:(UIApplication *)application;

@property bool didQuit;


//- (void)didFinishLaunching:(NSNotification*)notification;
//- (void)didBecomeActive:(NSNotification*)notification;
//- (void)willResignActive:(NSNotification*)notification;
//- (void)didEnterBackground:(NSNotification*)notification;
//- (void)willEnterForeground:(NSNotification*)notification;
//- (void)willTerminate:(NSNotification*)notification;
//- (void)unityDidUnloaded:(NSNotification*)notification;

@end

@class RootViewController;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions
{
    [UnityManager sharedInstance].appLaunchOpts = launchOptions;
    
    self.window = [[UIWindow alloc] initWithFrame: [UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor redColor];
    self.viewController = [[RootViewController alloc] init];
    self.navVC = [[UINavigationController alloc] initWithRootViewController: self.viewController];
    self.window.rootViewController = self.navVC;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[UnityManager sharedInstance] applicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[UnityManager sharedInstance] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[UnityManager sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[UnityManager sharedInstance] applicationDidBecomeActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[UnityManager sharedInstance] applicationWillTerminate:application];
}

@end


int main(int argc, char* argv[])
{
    [UnityManager sharedInstance].gArgc = argc;
    [UnityManager sharedInstance].gArgv = argv;
    
    @autoreleasepool
    {
        UIApplicationMain(argc, argv, nil, [NSString stringWithUTF8String: "AppDelegate"]);
    }
    
    return 0;
}
