//
//  YXMineFenSiViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/9.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineFenSiViewController.h"
#import "YXMineCommon1TableViewCell.h"
@interface YXMineFenSiViewController ()<UITableViewDelegate,UITableViewDataSource,ClickBtnDelegate>
@property(nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation YXMineFenSiViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    kWeakSelf(self);
    [YX_MANAGER requestLikesGET:@"2" success:^(id object) {
        [weakself.dataArray removeAllObjects];
        [weakself.dataArray addObjectsFromArray:object];
        [weakself.yxTableView reloadData];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"粉丝列表";
    self.dataArray = [[NSMutableArray alloc]init];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXMineCommon1TableViewCell" bundle:nil] forCellReuseIdentifier:@"YXMineCommon1TableViewCell"];
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
    cell.common1NameLbl.text = self.dataArray[indexPath.row][@"user_name"];
    cell.common1GuanzhuBtn.tag = [self.dataArray[indexPath.row][@"user_id"] integerValue];
    NSString * imgString = self.dataArray[indexPath.row][@"user_photo"];
    BOOL is_like = [self.dataArray[indexPath.row][@"is_like"] integerValue] == 1;
    if (is_like) {
        [cell.common1GuanzhuBtn setTitle:@"互相关注" forState:UIControlStateNormal];
    }else{
        [cell.common1GuanzhuBtn setTitle:@"关注" forState:UIControlStateNormal];
    }
    [cell.common1ImageView sd_setImageWithURL:[NSURL URLWithString:imgString] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    return cell;
}
-(void)clickBtnAction:(NSInteger)common_id tag:(NSInteger)tag{
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:tag inSection:0];
    YXMineCommon1TableViewCell *cell = [self.yxTableView cellForRowAtIndexPath:indexPath];
    kWeakSelf(self);
    NSString * common_id_string = NSIntegerToNSString(common_id);
    [YX_MANAGER requestLikesActionGET:common_id_string success:^(id object) {
        BOOL is_like = [cell.common1GuanzhuBtn.titleLabel.text isEqualToString:@"关注"] == 1;
        [QMUITips showSucceed:is_like ?@"互相关注成功" : @"已取消关注" inView:weakself.view hideAfterDelay:2];

        if (is_like) {
            [cell.common1GuanzhuBtn setTitle:@"互相关注" forState:UIControlStateNormal];
        }else{
            [cell.common1GuanzhuBtn setTitle:@"关注" forState:UIControlStateNormal];
        }
    }];
}
@end
