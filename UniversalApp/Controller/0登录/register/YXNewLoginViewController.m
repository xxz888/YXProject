//
//  YXNewLoginViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/8/28.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXNewLoginViewController.h"
#import "LoginViewController.h"
#import "YXBindPhoneViewController.h"
#import "YXLoginXieYiViewController.h"
#import "UIButton+CountDown.h"
#import "YXNewLoginMessageViewController.h"

@interface YXNewLoginViewController ()

@end

@implementation YXNewLoginViewController
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
    self.view.backgroundColor = SEGMENT_COLOR;
//    self.wxLogin
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:
    @{NSForegroundColorAttributeName:kRGBA(102, 102, 102, 1),NSFontAttributeName:self.phoneTf.font}];
    self.phoneTf.attributedPlaceholder = attrString;
}
- (IBAction)closeLoginView:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{}];
}
//- (IBAction)phoneLoginAction:(id)sender {
//    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//    LoginViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
//    [self.navigationController pushViewController:VC animated:YES];
//}
//- (IBAction)weiboLoginAction:(id)sender {
//    [userManager LoginVCCommonAction:self type:kUserLoginTypeWeiBo];
//}
- (IBAction)wxLoginAction:(id)sender {
    [userManager LoginVCCommonAction:self type:kUserLoginTypeWeChat];
}
- (IBAction)qqLoginAction:(id)sender {
    [userManager LoginVCCommonAction:self type:kUserLoginTypeQQ];
}
- (IBAction)getSms_CodeAction:(id)sender {
    if (self.phoneTf.text.length <= 9) {
          [QMUITips showError:@"请输入正确的手机号"];
          return;
      }
    
  
      kWeakSelf(self);
      [YX_MANAGER requestSmscodeGET:[self.phoneTf.text append:@"/1/"] success:^(id object) {
          UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            YXNewLoginMessageViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"YXNewLoginMessageViewController"];
            VC.phone = self.phoneTf.text;
           [weakself.navigationController pushViewController:VC animated:YES];
      }];
}
@end
