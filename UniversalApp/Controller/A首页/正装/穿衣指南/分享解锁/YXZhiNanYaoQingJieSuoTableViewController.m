//
//  YXZhiNanYaoQingJieSuoTableViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/10/10.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXZhiNanYaoQingJieSuoTableViewController.h"

@interface YXZhiNanYaoQingJieSuoTableViewController ()

@end

@implementation YXZhiNanYaoQingJieSuoTableViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
//
- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.shengyulbl.text = [NSString stringWithFormat:@"—— 还差%@位好友助力，即可解锁所有文章阅读 ——",@"三"];
    
    //获取好友帮助列表
    [self getdata];
}
-(void)getdata{
    kWeakSelf(self);
    [YXPLUS_MANAGER requestOption_lock_history:@"" success:^(id object) {
        
    }];
}
//分享到朋友圈解锁
- (IBAction)fenxiangh5:(id)sender {
    NSString * title = @"蓝皮书,品位生活指南@蓝皮书app";
    NSString * desc = @"Ta开启了蓝皮书之旅,快来加入吧";
   [[ShareManager sharedShareManager] pushShareViewAndDic:@{
          @"type":@"4",@"desc":desc,@"title":title,@"thumbImage":@"http://photo.lpszn.com/appiconWechatIMG1store_1024pt.png"}];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [super tableView:tableView numberOfRowsInSection:section];
}
- (IBAction)backVcAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
