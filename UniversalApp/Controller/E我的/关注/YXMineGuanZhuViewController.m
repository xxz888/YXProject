//
//  YXMineGuanZhuViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/9.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineGuanZhuViewController.h"
#import "YXMineCommon1TableViewCell.h"
#define user_id_BOOL self.userId && ![self.userId isEqualToString:@""]

@interface YXMineGuanZhuViewController ()<UITableViewDelegate,UITableViewDataSource,ClickBtnDelegate>
@property(nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation YXMineGuanZhuViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    

}
-(void)commonAction:(id)object{
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:object];
    [self.yxTableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关注列表";
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
    return 50;
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
    NSString * str1 = [(NSMutableString *)imgString replaceAll:@" " target:@"%20"];

    [cell.common1ImageView sd_setImageWithURL:[NSURL URLWithString:str1] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    [ShareManager setGuanZhuStatus:cell.common1GuanzhuBtn status:NO];
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
        [QMUITips showSucceed:is_like ?@"关注成功": @"已取消关注" inView:weakself.view hideAfterDelay:2];
        [ShareManager setGuanZhuStatus:cell.common1GuanzhuBtn status:!is_like];
    }];
}
@end
