//
//  YXMineFenSiViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/9.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineFenSiViewController.h"
#import "YXMineCommon1TableViewCell.h"
#import "HGPersonalCenterViewController.h"
#define user_id_BOOL self.userId && ![self.userId isEqualToString:@""]

@interface YXMineFenSiViewController ()<UITableViewDelegate,UITableViewDataSource,ClickBtnDelegate>
@property(nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation YXMineFenSiViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}
-(void)commonAction:(id)object{
    self.dataArray = [self commonAction:object dataArray:self.dataArray];
    [self.yxTableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"粉丝列表";

    self.dataArray = [[NSMutableArray alloc]init];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXMineCommon1TableViewCell" bundle:nil] forCellReuseIdentifier:@"YXMineCommon1TableViewCell"];
    kWeakSelf(self);
    /*
     要分为两种
     1、如果是我自己的界面，请求一种
     2、如果是别人的界面，在请求一种
     */
    if (user_id_BOOL) {
        NSString * par = [NSString stringWithFormat:@"%@/%@/",self.userId,NSIntegerToNSString(self.requestPage)];
        [YX_MANAGER requestOtherFenSi:par success:^(id object) {
            [weakself commonAction:object];
        }];
    }else{
        NSString * par = [NSString stringWithFormat:@"%@/%@/%@/",@"2",@"0",NSIntegerToNSString(self.requestPage)];
        [YX_MANAGER requestLikesGET:par success:^(id object) {
            [weakself commonAction:object];
        }];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXMineCommon1TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXMineCommon1TableViewCell" forIndexPath:indexPath];
    cell.tag = indexPath.row;
    cell.delegate = self;
    NSString * key1 = user_id_BOOL ? @"aim_name" : @"user_name";
    NSString * key2 = user_id_BOOL ? @"aim_id" : @"user_id";
    NSString * key3 = user_id_BOOL ? @"aim_photo" : @"user_photo";

    cell.common1NameLbl.text = self.dataArray[indexPath.row][key1];
    cell.common1GuanzhuBtn.tag = [self.dataArray[indexPath.row][key2] integerValue];
    NSString * imgString = self.dataArray[indexPath.row][key3];
    BOOL is_like = [self.dataArray[indexPath.row][@"is_like"] integerValue] == 1;
    [ShareManager setGuanZhuStatus:cell.common1GuanzhuBtn status:is_like alertView:NO];
    if (is_like) {
        [cell.common1GuanzhuBtn setTitle:@"互相关注" forState:UIControlStateNormal];
    }else{
        [cell.common1GuanzhuBtn setTitle:@"关注" forState:UIControlStateNormal];
    }
//    if (is_like) {
//        [cell.common1GuanzhuBtn setTitle:@"互相关注" forState:UIControlStateNormal];
//        [cell.common1GuanzhuBtn setTitleColor:KWhiteColor forState:0];
//        [cell.common1GuanzhuBtn setBackgroundColor:YXRGBAColor(255, 51, 51)];
//        ViewBorderRadius(cell.common1GuanzhuBtn, 5, 0, KClearColor);
//    }else{
//        [cell.common1GuanzhuBtn setTitle:@"关注" forState:UIControlStateNormal];
//        [cell.common1GuanzhuBtn setTitleColor:[UIColor darkGrayColor] forState:0];
//        [cell.common1GuanzhuBtn setBackgroundColor:KWhiteColor];
//    }
    NSString * str1 = [(NSMutableString *)imgString replaceAll:@" " target:@"%20"];

    [cell.common1ImageView sd_setImageWithURL:[NSURL URLWithString:str1] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    return cell;
}
-(void)clickBtnAction:(NSInteger)common_id tag:(NSInteger)tag{
    if (![userManager loadUserInfo]) {
        KPostNotification(KNotificationLoginStateChange, @NO);
        return;
    }
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:tag inSection:0];
    YXMineCommon1TableViewCell *cell = [self.yxTableView cellForRowAtIndexPath:indexPath];
    kWeakSelf(self);
    NSString * common_id_string = NSIntegerToNSString(common_id);
    [YX_MANAGER requestLikesActionGET:common_id_string success:^(id object) {
        BOOL is_like = [cell.common1GuanzhuBtn.titleLabel.text isEqualToString:@"关注"] == 1;
        [ShareManager setGuanZhuStatus:cell.common1GuanzhuBtn status:!is_like alertView:YES];

        if (is_like) {
             [cell.common1GuanzhuBtn setTitle:@"互相关注" forState:UIControlStateNormal];
        }else{
             [cell.common1GuanzhuBtn setTitle:@"关注" forState:UIControlStateNormal];
        }

    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HGPersonalCenterViewController * mineVC = [[HGPersonalCenterViewController alloc]init];
    mineVC.userId = kGetString(self.dataArray[indexPath.row][@"user_id"]);
    mineVC.whereCome = YES;    //  YES为其他人 NO为自己
    [self.navigationController pushViewController:mineVC animated:YES];
}
@end
