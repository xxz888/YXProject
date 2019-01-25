//
//  YXMineImageViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/4.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineImageViewController.h"
#import "YXMineImageTableViewCell.h"
#import "YXMineImageDetailViewController.h"

@interface YXMineImageViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger page ;
}
@property(nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation YXMineImageViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self requestList];
}
-(void)requestList{
    kWeakSelf(self);

    NSString * pageString = NSIntegerToNSString(page) ;
    [YX_MANAGER requestGetDetailListPOST:@{@"type":@(2),@"tag":@"0",@"page":@(1)} success:^(id object) {
        [[NSUserDefaults standardUserDefaults] setValue:object forKey:@"b1"];
        [weakself.dataArray removeAllObjects];
        [weakself.dataArray addObjectsFromArray:object];
        [weakself.yxTableView reloadData];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    
    self.dataArray = [[NSMutableArray alloc]init];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXMineImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXMineImageTableViewCell"];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 360;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXMineImageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXMineImageTableViewCell" forIndexPath:indexPath];
    NSURL * url = [NSURL URLWithString:self.dataArray[indexPath.row][@"photo1"]];
    [cell.mineImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"img_moren"]];
    cell.mineImageLbl.text = self.dataArray[indexPath.row][@"describe"];
    NSString * time = self.dataArray[indexPath.row][@"publish_time"];
    cell.mineTimeLbl.text = [ShareManager timestampSwitchTime:[time integerValue] andFormatter:@"YYYY-MM-dd HH:mm:ss"];
    BOOL isp =  [self.dataArray[indexPath.row][@"is_praise"] integerValue] == 1;
    UIImage * likeImage = isp ? ZAN_IMG : UNZAN_IMG;
    [cell.likeBtn setBackgroundImage:likeImage forState:UIControlStateNormal];
    
    kWeakSelf(self);
    cell.block = ^(YXMineImageTableViewCell * cell) {
        [weakself requestDianZanAction:cell];
    };
    return cell;
}
-(void)requestDianZanAction:(YXMineImageTableViewCell *)cell{
    NSIndexPath * indexPath = [self.yxTableView indexPathForCell:cell];
    kWeakSelf(self);
    NSString* post_id = kGetString(self.dataArray[indexPath.row][@"id"]);
    [YX_MANAGER requestPost_praisePOST:@{@"post_id":post_id} success:^(id object) {
        [weakself requestList];
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YXMineImageDetailViewController * VC = [[YXMineImageDetailViewController alloc]init];
    VC.startDic = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[indexPath.row]];
    YX_MANAGER.isHaveIcon = NO;
    [self.navigationController pushViewController:VC animated:YES];
}


@end
