//
//  YXHomeXueJiaToolsViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/11.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaToolsViewController.h"
#import <Masonry/Masonry.h>
#import <ZXSegmentController/ZXSegmentController.h>
#import "YXHomeChiCunViewController.h"
#import "YXXingZhuangViewController.h"
#import "YXColorViewController.h"
#import "HGSegmentedPageViewController.h"
#import "YXHomeXueJiaToolsTableViewCell.h"
#import "YXZhiNanViewController.h"

@interface YXHomeXueJiaToolsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray * titleArray;

@property (strong, nonatomic) UITableView *yxTableView;
@property (nonatomic,strong) UIView * view1;

@end

@implementation YXHomeXueJiaToolsViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestZhiNan1Get];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"文化";
    [self tableviewCon];
    [self addRefreshView:self.yxTableView];
}
-(void)headerRereshing{
    [super headerRereshing];
    [self requestZhiNan1Get];
}
-(void)footerRereshing{
    [super footerRereshing];
    [self.yxTableView.mj_footer endRefreshing];
}
-(void)requestZhiNan1Get{
    
    kWeakSelf(self);
    NSString * par = [NSString stringWithFormat:@"1/%@",@"5"];
    [YXPLUS_MANAGER requestZhiNan1Get:par success:^(id object) {
        weakself.titleArray = [weakself commonAction:object dataArray:weakself.titleArray];
        [weakself.yxTableView reloadData];
    }];
}
#pragma mark ========== 创建tableview ==========
-(void)tableviewCon{
    [self.navigationController.navigationBar setHidden:YES];
    
    self.titleArray = [[NSMutableArray alloc]init];
    self.yxTableView = [[UITableView alloc]init];
    self.yxTableView.frame = CGRectMake(0,0, KScreenWidth,self.view.frame.size.height-kTopHeight-kTabBarHeight+10);
    self.yxTableView.delegate = self;
    self.yxTableView.dataSource= self;
    self.yxTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXHomeXueJiaToolsTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXHomeXueJiaToolsTableViewCell"];
    [self.view addSubview:self.yxTableView];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (KScreenWidth-30)/1.6;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXHomeXueJiaToolsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXHomeXueJiaToolsTableViewCell" forIndexPath:indexPath];
    
    NSDictionary * dic = self.titleArray[indexPath.row];
    NSString * str1 = [(NSMutableString *)dic[@"photo"] replaceAll:@" " target:@"%20"];
    [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:str1] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    
    cell.selectionStyle = 0;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YXZhiNanViewController * vc1 = [[YXZhiNanViewController alloc]init];
    vc1.startDic = [NSDictionary dictionaryWithDictionary:self.titleArray[indexPath.row]];
    vc1.index = indexPath.row;
    vc1.title = self.titleArray[indexPath.row][@"name"];
    [self.navigationController pushViewController:vc1 animated:YES];
}
@end
