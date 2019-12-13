//
//  YXDingZhi1ViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/12.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXDingZhi1ViewController.h"
#import "BRAddressPickerView.h"
#import "BRStringPickerView.h"
#import "YXDingZhi1TableViewCell.h"

@interface YXDingZhi1ViewController ()

@end

@implementation YXDingZhi1ViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initControl];
}
//初始化控件
-(void)initControl{
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXDingZhi1TableViewCell" bundle:nil] forCellReuseIdentifier:@"YXDingZhi1TableViewCell"];
    [self.yxTableView reloadData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXDingZhi1TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXDingZhi1TableViewCell" forIndexPath:indexPath];
    return cell;
}
- (IBAction)addressAction:(id)sender {
    [self.view endEditing:YES];
       kWeakSelf(self);
       NSArray *dataSource = nil;
       [BRAddressPickerView showAddressPickerWithShowType:BRAddressPickerModeCity dataSource:dataSource defaultSelected:@[] isAutoSelect:YES themeColor:nil resultBlock:^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
           if (province.name && city.name && area.name) {
               weakself.addressLbl.text = city.name;
           }
       } cancelBlock:^{
       }];
}
- (IBAction)sortAction:(id)sender {
    [self.view endEditing:YES];
    kWeakSelf(self);
    [BRStringPickerView showStringPickerWithTitle:@"智能排序" dataSource:@[@"按距离排",@"按时间排"] defaultSelValue:0 resultBlock:^(id selectValue) {
        weakself.sortLbl.text = selectValue;
    }];
}



- (IBAction)searchAction:(id)sender {
}



- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
