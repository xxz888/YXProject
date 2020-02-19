//
//  YXDingZhiViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/11.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXDingZhiViewController.h"
#import "YXDingZhiHeadView.h"
#import "YXDingZhiTableViewCell.h"
#import "YXDingZhi1ViewController.h"
#import "YXDingZhi4TableViewController.h"
#import "YXDingZhiDetailViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface YXDingZhiViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>{
    
    CLLocationManager *locationmanager;//定位服务
}
@property (nonatomic,strong) YXDingZhiHeadView * headerView;
@property (nonatomic,strong) NSMutableArray * dataArray;

@property (nonatomic,strong) NSString * obj;
@property (nonatomic,strong) NSString * sort;
@property (nonatomic,strong) NSString * lat;
@property (nonatomic,strong) NSString * lng;
@property (nonatomic,strong) NSString * currentCity;

@end

@implementation YXDingZhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initControl];
    //获取经纬度
    [self getLocation];
    
    
    _obj = @"0";
    _sort= @"1";
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestGetShopBusiness];
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
    NSString * par = [NSString stringWithFormat:@"page=%ld&obj=%@&sort=%@&lat=%@&lng=%@",(long)self.requestPage,_obj,_sort,_lat,_lng];
    kWeakSelf(self);
    [YXPLUS_MANAGER getShopBusinessSuccess:par success:^(id object) {
        [weakself.yxTableView.mj_header endRefreshing];
        [weakself.yxTableView.mj_footer endRefreshing];
        weakself.dataArray = [weakself commonAction:object[@"data"] dataArray:weakself.dataArray];
        [weakself.yxTableView reloadData];
    }];
}

//初始化控件
-(void)initControl{
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXDingZhiTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXDingZhiTableViewCell"];
    self.dataArray = [[NSMutableArray alloc]init];
    [self addRefreshView:self.yxTableView];
    [self.yxTableView reloadData];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXDingZhiHeadView" owner:self options:nil];
    self.headerView = [nib objectAtIndex:0];
    [self blockAction];
    return self.headerView;
}
-(void)blockAction{
    kWeakSelf(self);
    self.headerView.tapview1block = ^(NSString * obj) {
        [weakself pushHeaderDetail:obj];
    };
    self.headerView.tapview2block = ^(NSString * obj) {
        [weakself pushHeaderDetail:obj];
    };
    self.headerView.tapview3block = ^(NSString * obj) {
        [weakself pushHeaderDetail:obj];
    };
    self.headerView.tapview4block = ^{
        UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"YXHome" bundle:nil];
        YXDingZhi4TableViewController * vc = [stroryBoard instantiateViewControllerWithIdentifier:@"YXDingZhi4TableViewController"];
        [weakself.navigationController pushViewController:vc animated:YES];
    };
}
-(void)pushHeaderDetail:(NSString *)obj{
      YXDingZhi1ViewController * vc = [[YXDingZhi1ViewController alloc]init];
      vc.lat = self.lat;
      vc.lng = self.lng;
      vc.sort = @"1";
      vc.obj = obj;
    vc.currentCity = self.currentCity;
      [self.navigationController pushViewController:vc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 268;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 124;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXDingZhiTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXDingZhiTableViewCell" forIndexPath:indexPath];
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
     //评分
    [cell.starView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [ShareManager fiveStarView:[dic[@"grade"] qmui_CGFloatValue] view:cell.starView];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YXDingZhiDetailViewController * vc = [[YXDingZhiDetailViewController alloc]init];
    NSDictionary * dic = self.dataArray[indexPath.row];
    vc.startDic = [NSDictionary dictionaryWithDictionary:dic];
    [self.navigationController pushViewController:vc animated:YES];
}










-(void)getLocation{
    //判断定位功能是否打开
    if ([CLLocationManager locationServicesEnabled]) {
        locationmanager = [[CLLocationManager alloc]init];
        locationmanager.delegate = self;
        [locationmanager requestAlwaysAuthorization];
        self.currentCity = [NSString new];
        [locationmanager requestWhenInUseAuthorization];
        //设置寻址精度
        locationmanager.desiredAccuracy = kCLLocationAccuracyBest;
        locationmanager.distanceFilter = 5.0;
        [locationmanager startUpdatingLocation];
    }
}
#pragma mark 定位成功后则执行此代理方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    [locationmanager stopUpdatingHeading];
    //旧址
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    //打印当前的经度与纬度
    _lng = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
    _lat = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
    [self requestGetShopBusiness];
    //反地理编码
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            self.currentCity = placeMark.locality;
            if (!self.currentCity) {
                self.currentCity = @"无法定位当前城市";
            }
        }
    }];
}
#pragma mark CoreLocation delegate (定位失败)
//定位失败后调用此代理方法
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //设置提示提醒用户打开定位服务
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"定制需要打开手机定位" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
