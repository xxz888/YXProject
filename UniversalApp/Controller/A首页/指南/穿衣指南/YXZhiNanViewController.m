//
//  YXZhiNanViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/17.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXZhiNanViewController.h"
#import "YXZhiNanTableViewCell.h"
#import "YXZhiNanDetailViewController.h"

@interface YXZhiNanViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray * dataArray;


@end

@implementation YXZhiNanViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [self requestZhiNanGet];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    [self addRefreshView:self.yxTableView];
}
-(void)headerRereshing{
    [super headerRereshing];
    [self requestZhiNanGet];
}
-(void)footerRereshing{
    [super footerRereshing];
    [self.yxTableView.mj_footer endRefreshing];
}
-(void)requestZhiNanGet{
    kWeakSelf(self);
    NSString * par = [NSString stringWithFormat:@"1/%@",self.startDic[@"id"]];
    [YXPLUS_MANAGER requestZhiNan1Get:par success:^(id object) {
        
        weakself.dataArray = [weakself commonAction:object dataArray:weakself.dataArray];
        [weakself.yxTableView reloadData];

    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 190;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXZhiNanTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXZhiNanTableViewCell" forIndexPath:indexPath];
    if (indexPath.row == 1) {
        cell.yxCollectionView.backgroundColor = KWhiteColor;
    }
    cell.selectionStyle = 0;
    NSDictionary * dic = self.dataArray[indexPath.row];
    [cell setCellData:dic];
    
    
    kWeakSelf(self);
    //block
    cell.clickCollectionItemBlock = ^(NSDictionary * dic) {
        YXZhiNanDetailViewController * vc = [[YXZhiNanDetailViewController alloc]init];
        vc.startDic = [NSDictionary dictionaryWithDictionary:dic];
        [weakself.navigationController pushViewController:vc animated:YES];
    };
    
    
    
    return cell;
}
-(void)initTableView{
    [self.navigationController.navigationBar setHidden:NO];
    self.dataArray = [[NSMutableArray alloc]init];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXZhiNanTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXZhiNanTableViewCell"];
    
}
@end
