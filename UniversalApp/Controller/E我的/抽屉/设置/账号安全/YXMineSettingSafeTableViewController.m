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


- (void)viewDidLoad {
    [super viewDidLoad];
    UserInfo *userInfo = curUser;
    self.phoneTf.text = userInfo.mobile;
    if (!userInfo.weibo_name || [userInfo.weibo_name isEqualToString:@""]) {
        self.wbTf.text = @"未绑定";
    }else{
        self.wbTf.text = userInfo.weibo_name;
    }
    
    if (!userInfo.weixin_name || [userInfo.weixin_name isEqualToString:@""]) {
        self.wxAccTf.text = @"未绑定";
    }else{
        self.wxAccTf.text = userInfo.weixin_name;
    }
    //解决方案
    self.automaticallyAdjustsScrollViewInsets=false;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = @"账号安全";
    self.tableView.tableFooterView = [[UIView alloc]init];
}
-(void)bingAction{
    kWeakSelf(self);
//    [MBProgressHUD showActivityMessageInView:@"授权中..."];
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            [MBProgressHUD hideHUD];
        } else {
            
            UMSocialUserInfoResponse *resp = result;
            //
            //                // 授权信息
            //                NSLog(@"QQ uid: %@", resp.uid);
            //                NSLog(@"QQ openid: %@", resp.openid);
            //                NSLog(@"QQ accessToken: %@", resp.accessToken);
            //                NSLog(@"QQ expiration: %@", resp.expiration);
            //
            //                // 用户信息
            //                NSLog(@"QQ name: %@", resp.name);
            //                NSLog(@"QQ iconurl: %@", resp.iconurl);
            //                NSLog(@"QQ gender: %@", resp.unionGender);
            //
            //                // 第三方平台SDK源数据
            //                NSLog(@"QQ originalResponse: %@", resp.originalResponse);
            
            NSString * cityName = [resp.originalResponse[@"province"] append:resp.originalResponse[@"city"]];
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
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
