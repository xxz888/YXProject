//
//  AppDelegate+AppService.m
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/19.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import "AppDelegate+AppService.h"
#import <UMShare/UMShare.h>
#import "LoginViewController.h"
#import <UMAnalytics/MobClick.h>
#import "SaltedFishTabBarVC.h"
#import  <UserNotifications/UserNotifications.h>// Push组件必须的系统库
#import "YXSecondViewController.h"
#import "YXFindViewController.h"
#import  <UMCommon/UMCommon.h>  // 公共组件是所有友盟产品的基础组件，必选
#import  <UMPush/UMessage.h>  // Push组件
#define UMAppKey @"5d2eba7d0cafb28237000acb"
#import "YXNetFailView.h"
#import "YXNewLoginViewController.h"
@interface AppDelegate()<UNUserNotificationCenterDelegate>
//@property (nonatomic, strong) YXNetFailView * netFailView;
//@property (nonatomic) BOOL netBool;
@end
@implementation AppDelegate (AppService)


#pragma mark ————— 初始化服务 —————
-(void)initService{
    [QMapServices sharedServices].apiKey = TencentKey;
    [[QMSSearchServices sharedServices] setApiKey:TencentKey];
    //注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNotificationLoginStateChange
                                               object:nil];    
    
    //网络状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(netWorkStateChange:)
                                                 name:KNotificationNetWorkStateChange
                                               object:nil];
    

}

#pragma mark ————— 初始化window —————
-(void)initWindow{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = KWhiteColor;
    [self.window makeKeyAndVisible];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [[UIButton appearance] setExclusiveTouch:YES];
//    [[UIButton appearance] setShowsTouchWhenHighlighted:YES];
//    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = KWhiteColor;
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
//    kWeakSelf(self);
//    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXNetFailView" owner:self options:nil];
//    self.netFailView = [nib objectAtIndex:0];
//    self.netFailView.hidden = YES;
//    self.netFailView.frame = CGRectMake(0,0, KScreenWidth, KScreenHeight);
//    [self.window addSubview:self.netFailView];
//    self.netFailView.refreshblock = ^{
//        [weakself.netFailView removeFromSuperview];
//    };
}
#pragma mark ————— 初始化用户系统 —————
-(void)initUserManager{
    if([userManager loadUserInfo]){
        //如果有本地数据，先展示TabBar 随后异步自动登录
        self.mainTabBar = [SaltedFishTabBarVC new];
        self.window.rootViewController = self.mainTabBar;
    }else{
        //没有登录过，展示登录页面
        KPostNotification(KNotificationLoginStateChange, @YES)
    }
}

#pragma mark ————— 登录状态处理 —————
- (void)loginStateChange:(NSNotification *)notification{
    BOOL loginSuccess = [notification.object boolValue];
        
    if (loginSuccess) {//登陆成功加载主窗口控制器
        //为避免自动登录成功刷新tabbar
        if (!self.mainTabBar || ![self.window.rootViewController isKindOfClass:[MainTabBarController class]]) {
            self.mainTabBar = [SaltedFishTabBarVC new];
            CATransition *anima = [CATransition animation];
            anima.type = @"cube";//设置动画的类型
            anima.subtype = kCATransitionFromRight; //设置动画的方向
            anima.duration = 0.3f;
            self.window.rootViewController = self.mainTabBar;
            [kAppWindow.layer addAnimation:anima forKey:@"revealAnimation"];
        }
    }else {//登陆失败加载登陆页面控制器
        UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        YXNewLoginViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"YXNewLoginViewController"];
        RootNavigationController *loginNavi =[[RootNavigationController alloc] initWithRootViewController:VC];

        [self.window.rootViewController presentViewController:loginNavi animated:YES completion:^{
            VC.navigationController.tabBarController.hidesBottomBarWhenPushed=NO;
            VC.navigationController.tabBarController.selectedIndex=0;
        }];
        
    }
}


#pragma mark ————— 网络状态变化 —————
- (void)netWorkStateChange:(NSNotification *)notification
{
    BOOL isNetWork = [notification.object boolValue];
//    self.netFailView.hidden = isNetWork;
    if (isNetWork) {//有网络
        if ([userManager loadUserInfo] && !isLogin) {//有用户数据 并且 未登录成功 重新来一次自动登录
            
            KPostNotification(KNotificationLoginStateChange, @YES)
            return;
            [userManager autoLoginToServer:^(BOOL success, NSString *des) {
                if (success) {
                    DLog(@"网络改变后，自动登录成功");
//                    [MBProgressHUD showSuccessMessage:@"网络改变后，自动登录成功"];
                    KPostNotification(KNotificationAutoLoginSuccess, nil);
                }else{
                    [MBProgressHUD showErrorMessage:NSStringFormat(@"自动登录失败：%@",des)];
                }
            }];
        }
        
    }else {//登陆失败加载登陆页面控制器
//        [MBProgressHUD showTopTipMessage:@"网络状态不佳" isWindow:YES];
    }
}


#pragma mark ————— 友盟 初始化 —————
-(void)initUMeng:(NSDictionary *)launchOptions{
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [UMConfigure initWithAppkey:UMengKey channel:nil];

    //友盟分享
    [self configUSharePlatforms];
    //友盟推送
    [self configUMPush:launchOptions];
    //友盟统计
    [self configUMTongJi];
}
-(void)configUMTongJi{
    
}
-(void)configUMPush:(NSDictionary *)launchOptions{
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
}
-(void)userNotificationCenter:(UNUserNotificationCenter*)center willPresentNotification:(UNNotification*)notification withCompletionHandler:(void(^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary* userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
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
//收到推送消息，进入app
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
        //首页
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
#pragma mark ————— 配置第三方 —————
-(void)configUSharePlatforms{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kAppKey_Wechat appSecret:kSecret_Wechat redirectURL:nil];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:kAppKey_Tencent  appSecret:kAppKey_Tencent_Secret redirectURL:nil];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:kAppKey_WeiBo  appSecret:kAppKey_WeiBo_Secret redirectURL:@"http://www.sharesdk.cn"];
}

#pragma mark ————— OpenURL 回调 —————
// 支持所有iOS系统。注：此方法是老方法，建议同时实现 application:openURL:options: 若APP不支持iOS9以下，可直接废弃当前，直接使用application:openURL:options:

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
        if ([url.host isEqualToString:@"safepay"]) {
            //跳转支付宝钱包进行支付，处理支付结果
//            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//                NSLog(@"result = %@",resultDic);
//            }];
            return YES;
        }
//        if  ([OpenInstallSDK handLinkURL:url]){
//            return YES;
//        }
//        //微信支付
//        return [WXApi handleOpenURL:url delegate:[PayManager sharedPayManager]];
    }
    return result;
}












#pragma mark ————— 网络状态监听 —————
- (void)monitorNetworkStatus
{
    // 网络状态改变一次, networkStatusWithBlock就会响应一次
    [PPNetworkHelper networkStatusWithBlock:^(PPNetworkStatusType networkStatus) {
        switch (networkStatus) {
                // 未知网络
            case PPNetworkStatusUnknown:
                DLog(@"网络环境：未知网络");
                // 无网络
            case PPNetworkStatusNotReachable:
                DLog(@"网络环境：无网络");
                KPostNotification(KNotificationNetWorkStateChange, @NO);
                break;
                // 手机网络
            case PPNetworkStatusReachableViaWWAN:
                DLog(@"网络环境：手机自带网络");
                // 无线网络
            case PPNetworkStatusReachableViaWiFi:
                DLog(@"网络环境：WiFi");
                KPostNotification(KNotificationNetWorkStateChange, @YES);
                break;
        }
    }];
    
}


//初始化QMUI
-(void)initQMUI{
    
}


+ (AppDelegate *)shareAppDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


-(UIViewController *)getCurrentVC{
    
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

-(UIViewController *)getCurrentUIVC
{
    UIViewController  *superVC = [self getCurrentVC];
    
    if ([superVC isKindOfClass:[UITabBarController class]]) {
        
        UIViewController  *tabSelectVC = ((UITabBarController*)superVC).selectedViewController;
        
        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)tabSelectVC).viewControllers.lastObject;
        }
        return tabSelectVC;
    }else
        if ([superVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)superVC).viewControllers.lastObject;
        }
    return superVC;
}


@end
