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

@interface YXNewLoginViewController ()

@end

@implementation YXNewLoginViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    kWeakSelf(self);
    [YXPLUS_MANAGER requestPubTagPOST:@{} success:^(id object) {
        if ([object isEqualToString:@"0"]) {
            weakself.wxLogin.hidden = weakself.moreLoginView.hidden = weakself.moreLoginLbl.hidden = YES;
        }else{
            weakself.wxLogin.hidden = weakself.moreLoginView.hidden = weakself.moreLoginLbl.hidden = NO;
        }
    }];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SEGMENT_COLOR;
    self.phoneLogin.imageView.contentMode = UIViewContentModeScaleAspectFill;
}
- (IBAction)closeLoginView:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{}];
}
- (IBAction)phoneLoginAction:(id)sender {
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    LoginViewController * VC = [stroryBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:VC animated:YES];
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
@end
