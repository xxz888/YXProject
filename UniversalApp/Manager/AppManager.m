//
//  AppManager.m
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/21.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import "AppManager.h"
#import "AdPageView.h"
#import "RootWebViewController.h"
#import "LoginViewController.h"
#import "YYFPSLabel.h"
#import "SELUpdateAlert.h"
@implementation AppManager

SINGLETON_FOR_CLASS(AppManager);

+(void)appStart{
    //加载广告
    AdPageView *adView = [[AdPageView alloc] initWithFrame:kScreen_Bounds withTapBlock:^{
        RootNavigationController *loginNavi =[[RootNavigationController alloc] initWithRootViewController:[[RootWebViewController alloc] initWithUrl:@"http://www.hao123.com"]];
        [kRootViewController presentViewController:loginNavi animated:YES completion:nil];
    }];
    adView = adView;
}
#pragma mark ————— FPS 监测 —————
+(void)showFPS{
    YYFPSLabel *_fpsLabel = [YYFPSLabel new];
    [_fpsLabel sizeToFit];
    _fpsLabel.bottom = KScreenHeight - 55;
    _fpsLabel.right = KScreenWidth - 10;
    //    _fpsLabel.alpha = 0;
    [kAppWindow addSubview:_fpsLabel];
}
#pragma mark ————— 更新app的方法，封装起来 —————
- (void)updateApp{
    [SELUpdateAlert showUpdateAlertWithVersion:@"" Description:@"更新描述" focTag:YES];

    NSString *urlStr = [NSString stringWithFormat:@"%@%@", UPDATE_APP_URL, UPDATE_App_ID];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary *appInfoDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            if (error) {
                NSLog(@"%@", error.description);
                return;
            }
            NSArray *resultArray = [appInfoDict objectForKey:@"results"];
            if (![resultArray count]) {
                NSLog(@"error : resultArray == nil");
                return;
            }
            NSDictionary *infoDict = [resultArray objectAtIndex:0];
            //获取服务器上应用的最新版本号－－－> connect获得的appstore版本号
            NSString * updateVersion = infoDict[@"version"];
            long updateVersionLong = [[updateVersion stringByReplacingOccurrencesOfString:@"." withString:@""] longLongValue];
            //获取当前设备中应用的版本号  －－－> 工程build的版本号
            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
            NSString * currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
            long currentVersionLong = [[currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""] longLongValue];
            //判断两个版本是否相同
            if (currentVersionLong  < updateVersionLong) {
                [SELUpdateAlert showUpdateAlertWithVersion:updateVersion Description:@"更新描述" focTag:YES];
            }
        }
    }];
    [dataTask resume];
}
@end
