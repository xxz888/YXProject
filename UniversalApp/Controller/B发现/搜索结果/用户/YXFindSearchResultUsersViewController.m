//
//  YXFindSearchResultUsersViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/2/12.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXFindSearchResultUsersViewController.h"
#import "YXHomeXueJiaTableViewCell.h"
#import "YXFindSearchResultTagViewController.h"

@interface YXFindSearchResultUsersViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * yxTableView;
@end

@implementation YXFindSearchResultUsersViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createyxTableView];
}
-(void)createyxTableView{
    if (!self.yxTableView) {
        self.yxTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-kTopHeight-40) style:UITableViewStylePlain];
        [self.view addSubview:self.yxTableView];
    }
    self.yxTableView.backgroundColor = KWhiteColor;
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXHomeXueJiaTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXHomeXueJiaTableViewCell"];
    self.yxTableView.delegate= self;
    self.yxTableView.dataSource = self;
    self.yxTableView.separatorStyle = 0;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"YXHomeXueJiaTableViewCell";
     YXHomeXueJiaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
    cell.cellImageView.layer.masksToBounds = YES;
    cell.cellImageView.layer.cornerRadius = cell.cellImageView.frame.size.width / 2.0;
//    NSString * str = [(NSMutableString *)self.informationArray[indexPath.row][@"photo"] replaceAll:@" " target:@"%20"];
    [cell.cellImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    cell.cellLbl.text = @"xxz";
    cell.cellAutherLbl.text = @"浙江 杭州";
    cell.cellDataLbl.text =  @"";
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YXFindSearchResultTagViewController * VC = [[YXFindSearchResultTagViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}


@end
