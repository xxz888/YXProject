//
//  YXBindPhoneViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/3/22.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXBindPhoneViewController.h"
#import "UIButton+CountDown.h"

@interface YXBindPhoneViewController ()

@end

@implementation YXBindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.closeBtn.hidden = self.whereCome;
    self.phoneTf.layer.masksToBounds = YES;
    self.phoneTf.layer.cornerRadius = 3;
    self.codeTf.layer.masksToBounds = YES;
    self.codeTf.layer.cornerRadius = 3;
    ViewBorderRadius(self.getMes_codeBtn, 5, 1, A_COlOR);
    [self.getMes_codeBtn addTarget:self action:@selector(getSms_CodeAction) forControlEvents:UIControlEventTouchUpInside];
    
    ViewBorderRadius(self.phoneTf, 2, 1, KDarkGaryColor);
    ViewBorderRadius(self.codeTf, 2, 1,KDarkGaryColor);
    self.title = @"更换手机号";
}
- (void)getSms_CodeAction{
    [YX_MANAGER requestSmscodeGET:self.phoneTf.text success:^(id object) {
        [QMUITips showSucceed:@"验证码发送成功" inView:self.view hideAfterDelay:2];
        [self.getMes_codeBtn startWithTime:180
                                     title:@"点击重新获取"
                            countDownTitle:@"s"
                                 mainColor:[UIColor colorWithRed:84 / 255.0 green:180 / 255.0 blue:98 / 255.0 alpha:1.0f]
                                countColor:[UIColor colorWithRed:84 / 255.0 green:180 / 255.0 blue:98 / 255.0 alpha:1.0f]];
    }];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)closeAction:(id)sender {
}

- (IBAction)bindAction:(id)sender {
}
@end
