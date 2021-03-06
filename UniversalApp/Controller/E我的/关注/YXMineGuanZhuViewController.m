//
//  YXMineGuanZhuViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/9.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineGuanZhuViewController.h"
#import "YXMineCommon1TableViewCell.h"
#import "HGPersonalCenterViewController.h"
#define user_id_BOOL self.userId && ![self.userId isEqualToString:@""]

@interface YXMineGuanZhuViewController ()<UITableViewDelegate,UITableViewDataSource,ClickBtnDelegate>
@property(nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation YXMineGuanZhuViewController

-(void)commonAction:(id)object{
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:object];
    [self.yxTableView reloadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [[NSMutableArray alloc]init];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXMineCommon1TableViewCell" bundle:nil] forCellReuseIdentifier:@"YXMineCommon1TableViewCell"];
    /*
     要分为两种
     1、如果是我自己的界面，请求一种
     2、如果是别人的界面，在请求一种
     */
    kWeakSelf(self);
    
    if (user_id_BOOL) {
        NSString * par = [NSString stringWithFormat:@"%@/%@/",self.userId,NSIntegerToNSString(self.requestPage)];
        [YX_MANAGER requestOtherGuanZhu:par success:^(id object) {
            [weakself commonAction:object];
        }];
    }else{
        NSString * par = [NSString stringWithFormat:@"%@/%@/%@/",@"1",@"0",NSIntegerToNSString(self.requestPage)];
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
    cell.common1NameLbl.text = self.dataArray[indexPath.row][@"aim_name"];
    cell.common1GuanzhuBtn.tag = [self.dataArray[indexPath.row][@"aim_id"] integerValue];
    NSString * imgString = self.dataArray[indexPath.row][@"aim_photo"];

    [cell.common1ImageView sd_setImageWithURL:[NSURL URLWithString:[WP_TOOL_ShareManager addImgURL:imgString]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    [ShareManager setGuanZhuStatus:cell.common1GuanzhuBtn status:NO alertView:NO];
    
    
    NSDictionary * userInfo = userManager.loadUserAllInfo;
    if ([userInfo[@"username"] isEqualToString:self.dataArray[indexPath.row][@"aim_name"]]) {
        cell.common1GuanzhuBtn.hidden = YES;
    }else{
        cell.common1GuanzhuBtn.hidden = NO;
    }
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
        BOOL is_like = [cell.common1GuanzhuBtn.titleLabel.text isEqualToString:@"+关注"] == 1;
        [ShareManager setGuanZhuStatus:cell.common1GuanzhuBtn status:!is_like alertView:YES];
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    NSDictionary * userInfo = userManager.loadUserAllInfo;
    NSString * key1 = self.dataArray[indexPath.row][@"aim_name"] ? @"aim_name" : @"user_name";
    if ([userInfo[@"username"] isEqualToString:self.dataArray[indexPath.row][key1]]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        self.navigationController.tabBarController.selectedIndex = 3;
        return;
    }else{
        HGPersonalCenterViewController * mineVC = [[HGPersonalCenterViewController alloc]init];
        mineVC.userId = kGetString(self.dataArray[indexPath.row][@"aim_id"]);
        mineVC.whereCome = YES;    //  YES为其他人 NO为自己
        [self.navigationController pushViewController:mineVC animated:YES];
    }
   
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
