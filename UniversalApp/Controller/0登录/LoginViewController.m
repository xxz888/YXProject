//
//  LoginViewController.m
//  MiAiApp
//  17613691277 guojing
//  Created by 徐阳 on 2017/5/18.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import "LoginViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIButton+CountDown.h"
#import "YXBindPhoneViewController.h"
#import "YXLoginXieYiViewController.h"
#import "YXWanShanXinXiViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
//1 播放器
@property (strong, nonatomic) AVPlayer *player;
- (IBAction)btn1Action:(id)sender;
- (IBAction)btn2Action:(id)sender;
@property(nonatomic,strong)QMUIButton * button;
@end

@implementation LoginViewController
#pragma mark - 1 viewWillAppear 就进行播放
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    //视频播放
      kWeakSelf(self);
      [YXPLUS_MANAGER requestPubTagPOST:@{} success:^(id object) {
          if ([object isEqualToString:@"0"]) {
              weakself.moreLoginView.hidden = weakself.moreLoginLbl.hidden = YES;
          }else{
               weakself.moreLoginView.hidden = weakself.moreLoginLbl.hidden = NO;
          }
      }];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginBtn.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    self.codeTf.delegate = self;
    [self.codeTf addTarget:self action:@selector(changeCodeAction) forControlEvents:UIControlEventAllEvents];
    self.loginBtn.userInteractionEnabled = NO;
    [self.getMes_codeBtn addTarget:self action:@selector(getSms_CodeAction) forControlEvents:UIControlEventTouchUpInside];
}
- (IBAction)btn1Action:(id)sender {
    UIStoryboard * stroryBoard1 = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    YXLoginXieYiViewController * VC = [stroryBoard1 instantiateViewControllerWithIdentifier:@"YXLoginXieYiViewController"];
    VC.type = @"1";
    [self.navigationController pushViewController:VC animated:YES];
}
- (IBAction)btn2Action:(id)sender {
    UIStoryboard * stroryBoard1 = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    YXLoginXieYiViewController * VC = [stroryBoard1 instantiateViewControllerWithIdentifier:@"YXLoginXieYiViewController"];
    VC.type = @"2";
    [self.navigationController pushViewController:VC animated:YES];
}
- (IBAction)loginAction:(id)sender {
    kWeakSelf(self);
    [YX_MANAGER requestLoginPOST:@{@"mobile":self.phoneTf.text,@"sms_code":self.codeTf.text} success:^(id object) {
            [userManager login:kUserLoginTypePwd params:object completion:^(BOOL success, NSString *des) {
                [weakself wanShanZiLiao:self];
            }];
    }];
}
-(void)wanShanZiLiao:(UIViewController *)weakself{
    if (UserDefaultsGET(IS_FirstLogin)) {
        NSString * is_firstLogin = UserDefaultsGET(IS_FirstLogin);
        if ([is_firstLogin isEqualToString:@"NO"]) {
            UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            YXWanShanXinXiViewController * vc = [stroryBoard4 instantiateViewControllerWithIdentifier:@"YXWanShanXinXiViewController"];
            [weakself.navigationController pushViewController:vc animated:YES];
            UserDefaultsSET(@"YES", IS_FirstLogin);
        }else{
            [weakself dismissViewControllerAnimated:YES completion:nil];
            [[AppDelegate shareAppDelegate].mainTabBar setSelectedIndex:0];
            [QMUITips showSucceed:@"登录成功"];
        }
    }
}
- (IBAction)closeLoginView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getSms_CodeAction{
 
    if (self.phoneTf.text.length <= 9) {
        [QMUITips showError:@"请输入正确的手机号"];
        return;
    }
    kWeakSelf(self);
    [YX_MANAGER requestSmscodeGET:[self.phoneTf.text append:@"/1/"] success:^(id object) {
            [QMUITips showSucceed:@"验证码发送成功" inView:weakself.view hideAfterDelay:1];
            [weakself.getMes_codeBtn startWithTime:60
                                         title:@"点击重新获取"
                                countDownTitle:@"s"
                                     mainColor:KClearColor
                                    countColor:KClearColor];
    }];
}
-(void)changeCodeAction{
    if (self.codeTf.text.length >= 6) {
        self.loginBtn.backgroundColor = SEGMENT_COLOR;
        [self.loginBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
        self.loginBtn.userInteractionEnabled = YES;
    }else{
        self.loginBtn.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        self.loginBtn.userInteractionEnabled = NO;
    }
}

#pragma mark - 视频播放结束 触发
- (void)playToEnd
{
    // 重头再来
    [self.player seekToTime:kCMTimeZero];
}

- (IBAction)weiboLoginAction:(id)sender {
    [userManager LoginVCCommonAction:self type:kUserLoginTypeWeiBo];
}
- (IBAction)wxLoginAction:(id)sender {
    [userManager LoginVCCommonAction:self type:kUserLoginTypeWeChat];
}
- (IBAction)qqLoginAction:(id)sender {
    [userManager LoginVCCommonAction:self type:kUserLoginTypeQQ];
}
@end
