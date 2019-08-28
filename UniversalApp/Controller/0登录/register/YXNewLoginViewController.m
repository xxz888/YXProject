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
//    [QMUITips showInfo:@"开发中"];
    [self WeiBoLogin];
}
- (IBAction)wxLoginAction:(id)sender {
    [self WXLogin];
}
- (IBAction)qqLoginAction:(id)sender {
    [self QQLogin];
    
}

-(void)WeiBoLogin{
    kWeakSelf(self);
    [userManager login:kUserLoginTypeWeiBo completion:^(BOOL success, NSString *des) {
        if (success) {
            [weakself closeViewAAA];
        }else{
            
            YXBindPhoneViewController * VC = [[YXBindPhoneViewController alloc]init];
            VC.bindBlock = ^{
                [weakself.navigationController popViewControllerAnimated:YES];
            };
            VC.whereCome = NO;
            VC.unique_id = des;
            [weakself.navigationController pushViewController:VC animated:YES];
        }
    }];
}


-(void)WXLogin{
    kWeakSelf(self);
    [userManager login:kUserLoginTypeWeChat completion:^(BOOL success, NSString *des) {
        if (success) {
            [weakself closeViewAAA];
        }else{
            YXBindPhoneViewController * VC = [[YXBindPhoneViewController alloc]init];
            VC.title = @"绑定手机号";
            RootNavigationController *nav = [[RootNavigationController alloc]initWithRootViewController:VC];
            VC.bindBlock = ^{
                [weakself closeViewAAA];
            };
            VC.whereCome = NO;
            VC.unique_id = des;
            [weakself presentViewController:nav animated:YES completion:nil];
        }
    }];
}
-(void)QQLogin{
    kWeakSelf(self);
    [userManager login:kUserLoginTypeQQ completion:^(BOOL success, NSString *des) {
        if (success) {
            [weakself closeViewAAA];
        }else{
            YXBindPhoneViewController * VC = [[YXBindPhoneViewController alloc]init];
            VC.title = @"绑定手机号";
            RootNavigationController *nav = [[RootNavigationController alloc]initWithRootViewController:VC];
            VC.bindBlock = ^{
                [weakself closeViewAAA];
            };
            VC.whereCome = NO;
            VC.unique_id = des;
            [weakself presentViewController:nav animated:YES completion:nil];
        }
    }];
}
-(void)closeViewAAA{
    kWeakSelf(self);
    UIViewController *controller = self;
    while(controller.presentingViewController != nil){
        controller = controller.presentingViewController;
    }
    [controller dismissViewControllerAnimated:NO completion:^{
        
        
        if ([userManager loadUserInfo]) {
            [QMUITips showSucceed:@"登录成功"];
            [[AppDelegate shareAppDelegate].mainTabBar setSelectedIndex:0];
            [weakself closeViewAAA];
            
        }else{
            [QMUITips showSucceed:@"绑定成功,请重新登录"];
            KPostNotification(KNotificationLoginStateChange, @NO);
        }
        
        
        
        
        
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

@end
