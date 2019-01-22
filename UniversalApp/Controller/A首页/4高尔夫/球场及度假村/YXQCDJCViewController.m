//
//  YXQCDJCViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/17.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXQCDJCViewController.h"
#import "YXQCDJCTableViewCell.h"
#import "XHStarRateView.h"
#import "SDCycleScrollView.h"
#import "UIView+SDAutoLayout.h"
#import "YXQCDJCHeaderView.h"
#define demoURL @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=2797616721,1483253964&fm=26&gp=0.jpg"
#import "YXQCDJCDetailTableViewController.h"

@interface YXQCDJCViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *yxTableView;
@property(nonatomic,strong)YXQCDJCHeaderView * headerView;
@property(nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation YXQCDJCViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSDictionary * dic =@{@"city":@"杭州",
                          @"longitude":@(120.20000),
                          @"latitude":@(30.26667),
                          @"page":@"1"
                          };
    [YX_MANAGER requestGolf_coursePOST:dic success:^(id object) {
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"球场";
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXQCDJCTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXQCDJCTableViewCell"];
}
//代理方法
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXQCDJCHeaderView" owner:self options:nil];
    self.headerView = [nib objectAtIndex:0];
    return self.headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 260;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXQCDJCTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXQCDJCTableViewCell" forIndexPath:indexPath];
    [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:demoURL] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    XHStarRateView * starView = [ShareManager fiveStarView:3 view:cell.startView];
    [cell.startView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [cell.startView addSubview:starView];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard * stroryBoard1 = [UIStoryboard storyboardWithName:@"YXHomeGolf" bundle:nil];
    YXQCDJCDetailTableViewController * VC = [stroryBoard1 instantiateViewControllerWithIdentifier:@"YXQCDJCDetailTableViewController"];
    [self.navigationController pushViewController:VC animated:YES];
}
@end
