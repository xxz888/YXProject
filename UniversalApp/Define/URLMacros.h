//
//  URLMacros.h
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/18.
//  Copyright © 2017年 徐阳. All rights reserved.
//



#ifndef URLMacros_h
#define URLMacros_h


//内部版本号 每次发版递增
#define KVersionCode 1
/*
 
 将项目中所有的接口写在这里,方便统一管理,降低耦合
 
 这里通过宏定义来切换你当前的服务器类型,
 将你要切换的服务器类型宏后面置为真(即>0即可),其余为假(置为0)
 如下:现在的状态为测试服务器
 这样做切换方便,不用来回每个网络请求修改请求域名,降低出错事件
 */


#define ENVIRONMENT_TAG 0

#define BASE_URL
#if (ENVIRONMENT_TAG == 0)             //正式
#define API_URL                  @"47.99.113.177:8001"
#elif (ENVIRONMENT_TAG == 1)           //测试
#define API_URL                  @"192.168.0.12:8001"
#else
#endif
#define BASEWEB_URL              @"http://h5.adianyun.net/"

#define HTTP_PARAMETER           @"http://"
/** 拼接的链路 */
#define API_ROOT_URL_HTTP_FORMAL        [HTTP_PARAMETER   stringByAppendingString:API_URL]


#define UPDATE_APP_URL @"http://itunes.apple.com/lookup?id="
#define UPDATE_App_ID @"1358751725"


#import <QMapKit/QMapKit.h>
#import <QMapSearchKit/QMapSearchKit.h>
#define TencentKey @"KMTBZ-AJN3K-MWSJW-A5FV6-ZVDCQ-JIF33"

#pragma mark - ——————— 详细接口地址 ————————

//测试接口
//NSString *const URL_Test = @"api/recharge/price/list";
#define URL_Test @"/api/cast/home/start"


#pragma mark - ——————— 用户相关 ————————
//自动登录
#define URL_user_auto_login @"/api/autoLogin"
//登录
#define URL_user_login @"/api/login"
//用户详情
#define URL_user_info_detail @"/api/user/info/detail"
//修改头像
#define URL_user_info_change_photo @"/api/user/info/changephoto"
//注释
#define URL_user_info_change @"/api/user/info/change"


#endif /* URLMacros_h */
