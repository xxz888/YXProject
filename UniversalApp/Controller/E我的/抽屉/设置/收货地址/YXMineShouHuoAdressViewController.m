//
//  YXMineShouHuoAdressViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/9/16.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXMineShouHuoAdressViewController.h"
#import "YXMineShouHuoTableViewCell.h"
#import "YXMineAddAdressViewController.h"

@interface YXMineShouHuoAdressViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *yxTableView;
@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation YXMineShouHuoAdressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [[NSMutableArray alloc]init];
    self.yxTableView.tableFooterView = [[UIView alloc]init];
    self.yxTableView.separatorStyle = 0;
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXMineShouHuoTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXMineShouHuoTableViewCell"];
    self.yxTableView.backgroundColor = kRGBA(245, 245, 245, 1);
    self.view.backgroundColor = kRGBA(245, 245, 245, 1);
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getAddressList];

}
-(void)getAddressList{
    kWeakSelf(self);
    [YXPLUS_MANAGER requestAddressListGet:@"" success:^(id object) {
        [weakself.dataArray removeAllObjects];
        [weakself.dataArray addObjectsFromArray:object[@"address_list"]];
        [weakself.yxTableView reloadData];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 146;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXMineShouHuoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXMineShouHuoTableViewCell" forIndexPath:indexPath];
    NSDictionary * dic = self.dataArray[indexPath.row];
    cell.dic = [NSDictionary dictionaryWithDictionary:dic];
    cell.editBtn.tag = indexPath.row;
    cell.morenBtn.tag = indexPath.row;

    cell.nameLbl.text = dic[@"name"];
    cell.phoneLbl.text = dic[@"phone"];
    cell.adressLbl.text = dic[@"site"];
    cell.morenBtn.selected = [dic[@"default"] integerValue] == 1;
    
    kWeakSelf(self);
    cell.morenbtnblock = ^(NSInteger index) {
        //先改变点击的那个地址
        NSDictionary * currentDic = [NSDictionary dictionaryWithDictionary:weakself.dataArray[index]];
   
       
        NSDictionary * dic = @{
                               @"type":@"3",
                               @"name":currentDic[@"name"],
                               @"phone":currentDic[@"phone"],
                               @"site":currentDic[@"site"],
                               @"default":@"1",
                               @"address_id":currentDic[@"id"]
                               };
        [YXPLUS_MANAGER requestAddressAddPOST:dic success:^(id object) {
//            //再找出哪个是默认的
//            NSMutableDictionary * defalutCurrentDic;
//            for (NSInteger i = 0; i < weakself.dataArray.count; i++) {
//                NSDictionary * bianliDic = weakself.dataArray[i];
//                if ([bianliDic[@"default"] integerValue] == 1) {
//                    defalutCurrentDic = [NSMutableDictionary dictionaryWithDictionary:bianliDic];
//                }
//            }
//            //然后改变为不默认
//            [defalutCurrentDic setValue:@"0" forKey:@"default"];
//            [defalutCurrentDic setValue:defalutCurrentDic[@"id"] forKey:@"address_id"];
//
//            [YXPLUS_MANAGER requestAddressAddPOST:dic success:^(id object) {
                [QMUITips showSucceed:object[@"message"] inView:[ShareManager getMainView] hideAfterDelay:1];
                [weakself getAddressList];
//            }];
        }];
    };
    
    cell.btnblock = ^(NSInteger index) {
        YXMineAddAdressViewController * vc = [[YXMineAddAdressViewController alloc]init];
        vc.addressDic = [NSDictionary dictionaryWithDictionary:weakself.dataArray[index]];
        [weakself.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.backVCHaveParblock(self.dataArray[indexPath.row]);
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)backVc:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)addAdressAction:(id)sender {
    YXMineAddAdressViewController * vc = [[YXMineAddAdressViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
