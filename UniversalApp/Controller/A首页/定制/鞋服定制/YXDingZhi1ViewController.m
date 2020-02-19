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
#import "JXMapNavigationView.h"

@interface YXDingZhi1ViewController ()
@property (nonatomic,strong) NSMutableArray * dataArray;
@end

@implementation YXDingZhi1ViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initControl];
    [self requestGetShopBusiness];
}
//初始化控件
-(void)initControl{
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXDingZhi1TableViewCell" bundle:nil] forCellReuseIdentifier:@"YXDingZhi1TableViewCell"];
    [self addRefreshView:self.yxTableView];
    self.dataArray = [[NSMutableArray alloc]init];
    [self.yxTableView reloadData];
    
    self.addressLbl.text = self.currentCity;
}
-(void)headerRereshing{
    [super headerRereshing];
    [self requestGetShopBusiness];
}
-(void)footerRereshing{
    [super footerRereshing];
    [self requestGetShopBusiness];
}
-(void)requestGetShopBusiness{
    NSString * par = [NSString stringWithFormat:@"page=%ld&obj=%@&sort=%@&lat=%@&lng=%@",(long)self.requestPage,self.obj,self.sort,self.lat,self.lng];
    kWeakSelf(self);
    [YXPLUS_MANAGER getShopBusinessSuccess:par success:^(id object) {
        [weakself.yxTableView.mj_header endRefreshing];
        [weakself.yxTableView.mj_footer endRefreshing];
        weakself.dataArray = [weakself commonAction:object[@"data"] dataArray:weakself.dataArray];
        [weakself.yxTableView reloadData];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXDingZhi1TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXDingZhi1TableViewCell" forIndexPath:indexPath];
    
    NSDictionary * dic = self.dataArray[indexPath.row];
    //图片
    NSString * url = [IMG_URI append:[dic[@"photo_list"] split:@","][0]];
     [cell.cellImv sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    //地址
    cell.cellAdress.text = [[dic[@"city"] append:dic[@"site"]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //距离
    cell.cellFar.text = [NSString stringWithFormat:@"%dkm",[dic[@"distance"] intValue] / 1000] ;
    //名称
    cell.cellTitle.text = dic[@"name"];
    return cell;
}
#pragma -----获取地址-----
- (IBAction)addressAction:(id)sender {
    [self.view endEditing:YES];
       kWeakSelf(self);
       NSArray *dataSource = nil;
       [BRAddressPickerView showAddressPickerWithShowType:BRAddressPickerModeCity dataSource:dataSource defaultSelected:@[] isAutoSelect:YES themeColor:nil resultBlock:^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
           if (province.name && city.name && area.name) {
               weakself.addressLbl.text = city.name;
           }
           NSString * address = [[province.name append:city.name] append:area.name];
           CLGeocoder * myGeocoder = [[CLGeocoder alloc] init];
           [myGeocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
           double latitude = 0;double longitude = 0;
           if ([placemarks count] > 0 && error == nil) {
               CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
                latitude = firstPlacemark.location.coordinate.latitude;
                longitude = firstPlacemark.location.coordinate.longitude;
                if (latitude != 0 && longitude != 0) {
                    //重新获取所选地址的经纬度
                    weakself.lng = [NSString stringWithFormat:@"%f",longitude];
                    weakself.lat = [NSString stringWithFormat:@"%f",latitude];
                    [weakself requestGetShopBusiness];
                }
              }
           }];
           
           
           
       } cancelBlock:^{}];
}
#pragma -----获取排序-----
- (IBAction)sortAction:(id)sender {
    [self.view endEditing:YES];
    kWeakSelf(self);
    NSString * data1 = @"智能排序";
    NSString * data2 = @"距离优先";
    NSString * data3 = @"好评优先";
    NSString * data4 = @"人气优先";

    [BRStringPickerView showStringPickerWithTitle:data1 dataSource:@[data1,data2,data3,data4] defaultSelValue:0 resultBlock:^(NSString * selectValue) {
        weakself.sortLbl.text = selectValue;
    
        if ([selectValue isEqualToString:data1]) {
            weakself.sort = @"1";
        }
        if ([selectValue isEqualToString:data2]) {
            weakself.sort = @"2";
        }
        if ([selectValue isEqualToString:data3]) {
            weakself.sort = @"3";
        }
        if ([selectValue isEqualToString:data4]) {
            weakself.sort = @"4";
        }
        [weakself requestGetShopBusiness];
    }];
}



- (IBAction)searchAction:(id)sender {
}



- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
