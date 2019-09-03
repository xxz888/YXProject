//
//  UserManager.m
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/22.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import "UserManager.h"
#import "YXBindPhoneViewController.h"
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
            [weakself closeViewAAA:vcself];
        }else{
            
            YXBindPhoneViewController * VC = [[YXBindPhoneViewController alloc]init];
            VC.bindBlock = ^{
                [vcself dismissViewControllerAnimated:YES completion:nil];
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
            [[AppDelegate shareAppDelegate].mainTabBar setSelectedIndex:0];
            [weakself closeViewAAA:vcself];

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

//    [MBProgressHUD showActivityMessageInView:@"登录中..."];
//    [PPNetworkHelper POST:NSStringFormat(@"%@%@",API_ROOT_URL_HTTP_FORMAL,URL_user_login) parameters:params success:^(id responseObject) {
//        [self LoginSuccess:responseObject completion:completion];
//
//    } failure:^(NSError *error) {
//        [MBProgressHUD hideHUD];
//        if (completion) {
//            completion(NO,error.localizedDescription);
//        }
//    }];
}

#pragma mark ————— 自动登录到服务器 —————
-(void)autoLoginToServer:(NSDictionary *)params completion:(loginBlock)completion{
    kWeakSelf(self);
    [YX_MANAGER requestPostThird_party:params success:^(id object) {
        [MBProgressHUD hideHUD];
        if ([object[@"message"] isEqualToString:@"第一次登录,请绑定手机号."]) {
            if (completion) {
                completion(NO,object[@"unique_id"]);
            }
        }else{
            [weakself LoginSuccess:object completion:completion];
        }
    }];
    
    
    
    
//    [PPNetworkHelper POST:NSStringFormat(@"%@%@",API_ROOT_URL_HTTP_FORMAL,URL_user_auto_login) parameters:nil success:^(id responseObject) {
//        [self LoginSuccess:responseObject completion:completion];
//
//    } failure:^(NSError *error) {
//        if (completion) {
//            completion(NO,error.localizedDescription);
//        }
//    }];
}

#pragma mark ————— 登录成功处理 —————
-(void)LoginSuccess:(id )responseObject completion:(loginBlock)completion{
    self.curUserInfo = [UserInfo modelWithDictionary:responseObject];
    [self saveUserInfo];
    self.isLogined = YES;
    if (completion) {
        completion(YES,nil);
    }
    KPostNotification(KNotificationLoginStateChange, @YES);
    return;
    
    if (ValidDict(responseObject)) {
        if (ValidDict(responseObject[@"data"])) {
            NSDictionary *data = responseObject[@"data"];
            if (ValidStr(data[@"imId"]) && ValidStr(data[@"imPass"])) {
                //登录IM
                [[IMManager sharedIMManager] IMLogin:data[@"imId"] IMPwd:data[@"imPass"] completion:^(BOOL success, NSString *des) {
                    [MBProgressHUD hideHUD];
                    if (success) {
                        self.curUserInfo = [UserInfo modelWithDictionary:data];
                        [self saveUserInfo];
                        self.isLogined = YES;
                        if (completion) {
                            completion(YES,nil);
                        }
                        KPostNotification(KNotificationLoginStateChange, @YES);
                    }else{
                        if (completion) {
                            completion(NO,@"IM登录失败");
                        }
                        KPostNotification(KNotificationLoginStateChange, @NO);
                    }
                }];
            }else{
                if (completion) {
                    completion(NO,@"登录返回数据异常");
                }
                KPostNotification(KNotificationLoginStateChange, @NO);
            }
            
        }
    }else{
        if (completion) {
            completion(NO,@"登录返回数据异常");
        }
        KPostNotification(KNotificationLoginStateChange, @NO);
    }
    
}
#pragma mark ————— 储存用户信息 —————
-(void)saveUserInfo{
    if (self.curUserInfo) {
        YYCache *cache = [[YYCache alloc]initWithName:KUserCacheName];
        NSDictionary *dic = [self.curUserInfo modelToJSONObject];
        [cache setObject:dic forKey:KUserModelCache];
    }
}
#pragma mark ————— 加载缓存的用户信息 —————
-(BOOL)loadUserInfo{
    YYCache *cache = [[YYCache alloc]initWithName:KUserCacheName];
    NSDictionary * userDic = (NSDictionary *)[cache objectForKey:KUserModelCache];
    if (userDic) {
        self.curUserInfo = [UserInfo modelWithJSON:userDic];
        return YES;
    }
    return NO;
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
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationLogout object:nil];//被踢下线通知用户退出直播间
    
    [[IMManager sharedIMManager] IMLogout];
    
    self.curUserInfo = nil;
    self.isLogined = NO;
    YX_MANAGER.isClear = NO;
//    //移除缓存
    YYCache *cache = [[YYCache alloc]initWithName:KUserCacheName];
    [cache removeAllObjectsWithBlock:^{
        if (completion) {
            completion(YES,nil);
        }
    }];
    KPostNotification(KNotificationLoginStateChange, @NO);

}
@end
