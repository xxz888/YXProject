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
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    kWeakSelf(self);
    [YX_MANAGER requestCigar_accessories_cultureGET:@"1" success:^(id object) {
        [weakself.dataArray removeAllObjects];
        [weakself.dataArray addObjectsFromArray:object];
        
        if (weakself.dataArray.count == 0) {
            [weakself.dataArray addObjectsFromArray:YX_MANAGER.informationArray];
        }
        [weakself.yxTableView reloadData];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXHomeXueJiaWenHuaTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXHomeXueJiaWenHuaTableViewCell" forIndexPath:indexPath];
    [cell.wenhuaImageView sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.row][@"photo"]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    cell.wenhuaLbl.text = self.dataArray[indexPath.row][@"title"];
    return cell;
}

@end
