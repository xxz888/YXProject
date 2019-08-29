//
//  YXMineSettingSafeTableViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/25.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineSettingSafeTableViewController.h"
#import "YXBindPhoneViewController.h"

@interface YXMineSettingSafeTableViewController ()

@end

@implementation YXMineSettingSafeTableViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UserInfo *userInfo = curUser;
    self.phoneTf.text = userInfo.mobile;
    self.phoneTf.textColor = kRGBA(187, 187, 187, 1);

    if (!userInfo.weibo_name || [userInfo.weibo_name isEqualToString:@""]) {
        self.wbTf.text = @"未绑定";
        self.wbTf.textColor = kRGBA(10, 36, 51, 1);
    }else{
        self.wbTf.text = userInfo.weibo_name;
        self.wbTf.textColor = kRGBA(187, 187, 187, 1);
    }
    
    if (!userInfo.weixin_name || [userInfo.weixin_name isEqualToString:@""]) {
        self.wxAccTf.text = @"未绑定";
        self.wxAccTf.textColor = kRGBA(10, 36, 51, 1);
    }else{
        self.wxAccTf.text = userInfo.weixin_name;
        self.wxAccTf.textColor = kRGBA(187, 187, 187, 1);
    }
    
    
    
    self.qqTf.text = @"未绑定";
    self.qqTf.textColor = kRGBA(10, 36, 51, 1);

//    if (!userInfo.weibo_name || [userInfo.weibo_name isEqualToString:@""]) {
//        self.qqTf.text = @"未绑定";
//    }else{
//        self.qqTf.text = userInfo.weibo_name;
//    }
    //解决方案
    self.automaticallyAdjustsScrollViewInsets=false;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = @"账号安全";
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    
    
    
}
-(void)bingAction{
    kWeakSelf(self);
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            [MBProgressHUD hideHUD];
        } else {
            UMSocialUserInfoResponse *resp = result;
            //登录参数
            NSDictionary *params = @{@"third_type":@"1",
                                     @"third_name":resp.name,
                                     @"unique_id":resp.openid,
                                     };
            [YX_MANAGER requestPostBinding_Accparty:params success:^(id object) {
                [QMUITips showSucceed:@"绑定成功"];
                weakself.wxAccTf.text = resp.name;
            }];
            
        }
    }];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [super numberOfSectionsInTableView:tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [super tableView:tableView numberOfRowsInSection:section];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    

    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        YXBindPhoneViewController * VC = [[YXBindPhoneViewController alloc]init];
        VC.whereCome = YES;
        [self.navigationController pushViewController:VC animated:YES];
    }else if (indexPath.row == 1){
        if ([self.wxAccTf.text isEqualToString:@"未绑定"]) {
            [self bingAction];
        }
    }
}
@end
