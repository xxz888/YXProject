//
//  YXNewLoginMessageViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2020/1/15.
//  Copyright © 2020 徐阳. All rights reserved.
//

#import "YXNewLoginMessageViewController.h"
#import "UIButton+CountDown.h"
#import "YXWanShanXinXiViewController.h"

@interface YXNewLoginMessageViewController ()

@end

@implementation YXNewLoginMessageViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.lbl1.text = [NSString stringWithFormat:@"已向您的手机 %@ 发送验证码",[self.phone substringFromIndex:7]];
    [self.getMes_codeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
    [self.getMes_codeBtn startWithTime:60
                                             title:@"重新发送"
                                    countDownTitle:@"s"
                                         mainColor:KClearColor
                                        countColor:KClearColor];
    
    
}
-(void)loginIN:(NSString *)sms_code{
      kWeakSelf(self);
      [YX_MANAGER requestLoginPOST:@{@"mobile":self.phone,@"sms_code":sms_code} success:^(id object) {
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backVcAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)getSms_CodeAction:(id)sender {
      kWeakSelf(self);
      [YX_MANAGER requestSmscodeGET:[self.phone append:@"/1/"] success:^(id object) {
              [QMUITips showSucceed:@"验证码发送成功" inView:weakself.view hideAfterDelay:1];
              [weakself.getMes_codeBtn startWithTime:60
                                           title:@"重新发送"
                                  countDownTitle:@"s"
                                       mainColor:KClearColor
                                      countColor:KClearColor];
      }];
}

@end
