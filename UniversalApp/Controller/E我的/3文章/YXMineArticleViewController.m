//
//  YXMineArticleViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/4.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineArticleViewController.h"
#import "YXMineEssayTableViewCell.h"
#import "YXMineEssayDetailViewController.h"
#define user_id_BOOL self.userId && ![self.userId isEqualToString:@""]

@interface YXMineArticleViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>{
    NSInteger page ;
}
@property(nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation YXMineArticleViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self tableviewCon];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    user_id_BOOL ?[self requestOtherWenZhangList]: [self requestMineWenZhangList] ;
}
-(void)tableviewCon{
    self.yxTableView.delegate = self;
    self.yxTableView.dataSource= self;
    self.yxTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.yxTableView.showsVerticalScrollIndicator = NO;
    self.dataArray = [[NSMutableArray alloc]init];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXMineEssayTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXMineEssayTableViewCell"];
}

#pragma mark ========== 我的界面文章请求 ==========
-(void)requestMineWenZhangList{
    kWeakSelf(self);
    NSString * pageString = @"1";
    [YX_MANAGER requestEssayListGET:pageString success:^(id object) {
        [weakself mineWenZhangRefreshAction:object];
    }];
}

#pragma mark ========== 其他用户的文章请求 ==========
-(void)requestOtherWenZhangList{
    kWeakSelf(self);
    [YX_MANAGER requestOtherEssay:[self.userId append:@"/1"] success:^(id object) {
        [weakself mineWenZhangRefreshAction:object];
    }];
}
#pragma mark ========== 我的文章界面刷新 ==========
-(void)mineWenZhangRefreshAction:(id)object{
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:object];
    [self.yxTableView reloadData];
}
#pragma mark ========== 晒图点赞 ==========
-(void)requestDianZanAction:(NSIndexPath *)indexPath{
    kWeakSelf(self);
    NSString* post_id = kGetString(self.dataArray[indexPath.row][@"id"]);
    [YX_MANAGER requestPost_praisePOST:@{@"post_id":post_id} success:^(id object) {
        user_id_BOOL ?[weakself requestOtherWenZhangList]: [weakself requestMineWenZhangList] ;
    }];
}

#pragma mark ========== tableview代理方法 ==========
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 290;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXMineEssayTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXMineEssayTableViewCell" forIndexPath:indexPath];
    cell.essayTitleImageView.tag = indexPath.row;
    [self customWenZhangCell:cell indexPath:indexPath];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.row];
    YX_MANAGER.isHaveIcon = NO;
    YXMineEssayDetailViewController * VC = [[YXMineEssayDetailViewController alloc]init];
    VC.startDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [self.navigationController pushViewController:VC animated:YES];
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
