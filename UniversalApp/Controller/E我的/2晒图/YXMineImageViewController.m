//
//  YXMineImageViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/4.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineImageViewController.h"
#import "YXMineEssayTableViewCell.h"
#import "YXMineImageDetailViewController.h"

@interface YXMineImageViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger page ;
}
@property(nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation YXMineImageViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

//    [self requestList];
}
-(void)requestMineShaiTuList{
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
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXMineEssayTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXMineEssayTableViewCell"];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 350;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXMineEssayTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXMineEssayTableViewCell" forIndexPath:indexPath];
    NSDictionary * dic = self.dataArray[indexPath.row];

    NSURL * url = [NSURL URLWithString:dic[@"photo1"]];
    
    [cell.essayTitleImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"photo"]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    cell.essayNameLbl.text = dic[@"user_name"];
    cell.essayTimeLbl.text = [ShareManager timestampSwitchTime:[dic[@"publish_time"] integerValue] andFormatter:@""];

    //自定义
    UIImageView * mineImageView = [[UIImageView alloc]init];
    mineImageView.frame = CGRectMake(0, 0, KScreenWidth-10, cell.midView.frame.size.height);
    [cell.midView addSubview:mineImageView];
    [mineImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"img_moren"]];
    ViewRadius(mineImageView, 3);

    
    cell.mineImageLbl.text = dic[@"describe"];
    NSString * time = dic[@"publish_time"];
    cell.mineTimeLbl.text = [ShareManager timestampSwitchTime:[time integerValue] andFormatter:@"YYYY-MM-dd HH:mm:ss"];
    BOOL isp =  [dic[@"is_praise"] integerValue] == 1;
    UIImage * likeImage = isp ? ZAN_IMG : UNZAN_IMG;
    [cell.likeBtn setBackgroundImage:likeImage forState:UIControlStateNormal];
    
    kWeakSelf(self);
    cell.block = ^(YXMineEssayTableViewCell * cell) {
        [weakself requestDianZanAction:cell];
    };
    cell.clickImageBlock = ^(NSInteger index) {
        
    };
    return cell;
}
-(void)requestDianZanAction:(YXMineEssayTableViewCell *)cell{
    NSIndexPath * indexPath = [self.yxTableView indexPathForCell:cell];
    kWeakSelf(self);
    NSString* post_id = kGetString(self.dataArray[indexPath.row][@"id"]);
    [YX_MANAGER requestPost_praisePOST:@{@"post_id":post_id} success:^(id object) {
//        [weakself requestList];
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YXMineImageDetailViewController * VC = [[YXMineImageDetailViewController alloc]init];
    VC.startDic = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[indexPath.row]];
    YX_MANAGER.isHaveIcon = NO;
    [self.navigationController pushViewController:VC animated:YES];
}


@end
