//
//  YXDingZhi4TableViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/12.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXDingZhi4TableViewController.h"
#import "YXYingYeTimeViewController.h"
#import "HXPhotoPicker.h"
#import "QiniuLoad.h"
#import "BRAddressPickerView.h"

@interface YXDingZhi4TableViewController ()<HXPhotoViewDelegate>{
    NSString * _business_days;
    NSString * _business_hours;
    NSString * _round_the_clock;
    NSString * _type;

}
@property (strong, nonatomic) HXPhotoManager *manager;
@property (weak, nonatomic) HXPhotoView *photoView;
@property (strong, nonatomic) HXDatePhotoToolManager *toolManager;
@property (strong, nonatomic) UIScrollView *scrollViewMenTou;
@property (strong, nonatomic) NSMutableArray *photoImageList;
@property (strong, nonatomic) NSMutableArray *shanghuTypeList;
@property (strong, nonatomic) NSDictionary * yingyeshijinDic;

@end

@implementation YXDingZhi4TableViewController
-(HXPhotoManager *)manager{
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.showDeleteNetworkPhotoAlert = NO;
        _manager.configuration.saveSystemAblum = NO;
        _manager.configuration.photoMaxNum = 3;
        _manager.configuration.imageMaxSize = 5;
    }
    return _manager;
}
- (HXDatePhotoToolManager *)toolManager {
    if (!_toolManager) {
        _toolManager = [[HXDatePhotoToolManager alloc] init];
    }
    return _toolManager;
}
- (void)photoView:(HXPhotoView *)photoView deleteNetworkPhoto:(NSString *)networkPhotoUrl {
    NSSLog(@"%@",networkPhotoUrl);
}
- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame{
    NSSLog(@"%@",NSStringFromCGRect(frame));
    self.scrollViewMenTou.contentSize = CGSizeMake(KScreenWidth-32, self.mentouView.qmui_height);
}
- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    //如果是图片
    if (photos.count > 0) {
        kWeakSelf(self);
       [QMUITips showLoadingInView:self.view];
       [self.toolManager getSelectedImageList:photos success:^(NSArray<UIImage *> *imageList) {
             //上传七牛云图片
             [QiniuLoad uploadImageToQNFilePath:imageList success:^(NSString *reslut) {
                  [QMUITips hideAllTips];
                  [weakself.photoImageList removeAllObjects];
                  NSMutableArray * qiniuArray = [NSMutableArray arrayWithArray:[reslut split:@";"]];
                  if (qiniuArray.count > 0) {
                    [weakself.photoImageList addObjectsFromArray:qiniuArray];
                  }
              } failure:^(NSString *error) {[QMUITips hideAllTips];}];
        } failed:^{[QMUITips hideAllTips];}];
   }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setOtherUI];
}
-(void)setOtherUI{
       UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth-32, self.mentouView.qmui_height)];
       [self.mentouView addSubview:scrollView];
       self.scrollViewMenTou.userInteractionEnabled = NO;
       self.scrollViewMenTou = scrollView;
       
       CGFloat width = 276;
       HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
       photoView.frame = CGRectMake(0, 0, width, 0);
       photoView.lineCount = 3;
       photoView.delegate = self;
       photoView.spacing = 3;
       photoView.backgroundColor = [UIColor whiteColor];
       [scrollView addSubview:photoView];
       self.photoView = photoView;
      _photoImageList = [[NSMutableArray alloc]init];
      _shanghuTypeList = [[NSMutableArray alloc]init];
    
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [super numberOfSectionsInTableView:tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [super tableView:tableView numberOfRowsInSection:section];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 44 + kStatusBarHeight;
    }else if (indexPath.section == 2){
        return 50 + (IS_IPhoneX ? 34 : 0);
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 7:{
                kWeakSelf(self);
               
                YXYingYeTimeViewController * vc = [[YXYingYeTimeViewController alloc]init];
                if (_business_days.length != 0) {
                    vc.business_days = _business_days;
                }
                if (_business_hours.length != 0) {
                    vc.business_hours = _business_hours;
                }
                if (_round_the_clock.length != 0) {
                    vc.round_the_clock = _round_the_clock;
                }
                vc.yingyeshijianblock = ^(NSDictionary * dic) {
                    weakself.yingyeshijinDic = [NSDictionary dictionaryWithDictionary:dic];
                    [weakself.yingyeshijianBtn setTitle:dic[@"business_hours"] forState:0];
                    [weakself.yingyeshijianBtn setTitleColor:COLOR_333333 forState:0];
                    
                    _business_days = dic[@"business_days"];
                    _business_hours = dic[@"business_hours"];
                    _round_the_clock = dic[@"round_the_clock"];
                };
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
    
}
- (IBAction)finishAction:(id)sender {
    if (![self checkParmater]) {
        return;
    }
    kWeakSelf(self);
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    NSString * address = [self.chengshiBtn.titleLabel.text append:self.dizhiTf.text];
    address = [address stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error){
      if ([placemarks count] > 0) {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        CLLocationCoordinate2D coordinate = placemark.location.coordinate;
        //图片key的数组
          NSMutableArray * imageKeyArray = [[NSMutableArray alloc]init];
          for (NSString * key in weakself.photoImageList) {
              [imageKeyArray addObject:[key split:IMG_URI][1]];
          }
          NSString * imageKey = [imageKeyArray componentsJoinedByString:@","];

          NSDictionary * dic = @{
              @"photo_list":imageKey,
              @"name":weakself.mentouName.text,
              @"second_name":weakself.fendianName.text,
              @"type":_type,
              @"city":weakself.chengshiBtn.titleLabel.text,
              @"site":weakself.dizhiTf.text,
              @"phone":weakself.phoneTf.text,
              @"business_days":_business_days,
              @"business_hours":_business_hours,
              @"round_the_clock":_round_the_clock,
              @"longitude":[NSString stringWithFormat:@"%f",coordinate.longitude],
              @"latitude": [NSString stringWithFormat:@"%f",coordinate.latitude],
              @"obj":@"1",
          };
          [weakself requestAddShopBusiness:dic];
      }
    }];

  
}
-(void)requestAddShopBusiness:(NSDictionary *)dic{
    kWeakSelf(self);
    [YXPLUS_MANAGER addShopBusinessSuccess:dic success:^(id object) {
        [QMUITips showSucceed:@"添加成功"];
        [weakself.navigationController popViewControllerAnimated:YES];
    }];
}
-(BOOL)checkParmater{
    if (self.photoImageList.count == 0) {
        [QMUITips showInfo:@"请上传至少一张,最多三张门头图"];
        return NO;
    }else if (self.mentouName.text.length == 0){
        [QMUITips showInfo:@"请填写商户名"];
        return NO;
    }else if (_type.length == 0){
        [QMUITips showInfo:@"请选择商户类型"];
        return NO;
    }else if ([self.chengshiBtn.titleLabel.text isEqualToString:@"请选择城市"]){
        [QMUITips showInfo:@"请选择城市"];;
        return NO;
    }else if (self.dizhiTf.text.length == 0){
        [QMUITips showInfo:@"请填写地址"];
        return NO;
    }else if (self.phoneTf.text.length == 0){
        [QMUITips showInfo:@"请填写联系方式"];
        return NO;
    }else if ([self.yingyeshijianBtn.titleLabel.text isEqualToString:@"请选择营业时间"]
              || _business_days.length == 0 || _business_hours.length == 0 || _round_the_clock.length == 0){
        [QMUITips showInfo:@"请选择营业时间"];
        return NO;
    }
    return YES;
}




- (IBAction)backVcAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)shanghuTypeAction:(UIButton *)btn {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
   //1010,1020,大于1000代表未选择，小于1000代表选择
    //101,102
    _type = [NSString stringWithFormat:@"%ld",btn.tag - 100];
    UIButton * selectBtn1 = [self.tableView viewWithTag:101];
    UIButton * selectBtn2 = [self.tableView viewWithTag:102];
    UIButton * selectBtn3 = [self.tableView viewWithTag:103];

    if (btn.tag == 101) {
        [self selectBtnStatus:selectBtn1];
        [self unSelectBtnStatus:selectBtn2];
        [self unSelectBtnStatus:selectBtn3];
    }
    if (btn.tag == 102) {
        [self unSelectBtnStatus:selectBtn1];
        [self selectBtnStatus:selectBtn2];
        [self unSelectBtnStatus:selectBtn3];
    }
    if (btn.tag == 103) {
        [self unSelectBtnStatus:selectBtn1];
        [self unSelectBtnStatus:selectBtn2];
        [self selectBtnStatus:selectBtn3];
    }
}
-(void)unSelectBtnStatus:(UIButton *)btn{
    ViewBorderRadius(btn, 8, 1, KClearColor);
    [btn setTitleColor:COLOR_BBBBBB forState:0];
    [btn setBackgroundColor:COLOR_F5F5F5];
}
-(void)selectBtnStatus:(UIButton *)btn{
    ViewBorderRadius(btn, 8, 1, KClearColor);
    [btn setTitleColor:KWhiteColor forState:0];
    [btn setBackgroundColor:SEGMENT_COLOR];
}
- (IBAction)chengshiAction:(id)sender {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    kWeakSelf(self);
    // NSArray *dataSource = [weakSelf getAddressDataSource];  //从外部传入地区数据源
    NSArray *dataSource = nil; // dataSource 为空时，就默认使用框架内部提供的数据源（即 BRCity.plist）
    [BRAddressPickerView showAddressPickerWithShowType:BRAddressPickerModeCity dataSource:dataSource defaultSelected:@[] isAutoSelect:YES themeColor:nil resultBlock:^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
        if (province.name && city.name && area.name) {
            NSString * address = [NSString stringWithFormat:@"%@ %@ %@", province.name, city.name, area.name];
            [weakself.chengshiBtn setTitle:address forState:UIControlStateNormal];
            [weakself.chengshiBtn setTitleColor:COLOR_333333 forState:0];
        }
     
    } cancelBlock:^{
    }];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}


@end
