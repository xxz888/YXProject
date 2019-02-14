//
//  YXMineFootViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/4.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineFootViewController.h"
#import "YXFindFootTableViewCell.h"
#import "YXMineFootDetailViewController.h"
#define user_id_BOOL self.userId && ![self.userId isEqualToString:@""]

@interface YXMineFootViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger page ;
}
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)NSString * type;
@end

@implementation YXMineFootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableviewCon];
    
    [self addRefreshView:self.yxTableView];
    user_id_BOOL ? [self requestZuJi_Other] : [self requestZuJi];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)headerRereshing{
    [super headerRereshing];
    user_id_BOOL ? [self requestZuJi_Other] : [self requestZuJi];
}
-(void)footerRereshing{
    [super footerRereshing];
    user_id_BOOL ? [self requestZuJi_Other] : [self requestZuJi];
}
-(void)requestZuJi{
    kWeakSelf(self);
    NSString * par = [NSString stringWithFormat:@"%@/%@/%@",NSIntegerToNSString(self.requestPage),@"1",@"1"];
    [YX_MANAGER requestGetMy_Track_list:par success:^(id object) {
        weakself.dataArray = [weakself commonAction:object dataArray:weakself.dataArray];
        [weakself.yxTableView reloadData];
    }];
}
-(void)requestZuJi_Other{
    kWeakSelf(self);
    NSString * par = [NSString stringWithFormat:@"%@/%@",self.userId,NSIntegerToNSString(self.requestPage)];
    [YX_MANAGER requestGetOther_Track_list:par success:^(id object) {
        weakself.dataArray = [weakself commonAction:object dataArray:weakself.dataArray];
        [weakself.yxTableView reloadData];
    }];
}
#pragma mark ========== 创建tableview ==========
-(void)tableviewCon{
    self.dataArray = [[NSMutableArray alloc]init];
    CGFloat heightKK = 90;

    self.yxTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 175 -kTopHeight - heightKK) style:0];
    [self.view addSubview:self.yxTableView];
    self.yxTableView.delegate = self;
    self.yxTableView.dataSource= self;
    self.yxTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.yxTableView.showsVerticalScrollIndicator = NO;
    page = 1;
    _type = @"1";
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXFindImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXFindImageTableViewCell"];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXFindQuestionTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXFindQuestionTableViewCell"];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXFindFootTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXFindFootTableViewCell"];
}

#pragma mark ========== tableview代理方法 ==========
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 600;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.row];
    return [self cunstomFootData:dic indexPath:indexPath];
}
#pragma mark ========== 足迹 ==========
-(YXFindFootTableViewCell *)cunstomFootData:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath{
    YXFindFootTableViewCell * cell = [self.yxTableView dequeueReusableCellWithIdentifier:@"YXFindFootTableViewCell" forIndexPath:indexPath];
    cell.topView.hidden = YES;
    cell.topViewConstraint.constant = 0;
    cell.titleImageView.tag = indexPath.row;
    [cell setCellValue:dic];
    kWeakSelf(self);
    cell.jumpDetailVC = ^(YXFindFootTableViewCell * cell) {
        NSIndexPath * indexPath1 = [weakself.yxTableView indexPathForCell:cell];
        [weakself commonDidVC:indexPath1];
    };
    cell.zanblock = ^(YXFindFootTableViewCell * cell) {
        NSIndexPath * indexPath1 = [weakself.yxTableView indexPathForCell:cell];
        [weakself requestDianZan_ZuJI_Action:indexPath1];
    };
    return cell;
}
#pragma mark ========== 足迹点赞 ==========
-(void)requestDianZan_ZuJI_Action:(NSIndexPath *)indexPath{
    kWeakSelf(self);
    NSString* track_id = kGetString(self.dataArray[indexPath.row][@"id"]);
    [YX_MANAGER requestDianZanFoot:@{@"track_id":track_id} success:^(id object) {
        user_id_BOOL ? [self requestZuJi_Other] : [self requestZuJi];
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self commonDidVC:indexPath];
}
-(void)commonDidVC:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.row];
    YXMineFootDetailViewController * VC = [[YXMineFootDetailViewController alloc]init];
    VC.startDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    YX_MANAGER.isHaveIcon = NO;
    [self.navigationController pushViewController:VC animated:YES];
}
@end
