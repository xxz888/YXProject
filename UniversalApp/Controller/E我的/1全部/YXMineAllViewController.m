//
//  YXMineAllViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/4.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineAllViewController.h"

#define user_id_BOOL self.userId && ![self.userId isEqualToString:@""]

@interface YXMineAllViewController (){
}
@end

@implementation YXMineAllViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat heightKK = 70;
    CGFloat height =  user_id_BOOL ? 64 : 0;

    self.yxTableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 175 -kTopHeight - heightKK + height);
    user_id_BOOL ? [self requestOther_AllList] : [self requestMine_AllList];
}
-(void)headerRereshing{
    [super headerRereshing];
    user_id_BOOL ? [self requestOther_AllList] : [self requestMine_AllList];
}
-(void)footerRereshing{
    [super footerRereshing];
    user_id_BOOL ? [self requestOther_AllList] : [self requestMine_AllList];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
#pragma mark ========== 我自己的所有 ==========
-(void)requestMine_AllList{
    kWeakSelf(self);
    [YX_MANAGER requestGetSersAllList:NSIntegerToNSString(self.requestPage) success:^(id object) {
         weakself.dataArray = [weakself commonAction:object dataArray:weakself.dataArray];
        [weakself.yxTableView reloadData];
    }];
}
#pragma mark ========== 其他用户的所有 ==========
-(void)requestOther_AllList{
    kWeakSelf(self);
    NSString * par = [NSString stringWithFormat:@"%@/%@",self.userId,NSIntegerToNSString(self.requestPage)];
    [YX_MANAGER requestGetSers_Other_AllList:par success:^(id object){
        weakself.dataArray =  [weakself commonAction:object dataArray:weakself.dataArray];
        [weakself.yxTableView reloadData];
    }];
}
#pragma mark ========== 晒图点赞 ==========
-(void)requestDianZan_Image_Action:(NSIndexPath *)indexPath{
    kWeakSelf(self);
    NSString* post_id = kGetString(self.dataArray[indexPath.row][@"id"]);
    [YX_MANAGER requestPost_praisePOST:@{@"post_id":post_id} success:^(id object) {
        user_id_BOOL ? [weakself requestOther_AllList] : [weakself requestMine_AllList];
    }];
}
#pragma mark ========== 足迹点赞 ==========
-(void)requestDianZan_ZuJI_Action:(NSIndexPath *)indexPath{
    kWeakSelf(self);
    NSString* track_id = kGetString(self.dataArray[indexPath.row][@"id"]);
    [YX_MANAGER requestDianZanFoot:@{@"track_id":track_id} success:^(id object) {
        user_id_BOOL ? [weakself requestOther_AllList] : [weakself requestMine_AllList];
    }];
}
@end
