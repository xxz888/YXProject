//
//  YXBindPhoneViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/3/22.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXBindPhoneViewController.h"
#import "UIButton+CountDown.h"
#import "YXBindPhoneNextViewController.h"

@interface YXBindPhoneViewController (){
    BOOL isSend;
}

@end

@implementation YXBindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UserInfo *userInfo = curUser;
    
    if (self.whereCome) {
        self.phoneTf.text = userInfo.mobile;
        self.phoneTf.userInteractionEnabled = NO;
        self.title =@"更换手机号";
    }else{
        self.title =@"绑定手机号";

    }

    
    self.tipTopLbl.text = [NSString stringWithFormat:@"当前绑定手机号是%@,请在下方输入你希望绑定的手机号",userInfo.mobile];
    
     self.closeBtn.hidden = YES;
    self.tipTopLbl.hidden = !self.whereCome;
    [self.bingBtn setTitle:self.whereCome ? @"下一步" :@"绑定" forState:UIControlStateNormal];
    self.phoneTf.layer.masksToBounds = YES;
    self.phoneTf.layer.cornerRadius = 3;
    self.codeTf.layer.masksToBounds = YES;
    self.codeTf.layer.cornerRadius = 3;
    ViewBorderRadius(self.getMes_codeBtn, 5, 1, A_COlOR);
    [self.getMes_codeBtn addTarget:self action:@selector(getSms_CodeAction) forControlEvents:UIControlEventTouchUpInside];
    isSend = NO;
    ViewBorderRadius(self.phoneTf, 2, 1, C_COLOR);
    ViewBorderRadius(self.codeTf, 2, 1,C_COLOR);
    
}
- (void)getSms_CodeAction{
    
    if (self.phoneTf.text.length <= 10) {
        [QMUITips showError:@"请输入正确的手机号"];
        return;
    }
    NSString * par = [NSString stringWithFormat:@"%@/%@/",self.phoneTf.text,self.whereCome ? @"3" : @"2"];
    [YX_MANAGER requestSmscodeGET:par success:^(id object) {
        [QMUITips showSucceed:@"验证码发送成功" inView:self.view hideAfterDelay:2];
        [self.getMes_codeBtn startWithTime:180
                                     title:@"点击重新获取"
                            countDownTitle:@"s"
                                 mainColor:C_COLOR
                                countColor:C_COLOR];
        
        isSend = YES;
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)bindAction:(id)sender {
    //yes为更换手机号
    if (self.whereCome) {
        if (isSend) {
            kWeakSelf(self);
            if (self.phoneTf.text.length <= 10) {
                [QMUITips showError:@"请输入正确的手机号"];
                return;
            }
            if (self.codeTf.text.length == 0) {
                [QMUITips showError:@"请输入正确的验证码"];
                return;
            }
            NSString * par = [NSString stringWithFormat:@"%@/%@/%@",@"1",self.phoneTf.text,self.codeTf.text];
            [YX_MANAGER requestChange_mobile:par success:^(id object) {
                YXBindPhoneNextViewController * VC = [[YXBindPhoneNextViewController alloc]init];
                [weakself.navigationController pushViewController:VC animated:YES];
            }];
            
  
        }else{
            [QMUITips showInfo:@"请发送手机验证码"];
        }
       
    }else{
        kWeakSelf(self);
        NSDictionary * dic = @{
                               @"unique_id":self.unique_id,
                               @"mobile":self.phoneTf.text,
                               @"sms_code":self.codeTf.text
                               };
        [YX_MANAGER requestPostBinding_party:dic success:^(id object) {
            weakself.bindBlock();
        }];
    }

}
@end
