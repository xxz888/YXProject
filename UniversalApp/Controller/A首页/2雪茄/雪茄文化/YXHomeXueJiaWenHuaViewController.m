//
//  YXHomeXueJiaWenHuaViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/11.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaWenHuaViewController.h"
#import "YXHomeXueJiaWenHuaTableViewCell.h"
#import "YXXueJiaXXZWHViewController.h"
#import "YXMineImageDetailViewController.h"
@interface YXHomeXueJiaWenHuaViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation YXHomeXueJiaWenHuaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"雪茄文化";
    [self tableviewCon];
    [self addRefreshView:self.yxTableView];
    [self requestCrgar];

}
#pragma mark ========== 创建tableview ==========
-(void)tableviewCon{
    self.dataArray = [[NSMutableArray alloc]init];
    self.yxTableView = [[UITableView alloc]init];
       self.yxTableView.frame = CGRectMake(0,kTopHeight, KScreenWidth, KScreenHeight - kTopHeight);
    [self.view addSubview:self.yxTableView];
    self.yxTableView.delegate = self;
    self.yxTableView.dataSource= self;
    self.yxTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.yxTableView.showsVerticalScrollIndicator = NO;
    self.yxTableView.estimatedRowHeight = 0;
    self.yxTableView.estimatedSectionHeaderHeight = 0;
    self.yxTableView.estimatedSectionFooterHeight = 0;
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXHomeXueJiaWenHuaTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXHomeXueJiaWenHuaTableViewCell"];
}
-(void)headerRereshing{
    [super headerRereshing];
    [self requestCrgar];
}
-(void)footerRereshing{
    [super footerRereshing];
    [self requestCrgar];
}
-(void)requestCrgar{
    kWeakSelf(self);
    NSString * par = [NSString stringWithFormat:@"%@/%@",NSIntegerToNSString(self.requestPage),@"1"];
    [YX_MANAGER requestCigar_cultureGET:par success:^(id object) {
        weakself.dataArray = [weakself commonAction:object dataArray:weakself.dataArray];
        [weakself.yxTableView reloadData];
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.row];
    return [YXHomeXueJiaWenHuaTableViewCell cellDefaultHeight:dic];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXHomeXueJiaWenHuaTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXHomeXueJiaWenHuaTableViewCell" forIndexPath:indexPath];
    NSDictionary * dic = self.dataArray[indexPath.row];
    [cell setCellData:dic];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YXXueJiaXXZWHViewController * VC = [[YXXueJiaXXZWHViewController alloc]init];
        NSDictionary * dic = self.dataArray[indexPath.row];
        VC.webDic =[NSMutableDictionary dictionaryWithDictionary:dic];
    [self.navigationController pushViewController:VC animated:YES];
//    YXHomeXueJiaWenHuaDetailViewController * VC = [YXHomeXueJiaWenHuaDetailViewController alloc];

//    VC.height = 200;
//    [self.navigationController pushViewController:VC animated:YES];
}
@end
