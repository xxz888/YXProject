//
//  YXDingZhiDetailViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/13.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXDingZhiDetailViewController.h"
#import "YXDingZhiDetailView.h"
#import "YXDingZhiTableViewCell.h"
@interface YXDingZhiDetailViewController ()

@property (nonatomic,strong) YXDingZhiDetailView * headerView;

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
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXDingZhiTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXDingZhiTableViewCell"];
    [self.yxTableView reloadData];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXDingZhiDetailView" owner:self options:nil];
    self.headerView = [nib objectAtIndex:0];
    return self.headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 460;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 210;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXDingZhiTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXDingZhiTableViewCell" forIndexPath:indexPath];
    return cell;
}
- (IBAction)backVcAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
