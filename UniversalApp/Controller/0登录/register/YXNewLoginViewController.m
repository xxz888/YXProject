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
@interface YXNewLoginViewController ()

@end

@implementation YXNewLoginViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:10/255.0 green:36/255.0 blue:54/255.0 alpha:1.0];
    self.phoneLogin.imageView.contentMode = UIViewContentModeScaleAspectFill;
}
- (IBAction)closeLoginView:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
