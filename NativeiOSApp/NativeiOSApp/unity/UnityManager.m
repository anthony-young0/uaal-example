//
//  UnityInterfaceCall.m
//  b-us
//
//  Created by anthony on 2023/01/02.
//

#include "UnityManager.h"
#include "NativeiOSApp-Swift.h"

UnityFramework* UnityFrameworkLoad()
{
    NSString* bundlePath = nil;
    bundlePath = [[NSBundle mainBundle] bundlePath];
    bundlePath = [bundlePath stringByAppendingString: @"/Frameworks/UnityFramework.framework"];
    
    NSBundle* bundle = [NSBundle bundleWithPath: bundlePath];
    if ([bundle isLoaded] == false) [bundle load];
    
    UnityFramework* ufw = [bundle.principalClass getInstance];
    if (![ufw appController])
    {
        // unity is not initialized
        [ufw setExecuteHeader: &_mh_execute_header];
    }
    return ufw;
}

void showAlert(NSString* title, NSString* msg) {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:msg                                                         preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    auto id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
    [delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
}


@implementation UnityManager

+ (instancetype)sharedInstance {
    static UnityManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[UnityManager alloc] init];
    });
    return shared;
}

- (bool)unityIsInitialized { return [self ufw] && [[self ufw] appController]; }

- (void)showUnity
{
    if(![self unityIsInitialized]) {
        showAlert(@"Unity is not initialized", @"Initialize Unity first");
    } else {
        [[self ufw] showUnityWindow];
    }
}

- (void)showHostMainWindow
{
    [self showHostMainWindow:@""];
}

- (void)showHostMainWindow:(NSString*)color
{
    NSLog(@"showHostMainWindow %@", color);
    
    if([color isEqualToString:@"blue"]) self.view.backgroundColor = UIColor.blueColor;
    else if([color isEqualToString:@"red"]) self.view.backgroundColor = UIColor.redColor;
    else if([color isEqualToString:@"yellow"]) self.view.backgroundColor = UIColor.yellowColor;
    
    [self.view.window makeKeyAndVisible];
}

- (void)shout:(NSString *)message withUserIds:(NSArray *)userIds {
    NSLog(@"shout %@, %@", message, userIds);
}


- (void)sendMsgToUnity
{
    [[self ufw] sendMessageToGOWithName: "Cube" functionName: "ChangeColor" message: "yellow"];
}

- (void)initUnity
{
    if([self unityIsInitialized]) {
        showAlert(@"Unity already initialized", @"Unload Unity first");
        return;
    }
    if([self didQuit]) {
        showAlert(@"Unity cannot be initialized after quit", @"Use unload instead");
        return;
    }
    
    [self setUfw: UnityFrameworkLoad()];
    // Set UnityFramework target for Unity-iPhone/Data folder to make Data part of a UnityFramework.framework and uncomment call to setDataBundleId
    // ODR is not supported in this case, ( if you need embedded and ODR you need to copy data )
    [[self ufw] setDataBundleId: "com.unity3d.framework"];
    [[self ufw] registerFrameworkListener: self];
    [NSClassFromString(@"FrameworkLibAPI") registerAPIforNativeCalls:self];
    
    [[self ufw] runEmbeddedWithArgc: self.gArgc argv: self.gArgv appLaunchOpts: self.appLaunchOpts];
    
    // set quit handler to change default behavior of exit app
    [[self ufw] appController].quitHandler = ^(){ NSLog(@"AppController.quitHandler called"); };
    
    auto UIView* view = [[[self ufw] appController] rootView];
    
    if(self.showUnityOffButton == nil) {
        self.showUnityOffButton = [UIButton buttonWithType: UIButtonTypeSystem];
        [self.showUnityOffButton setTitle: @"Show Main" forState: UIControlStateNormal];
        self.showUnityOffButton.frame = CGRectMake(0, 0, 100, 44);
        self.showUnityOffButton.center = CGPointMake(50, 300);
        self.showUnityOffButton.backgroundColor = [UIColor greenColor];
        [view addSubview: self.showUnityOffButton];
        [self.showUnityOffButton addTarget: self action: @selector(showHostMainWindow) forControlEvents: UIControlEventPrimaryActionTriggered];
        
        self.testButton = [UIButton buttonWithType: UIButtonTypeSystem];
        [self.testButton setTitle: @"Test" forState: UIControlStateNormal];
        self.testButton.frame = CGRectMake(0, 0, 100, 44);
        self.testButton.center = CGPointMake(50, 350);
        self.testButton.backgroundColor = [UIColor greenColor];
        [view addSubview: self.testButton];
        [self.testButton addTarget: self action: @selector(testButtonTouched) forControlEvents: UIControlEventPrimaryActionTriggered];
        
        self.btnSendMsg = [UIButton buttonWithType: UIButtonTypeSystem];
        [self.btnSendMsg setTitle: @"Send Msg" forState: UIControlStateNormal];
        self.btnSendMsg.frame = CGRectMake(0, 0, 100, 44);
        self.btnSendMsg.center = CGPointMake(150, 300);
        self.btnSendMsg.backgroundColor = [UIColor yellowColor];
        [view addSubview: self.btnSendMsg];
        [self.btnSendMsg addTarget: self action: @selector(sendMsgToUnity) forControlEvents: UIControlEventPrimaryActionTriggered];
        
        // Unload
        self.unloadBtn = [UIButton buttonWithType: UIButtonTypeSystem];
        [self.unloadBtn setTitle: @"Unload" forState: UIControlStateNormal];
        self.unloadBtn.frame = CGRectMake(250, 0, 100, 44);
        self.unloadBtn.center = CGPointMake(250, 300);
        self.unloadBtn.backgroundColor = [UIColor redColor];
        [self.unloadBtn addTarget: self action: @selector(unloadUnity) forControlEvents: UIControlEventPrimaryActionTriggered];
        [view addSubview: self.unloadBtn];
        
        // Quit
        self.quitBtn = [UIButton buttonWithType: UIButtonTypeSystem];
        [self.quitBtn setTitle: @"Quit" forState: UIControlStateNormal];
        self.quitBtn.frame = CGRectMake(250, 0, 100, 44);
        self.quitBtn.center = CGPointMake(250, 350);
        self.quitBtn.backgroundColor = [UIColor redColor];
        [self.quitBtn addTarget: self action: @selector(quitUnity) forControlEvents: UIControlEventPrimaryActionTriggered];
        [view addSubview: self.quitBtn];
    }
}

- (void)testButtonTouched
{
    BottomSheetViewController* vc = [[BottomSheetViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [[[[self ufw] appController] rootViewController] presentViewController:vc animated:false completion:nil];
}

- (void)unloadUnity
{
    if(![self unityIsInitialized]) {
        showAlert(@"Unity is not initialized", @"Initialize Unity first");
    } else {
        [UnityFrameworkLoad() unloadApplication];
    }
}

- (void)quitUnity
{
    if(![self unityIsInitialized]) {
        showAlert(@"Unity is not initialized", @"Initialize Unity first");
    } else {
        [UnityFrameworkLoad() quitApplication:0];
    }
}

- (void)unityDidUnload:(NSNotification *)notification
{
    NSLog(@"unityDidUnload called");
    
    [[self ufw] unregisterFrameworkListener: self];
    [self setUfw: nil];
    [self showHostMainWindow:@""];
}

- (void)unityDidQuit:(NSNotification*)notification
{
    NSLog(@"unityDidQuit called");
    
    [[self ufw] unregisterFrameworkListener: self];
    [self setUfw: nil];
    [self setDidQuit:true];
    [self showHostMainWindow:@""];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[[self ufw] appController] applicationWillResignActive: application];
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[[self ufw] appController] applicationDidEnterBackground: application];
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[[self ufw] appController] applicationWillEnterForeground: application];
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[[self ufw] appController] applicationDidBecomeActive: application];
}
- (void)applicationWillTerminate:(UIApplication *)application {
    [[[self ufw] appController] applicationWillTerminate: application];
}

@end


//int main(int argc, char* argv[])
//{
//    gArgc = argc;
//    gArgv = argv;
//
//    @autoreleasepool
//    {
//        if (false)
//        {
//            // run UnityFramework as main app
//            id ufw = UnityFrameworkLoad();
//
//            // Set UnityFramework target for Unity-iPhone/Data folder to make Data part of a UnityFramework.framework and call to setDataBundleId
//            // ODR is not supported in this case, ( if you need embedded and ODR you need to copy data )
//            [ufw setDataBundleId: "com.unity3d.framework"];
//            [ufw runUIApplicationMainWithArgc: argc argv: argv];
//        } else {
//            // run host app first and then unity later
//            UIApplicationMain(argc, argv, nil, [NSString stringWithUTF8String: "AppDelegate"]);
//        }
//    }
//
//    return 0;
//}
