//
//  UserManager.m
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/22.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import "UserManager.h"
#import "YXBindPhoneViewController.h"
#import "SocketRocketUtility.h"
#import "YXWanShanXinXiViewController.h"
@implementation UserManager

SINGLETON_FOR_CLASS(UserManager);

-(instancetype)init{
    self = [super init];
    if (self) {
        //被踢下线
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onKick)
                                                     name:KNotificationOnKick
                                                   object:nil];
    }
    return self;
}

-(void)LoginVCCommonAction:(UIViewController *)vcself type:(UserLoginType )loginType{
    kWeakSelf(self);
    [userManager login:loginType completion:^(BOOL success, NSString *des) {
        if (success) {
            if (UserDefaultsGET(IS_FirstLogin)) {
                NSString * is_firstLogin = UserDefaultsGET(IS_FirstLogin);
                if ([is_firstLogin isEqualToString:@"NO"]) {
                    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
                    YXWanShanXinXiViewController * vc = [stroryBoard4 instantiateViewControllerWithIdentifier:@"YXWanShanXinXiViewController"];
                    [vcself.navigationController pushViewController:vc animated:YES];
                    UserDefaultsSET(@"YES", IS_FirstLogin);
                }else{
                    [weakself closeViewAAA:vcself];
                }
            }
        }else{
            YXBindPhoneViewController * VC = [[YXBindPhoneViewController alloc]init];
            VC.bindBlock = ^(NSDictionary * dic) {
                 UserDefaultsSET(dic, KUserInfo);
                 weakself.isLogined = YES;
                 YX_MANAGER.isNeedRefrshMineVc = YES;
                 KPostNotification(KNotificationLoginStateChange, @YES);
                 [vcself dismissViewControllerAnimated:YES completion:nil];
                 [QMUITips showSucceed:@"登录成功"];
            };
            VC.whereCome = NO;
            VC.unique_id = des;
            [vcself.navigationController pushViewController:VC animated:YES];
        }
    }];
}

-(void)closeViewAAA:(UIViewController *)vcself{
    kWeakSelf(self);
    UIViewController *controller = vcself;
    while(controller.presentingViewController != nil){
        controller = controller.presentingViewController;
    }
    [controller dismissViewControllerAnimated:NO completion:^{
        if ([userManager loadUserInfo]) {
            [QMUITips showSucceed:@"登录成功"];
        }else{
            [QMUITips showSucceed:@"绑定成功,请重新登录"];
            KPostNotification(KNotificationLoginStateChange, @NO);
        }
    }];
}


#pragma mark ————— 三方登录 —————
-(void)login:(UserLoginType )loginType completion:(loginBlock)completion{
    [self login:loginType params:nil completion:completion];
}

#pragma mark ————— 带参数登录 —————
-(void)login:(UserLoginType )loginType params:(NSDictionary *)params completion:(loginBlock)completion{
    //友盟登录类型
    UMSocialPlatformType platFormType;
    kWeakSelf(self);
    NSString * third_type = @"";
    if (loginType == kUserLoginTypeQQ) {
        platFormType = UMSocialPlatformType_QQ;
        third_type = @"3";
    }else if (loginType == kUserLoginTypeWeChat){
        platFormType = UMSocialPlatformType_WechatSession;
        third_type = @"1";

    }else if (loginType == kUserLoginTypeWeiBo){
        platFormType = UMSocialPlatformType_Sina;
        third_type = @"2";

    }else{
        platFormType = UMSocialPlatformType_UnKnown;
    }
    //第三方登录
    if (loginType != kUserLoginTypePwd) {
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:platFormType currentViewController:nil completion:^(id result, NSError *error) {
            if (error) {
                [QMUITips showError:error.userInfo[@"message"]];
            } else {
                UMSocialUserInfoResponse *resp = result;
                NSString * cityName = @"";
                NSDictionary *params = @{};
                
                if (platFormType == UMSocialPlatformType_Sina) {
                    NSDictionary * dicwb = resp.originalResponse;
                    cityName = resp.extDic[@"region"];
                    params = @{@"third_type":third_type,
                               @"unique_id":kGetString(dicwb[@"id"]),
                               @"username":dicwb[@"name"],
                               @"photo":dicwb[@"profile_image_url"],
                               @"gender":[resp.unionGender isEqualToString:@"男"] ? @"1":@"0",
                               @"site":cityName
                               };
                }else{
                    cityName = [resp.originalResponse[@"province"] append:resp.originalResponse[@"city"]];
                    params = @{@"third_type":third_type,
                               @"unique_id":resp.openid,
                               @"username":resp.name,
                               @"photo":resp.iconurl,
                               @"gender":[resp.unionGender isEqualToString:@"男"] ? @"1":@"0",
                               @"site":cityName
                               };
                }
                weakself.loginType = loginType;
                
                
                //第三方回调完，开始请求到服务器
                [weakself autoLoginToServer:params completion:completion];
                
                
            }
        }];
    }else{
        //账号登录 暂未提供
        
        [self loginToServer:params completion:completion];
    }
}

#pragma mark ————— 手动登录到服务器 —————
-(void)loginToServer:(NSDictionary *)params completion:(loginBlock)completion{
    [self LoginSuccess:params completion:completion];
}

#pragma mark ————— 自动登录到服务器 —————
-(void)autoLoginToServer:(NSDictionary *)params completion:(loginBlock)completion{
    kWeakSelf(self);
    [YX_MANAGER requestPostThird_party:params success:^(id object) {
        if ([object[@"message"] isEqualToString:@"第一次登录,请绑定手机号."]) {
            if (completion) {
                completion(NO,object[@"unique_id"]);
            }
        }else{
            [weakself LoginSuccess:object completion:completion];
        }
    }];
}

#pragma mark ————— 登录成功处理 —————
-(void)LoginSuccess:(id )responseObject completion:(loginBlock)completion{
    UserDefaultsSET(responseObject, KUserInfo);
    self.isLogined = YES;
    if (completion) {
        completion(YES,nil);
    }
    YX_MANAGER.isNeedRefrshMineVc = YES;
    KPostNotification(KNotificationLoginStateChange, @YES);
}
#pragma mark ————— 加载缓存的用户信息 —————
-(BOOL)loadUserInfo{
    NSDictionary * infoDic = UserDefaultsGET(KUserInfo);
    if (infoDic) {
        return YES;
    }
    return NO;
}
-(NSDictionary *)loadUserAllInfo{
    NSDictionary * infoDic = UserDefaultsGET(KUserInfo);
    if (infoDic) {
        return infoDic;
    }else{
        return  nil;
    }
}
#pragma mark ————— 被踢下线 —————
-(void)onKick{
    [self logout:nil];
}
#pragma mark ————— 退出登录 —————
- (void)logout:(void (^)(BOOL, NSString *))completion{
    [[AppDelegate shareAppDelegate].mainTabBar setSelectedIndex:0];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:KUserInfo];
    self.isLogined = NO;
    YX_MANAGER.isClear = YES;
    YX_MANAGER.isNeedRefrshMineVc = YES;
    [[SocketRocketUtility instance] SRWebSocketClose];
    KPostNotification(KNotificationLoginStateChange, @NO);

}
@end
