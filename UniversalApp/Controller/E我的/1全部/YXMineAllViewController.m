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

    CGFloat height = user_id_BOOL  ? KScreenHeight  - kNavBarHeight - 27 : KScreenHeight  - kTabBarHeight - kNavBarHeight - 27;
    self.yxTableView.frame = CGRectMake(0, 0, KScreenWidth, height);
    
}
-(void)requestTableData{
    user_id_BOOL ? [self requestOther_AllList] : [self requestMine_AllList];
}
-(void)headerRereshing{
    [super headerRereshing];
    [self requestTableData];
}
-(void)footerRereshing{
    [super footerRereshing];
    [self requestTableData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestTableData];
}
#pragma mark ========== 我自己的所有 ==========
-(void)requestMine_AllList{
//    kWeakSelf(self);
//    [YX_MANAGER requestGetSersAllList:NSIntegerToNSString(self.requestPage) success:^(id object) {
//         weakself.dataArray = [weakself commonAction:object dataArray:weakself.dataArray];
//        [weakself.yxTableView reloadData];
//    }];
    
    kWeakSelf(self);
    NSString * parString =[NSString stringWithFormat:@"0&page=%@",NSIntegerToNSString(self.requestPage)];
    [YX_MANAGER requestGet_users_find:parString success:^(id object){
        weakself.dataArray = [weakself commonAction:object dataArray:weakself.dataArray];
        [weakself.yxTableView reloadData];
        weakself.nodataImg.hidden = weakself.dataArray.count != 0;
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
        [weakself requestTableData];
    }];
}
#pragma mark ========== 足迹点赞 ==========
-(void)requestDianZan_ZuJI_Action:(NSIndexPath *)indexPath{
    kWeakSelf(self);
    NSString* track_id = kGetString(self.dataArray[indexPath.row][@"id"]);
    [YX_MANAGER requestDianZanFoot:@{@"track_id":track_id} success:^(id object) {
        [weakself requestTableData];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}
@end
