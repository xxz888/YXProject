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

@interface YXBindPhoneViewController ()<UITextFieldDelegate>{
    BOOL isSend;
}

@end

@implementation YXBindPhoneViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    //视频播放
    //[self.player play];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary * userInfo = userManager.loadUserAllInfo;
    self.bingBtn.backgroundColor = SEGMENT_COLOR;
    if (self.whereCome) {
        self.phoneTf.text = userInfo[@"mobile"];
        self.phoneTf.userInteractionEnabled = NO;
        self.tipTopLbl.text =@"更换手机号";
    }else{
        self.tipTopLbl.text =@"绑定手机号";
    }

    self.codeTf.delegate = self;
    [self.codeTf addTarget:self action:@selector(changeCodeAction) forControlEvents:UIControlEventAllEvents];
    self.bingBtn.backgroundColor = [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1.0];
    self.bingBtn.userInteractionEnabled = NO;
    
    
//    self.closeBtn.hidden = YES;
    [self.bingBtn setTitle:self.whereCome ? @"下一步" :@"绑定" forState:UIControlStateNormal];

    [self.getMes_codeBtn addTarget:self action:@selector(getSms_CodeAction) forControlEvents:UIControlEventTouchUpInside];
    isSend = NO;

    
}
-(void)changeCodeAction{
    if (self.codeTf.text.length >= 6) {
        self.bingBtn.backgroundColor = SEGMENT_COLOR;
        self.bingBtn.userInteractionEnabled = YES;
    }else{
        self.bingBtn.backgroundColor = [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1.0];
        self.bingBtn.userInteractionEnabled = NO;
    }
}
- (void)getSms_CodeAction{
    
    if (self.phoneTf.text.length <= 10) {
        [QMUITips showError:@"请输入正确的手机号"];
        return;
    }
    NSString * par = [NSString stringWithFormat:@"%@/%@/",self.phoneTf.text,self.whereCome ? @"3" : @"2"];
    kWeakSelf(self);
    [YX_MANAGER requestSmscodeGET:par success:^(id object) {
        [QMUITips showSucceed:@"验证码发送成功" inView:weakself.view hideAfterDelay:2];
        [weakself.getMes_codeBtn startWithTime:60
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
    [self.navigationController popViewControllerAnimated:YES];
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
               weakself.bindBlock([NSDictionary dictionaryWithDictionary:object]);
        }];
    }

}
@end
