//
//  CommonMacros.h
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/31.
//  Copyright © 2017年 徐阳. All rights reserved.
//

//全局标记字符串，用于 通知 存储

#ifndef CommonMacros_h
#define CommonMacros_h
#define YX_MANAGER [YXManager sharedInstance]
#define YXPLUS_MANAGER [YXPlusManager sharedInstance]
typedef NS_ENUM(NSInteger, GradientDirection) {
    GradientDirectionTopToBottom = 0,    // 从上往下 渐变
    GradientDirectionLeftToRight,        // 从左往右
    GradientDirectionBottomToTop,      // 从下往上
    GradientDirectionRightToLeft      // 从右往左
};
#import "NSString+CString.h"

#pragma mark - ——————— 用户相关 ————————
//登录状态改变通知
#define KNotificationLoginStateChange @"loginStateChange"

//自动登录成功
#define KNotificationAutoLoginSuccess @"KNotificationAutoLoginSuccess"

//被踢下线
#define KNotificationOnKick @"KNotificationOnKick"

//用户信息缓存 名称
#define KUserCacheName @"KUserCacheName"

//用户model缓存
#define KUserModelCache @"KUserModelCache"
//用户model缓存
#define KAPP_SHOW @"APP_SHOW"

//用户信息储存，之后改的
#define KUserInfo @"KUserInfo"

#define kNeedPayOrderNote               @"kNeedPayOrderNote"
#define kWebSocketDidOpenNote           @"kWebSocketDidOpenNote"
#define kWebSocketDidCloseNote           @"kWebSocketDidCloseNote"
#define kWebSocketdidReceiveMessageNote  @"kWebSocketdidReceiveMessageNote"


#pragma mark - ——————— 网络状态相关 ————————

//网络状态变化
#define KNotificationNetWorkStateChange @"KNotificationNetWorkStateChange"

#pragma mark - ——————— 引用 ————————

#endif /* CommonMacros_h */
