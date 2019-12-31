//
//  AppDelegate.m
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/17.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import "AppDelegate.h"
#import <UMCommon/UMConfigure.h>
#import "SocketRocketUtility.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //初始化window
    [self initWindow];

    //UMeng初始化
    [self initUMeng:launchOptions];
    
    //初始化app服务
    [self initService];
    
    //初始化用户系统
    [self initUserManager];
    
    //初始化QMUI
    [self initQMUI];
    
    //更新
    [ShareManager updateApp];
    return YES;
}

//app隐藏
- (void)applicationWillResignActive:(UIApplication *)application {
    [[SocketRocketUtility instance] SRWebSocketClose];
}
//app显示
- (void)applicationWillEnterForeground:(UIApplication *)application {
     [[SocketRocketUtility instance] SRWebSocketStart];
     KPostNotification(KAPP_SHOW, nil);
}
- (void)applicationDidEnterBackground:(UIApplication *)application {}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tuisongxiaoxi" object:nil];
}
- (void)applicationWillTerminate:(UIApplication *)application {}


@end
