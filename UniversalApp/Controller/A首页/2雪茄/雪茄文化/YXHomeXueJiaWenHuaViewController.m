//
//  YXHomeXueJiaWenHuaViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/11.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaWenHuaViewController.h"
#import "YXHomeXueJiaWenHuaTableViewCell.h"
#import "YXHomeNewsDetailViewController.h"
@interface YXHomeXueJiaWenHuaViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation YXHomeXueJiaWenHuaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [[NSMutableArray alloc]init];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXHomeXueJiaWenHuaTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXHomeXueJiaWenHuaTableViewCell"];
    self.yxTableView.delegate=  self;
    self.yxTableView.dataSource = self;
    self.title = @"雪茄文化";
    [self addRefreshView:self.yxTableView];
    [self requestCrgar];

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
    [YX_MANAGER requestCigar_cultureGET:NSIntegerToNSString(self.requestPage) success:^(id object) {
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
    return 260;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXHomeXueJiaWenHuaTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXHomeXueJiaWenHuaTableViewCell" forIndexPath:indexPath];
    [cell.wenhuaImageView sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.row][@"picture"]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    cell.wenhuaLbl.text = self.dataArray[indexPath.row][@"title"];
    cell.timeLbl.text = [ShareManager timestampSwitchTime:[self.dataArray[indexPath.row][@"publish_time"] integerValue] andFormatter:@""];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YXHomeNewsDetailViewController * VC = [YXHomeNewsDetailViewController alloc];
    NSDictionary * dic = self.dataArray[indexPath.row];
    VC.webDic =[NSMutableDictionary dictionaryWithDictionary:dic];
    [VC.webDic setValue:dic[@"picture"] forKey:@"photo"];
    [VC.webDic setValue:dic[@"publish_time"] forKey:@"date"];
    [VC.webDic setValue:dic[@"essay"] forKey:@"details"];
    [VC.webDic setValue:@"" forKey:@"author"];

    [self.navigationController pushViewController:VC animated:YES];
}
@end
