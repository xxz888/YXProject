//
//  YXDingZhiViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/11.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXDingZhiViewController.h"
#import "YXDingZhiHeadView.h"
#import "YXDingZhiTableViewCell.h"
#import "YXDingZhi1ViewController.h"
#import "YXDingZhi4TableViewController.h"

@interface YXDingZhiViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) YXDingZhiHeadView * headerView;

@end

@implementation YXDingZhiViewController

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
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXDingZhiHeadView" owner:self options:nil];
    self.headerView = [nib objectAtIndex:0];
    [self blockAction];
    return self.headerView;
}
-(void)blockAction{
    kWeakSelf(self);
    self.headerView.tapview1block = ^{
        [weakself.navigationController pushViewController:[[YXDingZhi1ViewController alloc]init] animated:YES];
    };
    self.headerView.tapview2block = ^{
           
    };
    self.headerView.tapview3block = ^{
           
    };
    self.headerView.tapview4block = ^{
        UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"YXHome" bundle:nil];
        YXDingZhi4TableViewController * vc = [stroryBoard instantiateViewControllerWithIdentifier:@"YXDingZhi4TableViewController"];
        [weakself.navigationController pushViewController:vc animated:YES];
    };
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 268;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 124;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXDingZhiTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXDingZhiTableViewCell" forIndexPath:indexPath];
    return cell;
}
@end
