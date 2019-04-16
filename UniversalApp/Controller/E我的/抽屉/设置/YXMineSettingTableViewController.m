//
//  YXMineSettingTableViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/25.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineSettingTableViewController.h"
#import "YXMineSettingSafeTableViewController.h"
#import "YXHomeEditPersonTableViewController.h"
#import "YXMineTongYongTableViewController.h"

@interface YXMineSettingTableViewController ()

@end

@implementation YXMineSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //解决方案
    self.automaticallyAdjustsScrollViewInsets=false;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = @"设置";
    self.tableView.tableFooterView = [[UIView alloc]init];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [super tableView:tableView numberOfRowsInSection:section];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"YXMine" bundle:nil];
    kWeakSelf(self);
    switch (indexPath.section) {
        case 0:
            //账号与安全
            if (indexPath.row == 0) {
                UserInfo * userInfo= curUser;
                [YX_MANAGER requestGetUserothers:userInfo.id success:^(id object) {
                    YXHomeEditPersonTableViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"YXHomeEditPersonTableViewController"];
                    VC.userInfoDic = [NSDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithDictionary:object]];
                    [weakself.navigationController pushViewController:VC animated:YES];
                }];
            //个人资料
            }else if (indexPath.row == 1) {
                YXMineSettingSafeTableViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"YXMineSettingSafeTableViewController"];
                [self.navigationController pushViewController:VC animated:YES];
            }else if (indexPath.row == 2){
                YXMineTongYongTableViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"YXMineTongYongTableViewController"];
                [self.navigationController pushViewController:VC animated:YES];
            }else if (indexPath.row == 3){
                
            }else if (indexPath.row == 4){
                
            }else if (indexPath.row == 5){
                
            }
                
            break;
        case 1:
            //去appstore评分
            if (indexPath.row == 0) {
                [ShareManager returnUpdateVersion];
            //关于我们
            }else if (indexPath.row == 1){
                
            }
            break;
            
        default:
            break;
    }
}
- (IBAction)exitAppAction:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
    kWeakSelf(self);
    [userManager logout:^(BOOL success, NSString *des) {
    }];
}

-(void)jumpVC:(UIViewController *)vc{
    NSArray *vcs = self.navigationController.viewControllers;
    NSMutableArray *newVCS = [NSMutableArray array];
    if ([vcs count] > 0) {
        for (int i=0; i < [vcs count]-1; i++) {
            [newVCS addObject:[vcs objectAtIndex:i]];
        }
    }
    [newVCS addObject:vc];
    [self.navigationController setViewControllers:newVCS animated:YES];
    
}
-(void)closeViewAAA{
    UIViewController *controller = self;
    while(controller.presentingViewController != nil){
        controller = controller.presentingViewController;
    }
    [controller dismissViewControllerAnimated:NO completion:^{

    }];
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
