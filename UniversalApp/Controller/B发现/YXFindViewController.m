//
//  YXFindViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/3.
//  Copyright © 2019年 徐阳. All rights reserved.
//
#import "YXFindViewController.h"
@interface YXFindViewController ()
@end
@implementation YXFindViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.yxTableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - kTopHeight - TabBarHeight - 40);
    [self requestTableData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)headerRereshing{
    [super headerRereshing];
    [self requestTableData];
}
-(void)footerRereshing{
    [super footerRereshing];
    [self requestTableData];
}
#pragma mark ========== 2222222-在请求具体tag下的请求,获取发现页标签数据全部接口 ==========
-(void)requestTableData{
    kWeakSelf(self);
    NSString * parString =[NSString stringWithFormat:@"%@&page=%@",kGetString(self.startDic[@"id"]),NSIntegerToNSString(self.requestPage)];
    [YX_MANAGER requestGet_users_find:parString success:^(id object){
        weakself.dataArray = [weakself commonAction:object dataArray:weakself.dataArray];
        [weakself.yxTableView reloadData];
    }];
}
@end
