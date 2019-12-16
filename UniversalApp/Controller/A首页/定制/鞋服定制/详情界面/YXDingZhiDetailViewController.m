//
//  YXDingZhiDetailViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/13.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXDingZhiDetailViewController.h"
#import "YXDingZhiDetailView.h"
#import "YXDingZhiFooterView.h"
#import "YXAllPingLunViewController.h"

#import "YXDingZhiDetailTableViewCell.h"
#import "YXDingZhiPingLunViewController.h"

@interface YXDingZhiDetailViewController ()

@property (nonatomic,strong) YXDingZhiDetailView * headerView;
@property (nonatomic,strong) YXDingZhiFooterView * footerView;

@end

@implementation YXDingZhiDetailViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initControl];
}
//初始化控件
-(void)initControl{
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXDingZhiDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXDingZhiDetailTableViewCell"];
    [self.yxTableView reloadData];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXDingZhiDetailView" owner:self options:nil];
    self.headerView = [nib objectAtIndex:0];
    [self allBlockAction];
    return self.headerView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXDingZhiFooterView" owner:self options:nil];
    self.footerView = [nib objectAtIndex:0];
    [self allBlockAction];
    return self.footerView;
}
-(void)allBlockAction{
    kWeakSelf(self);
    self.headerView.pingLunBlock = ^{
        YXDingZhiPingLunViewController * vc = [[YXDingZhiPingLunViewController alloc]init];
        [weakself.navigationController pushViewController:vc animated:YES];
    };
    self.footerView.allBtnBlock = ^{
        YXAllPingLunViewController * vc = [[YXAllPingLunViewController alloc]init];
        [weakself.navigationController pushViewController:vc animated:YES];
    };
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 460;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 72;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 250;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXDingZhiDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXDingZhiDetailTableViewCell" forIndexPath:indexPath];
    return cell;
}
- (IBAction)backVcAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
