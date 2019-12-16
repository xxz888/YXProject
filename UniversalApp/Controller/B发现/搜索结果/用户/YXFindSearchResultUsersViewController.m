//
//  YXFindSearchResultUsersViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/2/12.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXFindSearchResultUsersViewController.h"
#import "HGPersonalCenterViewController.h"
#import "YXMineCommon1TableViewCell.h"
#import "HGPersonalCenterViewController.h"
@interface YXFindSearchResultUsersViewController ()<UITableViewDelegate,UITableViewDataSource,ClickBtnDelegate>
@property(nonatomic,strong)UITableView * yxTableView;
@property (nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation YXFindSearchResultUsersViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self requestFindAll_user:self.key];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [[NSMutableArray alloc]init];

    [self createyxTableView];
}
-(void)headerRereshing{
    [super headerRereshing];
    [self requestFindAll_user:self.key];
}
-(void)footerRereshing{
    [super footerRereshing];
    [self requestFindAll_user:self.key];
}
-(void)requestAction{
    [self requestFindAll_user:self.key];
}
-(void)createyxTableView{
    if (!self.yxTableView) {
        self.yxTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-kTopHeight-40) style:UITableViewStylePlain];
        self.yxTableView.separatorStyle =  UITableViewCellSeparatorStyleSingleLine;
        [self.view addSubview:self.yxTableView];
    }
    self.yxTableView.backgroundColor = KWhiteColor;
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXMineCommon1TableViewCell" bundle:nil] forCellReuseIdentifier:@"YXMineCommon1TableViewCell"];
    self.yxTableView.delegate= self;
    self.yxTableView.dataSource = self;
    self.yxTableView.separatorStyle = 0;
    self.dataArray = [[NSMutableArray alloc]init];

}

-(void)requestFindAll_user:(NSString *)key{
    if (!key) {
        return;
    }
    kWeakSelf(self);
    [YX_MANAGER requestFind_user:@{@"name":key,@"page":NSIntegerToNSString(self.requestPage)} success:^(id object) {
        [weakself.dataArray removeAllObjects];
        [weakself.dataArray addObjectsFromArray:object];
        [weakself.yxTableView reloadData];
    }];
}
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.dataArray.count;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 60;
//}
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *identify = @"YXFindSearchTableViewCell";
//    YXMineCommon1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
//    cell.cellImageView.layer.masksToBounds = YES;
//    cell.cellImageView.layer.cornerRadius = cell.cellImageView.frame.size.width / 2.0;
//    NSString * str = [(NSMutableString *)self.dataArray[indexPath.row][@"photo"] replaceAll:@" " target:@"%20"];
//    [cell.cellImageView sd_setImageWithURL:[NSURL URLWithString:[IMG_URI append:str]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
//    cell.cellLbl.text = self.dataArray[indexPath.row][@"username"];
//    cell.cellAutherLbl.text = self.dataArray[indexPath.row][@"site"];
//
//    return cell;
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSString * userId = kGetString(self.dataArray[indexPath.row][@"id"]);
//    NSDictionary * userInfo = userManager.loadUserAllInfo;
//     if ([kGetString(userInfo[@"id"]) isEqualToString:userId]) {
//         self.navigationController.tabBarController.selectedIndex = 3;
//         return;
//     }
//      HGPersonalCenterViewController * mineVC = [[HGPersonalCenterViewController alloc]init];
//      mineVC.userId = userId;
//      mineVC.whereCome = YES;    //  YES为其他人 NO为自己
//      [self.navigationController pushViewController:mineVC animated:YES];
//}
-(void)commonAction:(id)object{
    self.dataArray = [self commonAction:object dataArray:self.dataArray];
    [self.yxTableView reloadData];
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
    NSDictionary * dic = self.dataArray[indexPath.row];
    cell.common1NameLbl.text = dic[@"username"];
    cell.common1GuanzhuBtn.tag = [dic[@"id"] integerValue];
    NSString * imgString = dic[@"photo"];
    BOOL is_like = [dic[@"is_like"] integerValue] == 1;
    [ShareManager setGuanZhuStatus:cell.common1GuanzhuBtn status:!is_like alertView:NO];
    if (is_like) {
        [cell.common1GuanzhuBtn setTitle:@"互相关注" forState:UIControlStateNormal];
    }else{
        [cell.common1GuanzhuBtn setTitle:@"+关注" forState:UIControlStateNormal];
    }
    NSDictionary * userInfo = userManager.loadUserAllInfo;
    NSString * str1 = [(NSMutableString *)imgString replaceAll:@" " target:@"%20"];
    [cell.common1ImageView sd_setImageWithURL:[NSURL URLWithString:[IMG_URI append:str1]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
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

        if (is_like) {
             [cell.common1GuanzhuBtn setTitle:@"互相关注" forState:UIControlStateNormal];
        }else{
             [cell.common1GuanzhuBtn setTitle:@"+关注" forState:UIControlStateNormal];
        }

    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![userManager loadUserInfo]) {
         KPostNotification(KNotificationLoginStateChange, @NO);
         return;
     }
    NSDictionary * userInfo = userManager.loadUserAllInfo;
    NSString * key1 = self.dataArray[indexPath.row][@"username"];
    if ([userInfo[@"username"] isEqualToString:key1]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        self.navigationController.tabBarController.selectedIndex = 3;
        return;
    }else{
        HGPersonalCenterViewController * mineVC = [[HGPersonalCenterViewController alloc]init];
        NSDictionary * dic = self.dataArray[indexPath.row];
        
        mineVC.userId = kGetString(dic[@"id"]);
        mineVC.whereCome = YES;    //  YES为其他人 NO为自己
        [self.navigationController pushViewController:mineVC animated:YES];
    }

}

@end
