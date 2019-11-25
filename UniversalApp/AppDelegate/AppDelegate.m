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

    
    //初始化网络请求配置
    //[self NetWorkConfig];
    
    //UMeng初始化
    [self initUMeng:launchOptions];
    
    //初始化app服务
    [self initService];
    
    //初始化IM
    //[[IMManager sharedIMManager] initIM];
    
    //初始化用户系统
    [self initUserManager];
    
    //网络监听
//    [self monitorNetworkStatus];
    
    
    //初始化QMUI
    [self initQMUI];
    //广告页
//    [AppManager appStart];
    
    //[WP_TOOL_AppManager updateApp];
    [ShareManager updateApp];
    
    
    
    
    //此函数在UMCommon.framework版本1.4.2及以上版本，在UMConfigure.h的头文件中加入。
    //如果用户用组件化SDK,需要升级最新的UMCommon.framework版本。
    NSString * deviceID =[UMConfigure deviceIDForIntegration];
//    NSLog(@"集成测试的deviceID:%@", deviceID);
    
    
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

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}




- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tuisongxiaoxi" object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
