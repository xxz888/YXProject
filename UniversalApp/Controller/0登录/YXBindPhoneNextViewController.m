//
//  YXBindPhoneNextViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/3/22.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXBindPhoneNextViewController.h"
#import "UIButton+CountDown.h"

@interface YXBindPhoneNextViewController ()<UITextFieldDelegate>

@end

@implementation YXBindPhoneNextViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.finishBtn.backgroundColor = SEGMENT_COLOR;

    self.nCodeTf.delegate = self;
    [self.nCodeTf addTarget:self action:@selector(changeCodeAction) forControlEvents:UIControlEventAllEvents];
    self.finishBtn.backgroundColor = [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1.0];
    self.finishBtn.userInteractionEnabled = NO;
    [self.getMes_codeBtn addTarget:self action:@selector(getSms_CodeAction) forControlEvents:UIControlEventTouchUpInside];
}
- (void)getSms_CodeAction{
    if (self.nPhoneTf.text.length <= 10) {
        [QMUITips showError:@"请输入正确的手机号"];
        return;
    }
    kWeakSelf(self);
    [YX_MANAGER requestSmscodeGET:[self.nPhoneTf.text append:@"/4/"]  success:^(id object) {
        [QMUITips showSucceed:@"验证码发送成功" inView:weakself.view hideAfterDelay:2];
        [weakself.getMes_codeBtn startWithTime:60
                                     title:@"点击重新获取"
                            countDownTitle:@"s"
                                 mainColor:C_COLOR
                                countColor:C_COLOR];
    }];
    
}
- (IBAction)finishAction:(id)sender{
    kWeakSelf(self);
    if (self.nPhoneTf.text.length <= 10) {
        [QMUITips showError:@"请输入正确的手机号"];
        return;
    }
    if (self.nCodeTf.text.length == 0) {
        [QMUITips showError:@"请输入正确的验证码"];
        return;
    }
    NSString * par = [NSString stringWithFormat:@"%@/%@/%@",@"2",self.nPhoneTf.text,self.nCodeTf.text];

    [YX_MANAGER requestChange_mobile:par success:^(id object) {
        [weakself.navigationController popToRootViewControllerAnimated:YES];
        [QMUITips showSucceed:@"修改成功"];
    }];
}
-(void)changeCodeAction{
    if (self.nCodeTf.text.length >= 4) {
        self.finishBtn.backgroundColor = SEGMENT_COLOR;
        self.finishBtn.userInteractionEnabled = YES;
    }else{
        self.finishBtn.backgroundColor = [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1.0];
        self.finishBtn.userInteractionEnabled = NO;
    }
}
- (IBAction)closeAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
