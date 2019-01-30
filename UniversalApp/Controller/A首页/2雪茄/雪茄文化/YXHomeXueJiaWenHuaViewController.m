//
//  YXHomeXueJiaWenHuaViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/11.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaWenHuaViewController.h"
#import "YXHomeXueJiaWenHuaTableViewCell.h"
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
    kWeakSelf(self);
    [YX_MANAGER requestCigar_cultureGET:@"1" success:^(id object) {
        [weakself.dataArray removeAllObjects];
        [weakself.dataArray addObjectsFromArray:object];
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
    return 200;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXHomeXueJiaWenHuaTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXHomeXueJiaWenHuaTableViewCell" forIndexPath:indexPath];
    [cell.wenhuaImageView sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.row][@"picture"]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    cell.wenhuaLbl.text = self.dataArray[indexPath.row][@"title"];
    cell.timeLbl.text = [ShareManager timestampSwitchTime:[self.dataArray[indexPath.row][@"publish_time"] integerValue] andFormatter:@""];
    return cell;
}

@end
