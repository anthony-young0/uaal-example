//
//  UnityManager.h
//  b-us
//
//  Created by anthony on 2023/01/02.
//

#import <Foundation/Foundation.h>
#include <UnityFramework/UnityFramework.h>
#include <UnityFramework/NativeCallProxy.h>

#ifndef UnityManager_h
#define UnityManager_h

@interface UnityManager : NSObject<UnityFrameworkListener, NativeCallsProtocol>

@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIButton *showUnityOffButton;
@property (nonatomic, strong) UIButton *testButton;
@property (nonatomic, strong) UIButton *btnSendMsg;
@property (nonatomic, strong) UIButton *unloadBtn;
@property (nonatomic, strong) UIButton *quitBtn;


@property UnityFramework* ufw;
@property bool didQuit;

// keep arg for unity init from non main
@property int gArgc;
@property char** gArgv;
@property NSDictionary<id, id> *appLaunchOpts;

+ (instancetype)sharedInstance;

- (void)initUnity;
- (void)showUnity;
- (void)unloadUnity;
- (void)quitUnity;

//UnityFrameworkListener
- (void)unityDidUnload:(NSNotification*)notification;
- (void)unityDidQuit:(NSNotification*)notification;

//NativeCallsProtocol
- (void)showHostMainWindow:(NSString*)color;

- (void)applicationWillResignActive:(UIApplication *)application;
- (void)applicationDidEnterBackground:(UIApplication *)application;
- (void)applicationWillEnterForeground:(UIApplication *)application;
- (void)applicationDidBecomeActive:(UIApplication *)application;
- (void)applicationWillTerminate:(UIApplication *)application;

@end

#endif /* UnityManager_h */
