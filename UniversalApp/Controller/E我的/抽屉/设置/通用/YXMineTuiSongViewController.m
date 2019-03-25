//
//  YXMineTuiSongViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/3/25.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineTuiSongViewController.h"

@interface YXMineTuiSongViewController ()

@end

@implementation YXMineTuiSongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //解决方案
    self.automaticallyAdjustsScrollViewInsets=false;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = @"推送设置";
    self.tableView.tableFooterView = [[UIView alloc]init];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [super tableView:tableView numberOfRowsInSection:section];
}
- (IBAction)tongzhiSettingAction:(id)sender {
    // 效果2 -跳入该应用的通知设置页面
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    NSURL *openUrl = [NSURL URLWithString:[NSString stringWithFormat:@"App-Prefs:root=NOTIFICATIONS_ID&path=%@",identifier]];
    if ([[UIApplication sharedApplication] canOpenURL:openUrl]){
        //在iOS应用程序中打开设备设置界面及其中某指定的选项界面-通知界面
        [[UIApplication sharedApplication] openURL:openUrl];
    }
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
