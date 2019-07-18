//
//  AppDelegate.m
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/17.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import "AppDelegate.h"
#import  <UMCommon/UMCommon.h>  // 公共组件是所有友盟产品的基础组件，必选
#import  <UMPush/UMessage.h>  // Push组件
#import  <UserNotifications/UserNotifications.h>// Push组件必须的系统库
#import "YXSecondViewController.h"
#import "YXFindViewController.h"
#define UMAppKey @"5d2eba7d0cafb28237000acb"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //初始化window
    [self initWindow];

    
    //初始化网络请求配置
    //[self NetWorkConfig];
    
    //UMeng初始化
    [self initUMeng];
    
    //初始化app服务
    [self initService];
    
    //初始化IM
    //[[IMManager sharedIMManager] initIM];
    
    //初始化用户系统
    [self initUserManager];
    
    //网络监听
    [self monitorNetworkStatus];
    
    
    //初始化QMUI
    [self initQMUI];
    //广告页
    //[AppManager appStart];
    
    //[WP_TOOL_AppManager updateApp];
    [ShareManager updateApp];
    
    
    
    
    


    // 配置友盟SDK产品并并统一初始化
    [UMConfigure initWithAppkey:UMAppKey channel:@"App Store"];
    // Push组件基本功能配置
    [UNUserNotificationCenter currentNotificationCenter].delegate= self;
    UMessageRegisterEntity* entity = [[UMessageRegisterEntity alloc] init];
    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标等
    entity.types= UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionAlert;
    [UNUserNotificationCenter currentNotificationCenter].delegate= self;
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError* _Nullableerror) {
        if(granted) {
            // 用户选择了接收Push消息
        }else{
            // 用户拒绝接收Push消息
        }
    }];
    return YES;
}
-(void)userNotificationCenter:(UNUserNotificationCenter*)center willPresentNotification:(UNNotification*)notification withCompletionHandler:(void(^)(UNNotificationPresentationOptions))completionHandler{
    
    NSDictionary* userInfo = notification.request.content.userInfo;
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        //应用处于前台时的远程推送接受
        
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //（前台、后台）的消息处理
        [UMessage didReceiveRemoteNotification:userInfo];
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}
//后天点击推送消息，进入app
-(void)userNotificationCenter:(UNUserNotificationCenter*)center didReceiveNotificationResponse:(UNNotificationResponse*)response withCompletionHandler:(void(^)())completionHandler{
    kWeakSelf(self);
    NSDictionary* userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [UMessage didReceiveRemoteNotification:userInfo];
        if(userInfo.count>0){
            [weakself jumpWithNotificationInfo:userInfo];
        }
    }
    else{ //应用处于后台时的本地推送接受
        NSLog(@"后台");

    }
}
- (void)jumpWithNotificationInfo:(NSDictionary *)userInfo{
    NSInteger tag = [userInfo[@"key0"] integerValue];
    //首页
    if(tag == 0){
        //发现
        [[NSNotificationCenter defaultCenter] postNotificationName:UM_User_Info_0 object:userInfo];
    }else if (tag == 1){
        //发现
        [[NSNotificationCenter defaultCenter] postNotificationName:UM_User_Info_1 object:userInfo];
    }
    self.mainTabBar.selectedIndex = tag;  // 然后，选中第几个模块

}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken{
    
    [UMessage registerDeviceToken:deviceToken];
    
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken success");
    
    NSLog(@"deviceToken————>>>%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<"withString: @""]
                                    
                                    stringByReplacingOccurrencesOfString: @">"withString: @""]
                                   
                                   stringByReplacingOccurrencesOfString: @" "withString: @""]);
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
//    [ShareManager updateApp];

    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
