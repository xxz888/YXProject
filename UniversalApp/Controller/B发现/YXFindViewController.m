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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSecondVC:) name:@"refreshSecondVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(panduanUMXiaoXi1:) name:UM_User_Info_1 object:nil];
}
-(void)panduanUMXiaoXi1:(NSNotification *)notification{
    [self panduanxiaoxi:[notification object]];
}
-(void)panduanxiaoxi:(NSDictionary *)umDic{
    if (umDic && umDic.count > 0 && [self.startDic[@"id"] integerValue] == -1) {
        kWeakSelf(self);
        YXMineImageDetailViewController * VC = [[YXMineImageDetailViewController alloc]init];
        [YX_MANAGER requestget_post_by_id:kGetString(umDic[@"key1"]) success:^(id object) {
           
            CGFloat h = [YXFirstFindImageTableViewCell cellDefaultHeight:object];
            VC.headerViewHeight = h;
            VC.startDic = [NSMutableDictionary dictionaryWithDictionary:object];
            [weakself.navigationController pushViewController:VC animated:YES];
        }];
    }
}
- (void)dealloc {
    //单条移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshSecondVC" object:nil];
    //移除所有观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)refreshSecondVC: (NSNotification *) notification {
    kWeakSelf(self);
    NSString * parString =[NSString stringWithFormat:@"%@&page=%@",@"1",NSIntegerToNSString(self.requestPage)];
//    [QMUITips showLoadingInView:self.view];
    [YX_MANAGER requestGet_users_find:parString success:^(id object){
        [QMUITips hideAllTips];
        weakself.dataArray = [weakself commonAction:object dataArray:weakself.dataArray];
        [weakself.yxTableView reloadData];
        weakself.nodataImg.hidden = weakself.dataArray.count != 0;
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestTableData];
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
    [QMUITips showLoadingInView:self.view];
    [YX_MANAGER requestGet_users_find:parString success:^(id object){
        [QMUITips hideAllTips];
        weakself.dataArray = [weakself commonAction:object dataArray:weakself.dataArray];
        [weakself.yxTableView reloadData];
        weakself.nodataImg.hidden = YES;
    }];
}

@end
