//
//  YXMineAllViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/4.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineAllViewController.h"
#import "YXMineEssayTableViewCell.h"
#import "YXMineAllImageTableViewCell.h"
#import "YXMineImageDetailViewController.h"
#import "YXMineEssayDetailViewController.h"
#define user_id_BOOL self.userId && ![self.userId isEqualToString:@""]

@interface YXMineAllViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>{
    NSInteger page ;
}
@property(nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation YXMineAllViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    user_id_BOOL ? [self requestOther_AllList] : [self requestMine_AllList];
}
#pragma mark ========== 我自己的所有 ==========
-(void)requestMine_AllList{
    id obj = UserDefaultsGET(@"a1");
    kWeakSelf(self);
    [YX_MANAGER requestGetSersAllList:@"1" success:^(id object) {
        UserDefaultsSET(object, @"a1");
        [weakself commonAction:object];
    }];
}
#pragma mark ========== 其他用户的所有 ==========
-(void)requestOther_AllList{
    kWeakSelf(self);
    [YX_MANAGER requestGetSers_Other_AllList:[self.userId append:@"/1"] success:^(id object) {
        [weakself commonAction:object];
    }];
}
-(void)commonAction:(id)obj{
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:obj];
//    [self.yxTableView reloadData];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    [self tableviewCon];
}
-(void)tableviewCon{
    self.yxTableView.delegate = self;
    self.yxTableView.dataSource= self;
    self.yxTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.yxTableView.showsVerticalScrollIndicator = NO;
    self.dataArray = [[NSMutableArray alloc]init];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXMineEssayTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXMineEssayTableViewCell"];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXMineAllImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXMineAllImageTableViewCell"];
}

#pragma mark ========== 界面刷新 ==========
-(void)mineRefreshAction:(id)object{
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:object];
    [self.yxTableView reloadData];
}
#pragma mark ========== 晒图点赞 ==========
-(void)requestDianZanAction:(NSIndexPath *)indexPath{
    kWeakSelf(self);
    NSString* post_id = kGetString(self.dataArray[indexPath.row][@"id"]);
    [YX_MANAGER requestPost_praisePOST:@{@"post_id":post_id} success:^(id object) {
        user_id_BOOL ? [weakself requestOther_AllList] : [weakself requestMine_AllList];
    }];
}
#pragma mark ========== 文章点赞 ==========
-(void)requestDianZanWenZhangAction:(NSIndexPath *)indexPath{
    kWeakSelf(self);
    NSString* essay_id = kGetString(self.dataArray[indexPath.row][@"id"]);
    [YX_MANAGER requestPost_essay_praisePOST:@{@"essay_id":essay_id} success:^(id object) {
        user_id_BOOL ? [weakself requestOther_AllList] : [weakself requestMine_AllList];
    }];
}

#pragma mark ========== tableview代理方法 ==========
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.row];
    NSInteger tag = [dic[@"obj"] integerValue];
    return  tag == 1 ? 350 : 290;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.row];
    NSInteger tag = [dic[@"obj"] integerValue];
    if (tag == 1) {
        return [self customImageData:dic indexPath:indexPath];
    }else if (tag == 2){
        return [self customEssayData:dic indexPath:indexPath];
    }else{
        return  nil;
    }
}

#pragma mark ========== 图片 ==========
-(YXMineAllImageTableViewCell *)customImageData:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath{
    YXMineAllImageTableViewCell *cell = [self.yxTableView dequeueReusableCellWithIdentifier:@"YXMineAllImageTableViewCell" forIndexPath:indexPath];
    [cell.midImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"photo1"]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    cell.titleLbl.text = dic[@"describe"];
    BOOL isp =  [dic[@"is_praise"] integerValue] == 1;
    UIImage * likeImage = isp ? ZAN_IMG : UNZAN_IMG;
    [cell.likeBtn setBackgroundImage:likeImage forState:UIControlStateNormal];
    kWeakSelf(self);
    cell.block = ^(YXMineAllImageTableViewCell * cell) {
        NSIndexPath * indexPath = [weakself.yxTableView indexPathForCell:cell];
        [weakself requestDianZanAction:indexPath];
    };
    return cell;
}
#pragma mark ========== 文章 ==========
-(YXMineEssayTableViewCell *)customEssayData:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath{
    YXMineEssayTableViewCell * cell = [self.yxTableView dequeueReusableCellWithIdentifier:@"YXMineEssayTableViewCell" forIndexPath:indexPath];
    kWeakSelf(self);
    cell.block = ^(YXMineEssayTableViewCell * cell) {
        NSIndexPath * indexPath = [weakself.yxTableView indexPathForCell:cell];
        [weakself requestDianZanWenZhangAction:indexPath];
    };
    [cell.essayTitleImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"photo"]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    cell.essayNameLbl.text = dic[@"user_name"];
    cell.essayTimeLbl.text = [ShareManager timestampSwitchTime:[dic[@"publish_time"] integerValue] andFormatter:@""];
    cell.mineImageLbl.text = dic[@"title"];
    cell.mineTimeLbl.text = dic[@"title"];
    BOOL isp =  [dic[@"is_praise"] integerValue] == 1;
    UIImage * likeImage = isp ? ZAN_IMG : UNZAN_IMG;
    
    [cell.likeBtn setBackgroundImage:likeImage forState:UIControlStateNormal];
    NSURL * url1 = [NSURL URLWithString:self.dataArray[indexPath.row][@"picture1"]];
    NSURL * url2 = [NSURL URLWithString:self.dataArray[indexPath.row][@"picture2"]];
    [cell.midImageView sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"img_moren"]];
    [cell.midTwoImageVIew sd_setImageWithURL:url2 placeholderImage:[UIImage imageNamed:@"img_moren"]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.row];
    NSInteger tag = [dic[@"obj"] integerValue];
    YX_MANAGER.isHaveIcon = NO;
    if (tag == 1) {//晒图
        YXMineImageDetailViewController * VC = [[YXMineImageDetailViewController alloc]init];
        VC.startDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [self.navigationController pushViewController:VC animated:YES];
    }else{
        YX_MANAGER.isHaveIcon = NO;
        YXMineEssayDetailViewController * VC = [[YXMineEssayDetailViewController alloc]init];
        VC.startDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [self.navigationController pushViewController:VC animated:YES];
    }
}
#pragma mark ========== 文章tableview ==========
-(void)customWenZhangCell:(YXMineEssayTableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.row];
    
    
    
    kWeakSelf(self);
    cell.block = ^(YXMineEssayTableViewCell * cell) {
        NSIndexPath * indexPath = [weakself.yxTableView indexPathForCell:cell];
        [weakself requestDianZanAction:indexPath];
    };
    [cell.essayTitleImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"photo"]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    cell.essayNameLbl.text = dic[@"user_name"];
    cell.essayTimeLbl.text = [ShareManager timestampSwitchTime:[dic[@"publish_time"] integerValue] andFormatter:@""];
    cell.mineImageLbl.text = dic[@"title"];
    cell.mineTimeLbl.text = dic[@"title"];
    BOOL isp =  [dic[@"is_praise"] integerValue] == 1;
    UIImage * likeImage = isp ? ZAN_IMG : UNZAN_IMG;
    
    [cell.likeBtn setBackgroundImage:likeImage forState:UIControlStateNormal];
    NSURL * url1 = [NSURL URLWithString:self.dataArray[indexPath.row][@"picture1"]];
    NSURL * url2 = [NSURL URLWithString:self.dataArray[indexPath.row][@"picture2"]];
    [cell.midImageView sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"img_moren"]];
    [cell.midTwoImageVIew sd_setImageWithURL:url2 placeholderImage:[UIImage imageNamed:@"img_moren"]];
    
}
@end
