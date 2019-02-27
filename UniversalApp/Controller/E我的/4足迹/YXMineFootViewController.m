//
//  YXMineFootViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/4.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineFootViewController.h"
#import "YXMineFootDetailViewController.h"
#define user_id_BOOL self.userId && ![self.userId isEqualToString:@""]

@interface YXMineFootViewController (){
    NSInteger page ;
}
@property(nonatomic,strong)NSString * type;
@end

@implementation YXMineFootViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat heightKK = AxcAE_IsiPhoneX ? 88 : 60;
    CGFloat height =  user_id_BOOL ? 64 : 0;
    
    self.yxTableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 175 -kTopHeight - heightKK + height);
    [self requestAction];
}
-(void)requestAction{
    user_id_BOOL ? [self requestZuJi_Other] : [self requestZuJi];
}
-(void)headerRereshing{
    [super headerRereshing];
    [self requestAction];
}
-(void)footerRereshing{
    [super footerRereshing];
    [self requestAction];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)requestZuJi{
    kWeakSelf(self);
    NSString * par = [NSString stringWithFormat:@"%@/%@/%@",NSIntegerToNSString(self.requestPage),@"1",@"1"];
    [YX_MANAGER requestGetMy_Track_list:par success:^(id object) {
        [weakself sameAction:object];
    }];
}
-(void)requestZuJi_Other{
    kWeakSelf(self);
    NSString * par = [NSString stringWithFormat:@"%@/%@",self.userId,NSIntegerToNSString(self.requestPage)];
    [YX_MANAGER requestGetOther_Track_list:par success:^(id object) {
        [weakself sameAction:object];
    }];
}
-(void)sameAction:(id)object{
    if ([object count] > 0) {
        NSMutableArray *_dataSourceTemp=[NSMutableArray new];
        for (NSDictionary *company in object) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:company];
            [dic setObject:@"4" forKey:@"obj"];
            [_dataSourceTemp addObject:dic];
        }
        object=_dataSourceTemp;
    }
    self.dataArray = [self commonAction:object dataArray:self.dataArray];
    [self.yxTableView reloadData];
}
@end
