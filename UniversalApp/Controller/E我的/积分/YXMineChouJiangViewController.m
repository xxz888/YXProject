//
//  YXMineChouJiangViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/9/3.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXMineChouJiangViewController.h"

@interface YXMineChouJiangViewController ()

@end

@implementation YXMineChouJiangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    UserInfo *userInfo = curUser;

    self.url = [@"http://192.168.101.21:63340/%E7%9F%A9%E5%BD%A2%E6%8A%BD%E5%A5%96%E6%B4%BB%E5%8A%A8html/index.html?" append:userInfo.token];


#pragma mark--button create
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(16, 40, 20, 20);
    [btn setBackgroundImage:[UIImage imageNamed:@"黑色返回"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}


-(void)clicked:(UIButton *)btn{
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
