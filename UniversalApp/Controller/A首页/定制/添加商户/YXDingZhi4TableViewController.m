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

@interface YXDingZhi4TableViewController ()<HXPhotoViewDelegate>
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
    self.scrollViewMenTou.contentSize = CGSizeMake(KScreenWidth-32, self.mentouView.cb_Height);
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
       UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth-32, self.mentouView.cb_Height)];
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
                vc.yingyeshijianblock = ^(NSDictionary * dic) {
                    weakself.yingyeshijinDic = [NSDictionary dictionaryWithDictionary:dic];
                    [weakself.yingyeshijianBtn setTitle:dic[@"time"] forState:0];
                    [weakself.yingyeshijianBtn setTitleColor:COLOR_333333 forState:0];
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
    NSString * address = [[self.chengshiBtn.titleLabel.text append:@" "] append:self.dizhiTf.text];
    NSDictionary * dic = @{
        @"":self.photoImageList,
        @"":self.mentouName.text,
        @"":self.fendianName.text,
        @"":self.shanghuTypeList,
        @"":address,
        @"":self.phoneTf.text,
        @"":self.yingyeshijianBtn.titleLabel.text
    };
}
-(BOOL)checkParmater{
    if (self.photoImageList.count == 0) {
        [QMUITips showInfo:@"请上传至少一张,最多三张门头图"];
        return NO;
    }else if (self.mentouName.text.length == 0){
        [QMUITips showInfo:@"请填写商户名"];
        return NO;
    }else if (self.shanghuTypeList.count == 0){
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
        }else if ([self.yingyeshijianBtn.titleLabel.text isEqualToString:@"请选择营业时间"]){
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
    if (btn.tag > 1000) {
        btn.tag = btn.tag - 1000;
        [self selectBtnStatus:btn];
    }else{
        btn.tag = btn.tag + 1000;
        [self unSelectBtnStatus:btn];
    }
    
    [self.shanghuTypeList removeAllObjects];
    UIButton * selectBtn1 = [btn viewWithTag:101];
    if (selectBtn1) {
        [self.shanghuTypeList addObject:@(selectBtn1.tag)];
    }
    UIButton * selectBtn2 = [btn viewWithTag:102];
    if (selectBtn2) {
        [self.shanghuTypeList addObject:@(selectBtn2.tag)];
    }
    UIButton * selectBtn3 = [btn viewWithTag:103];
    if (selectBtn3) {
        [self.shanghuTypeList addObject:@(selectBtn3.tag)];
    }
}
-(void)selectBtnStatus:(UIButton *)btn{
    ViewBorderRadius(btn, 8, 1, KClearColor);
    [btn setTitleColor:COLOR_BBBBBB forState:0];
    [btn setBackgroundColor:COLOR_F5F5F5];
}
-(void)unSelectBtnStatus:(UIButton *)btn{
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
