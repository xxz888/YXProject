//
//  YXWanShanXinXiViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/10.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXWanShanXinXiViewController.h"
#import "HXPhotoPicker.h"

#import "QiniuLoad.h"
#import "BRAddressPickerView.h"
#import "NSDate+BRPickerView.h"
#import "BRDatePickerView.h"

#define loginnan_unsel  IMAGE_NAMED(@"loginnan_unsel")
#define loginnan_sel    IMAGE_NAMED(@"loginnan_sel")
#define loginnv_sel     IMAGE_NAMED(@"loginnv_sel")
#define loginnv_unsel   IMAGE_NAMED(@"loginnv_unsel")
@interface YXWanShanXinXiViewController ()<HXPhotoViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong) NSString * photo;
@property (nonatomic) BOOL bool1;
@property (nonatomic) BOOL bool2;
@property (nonatomic) BOOL bool3;
@property (nonatomic) BOOL bool4;
@property (nonatomic) BOOL bool5;
@property (nonatomic) BOOL bool6;
@property (strong, nonatomic) HXDatePhotoToolManager *toolManager;
@property (strong, nonatomic) HXPhotoManager *manager;
@end

@implementation YXWanShanXinXiViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
        _manager.configuration.singleSelected = YES;
        _manager.configuration.albumListTableView = ^(UITableView *tableView) {
//            NSSLog(@"%@",tableView);
        };
        _manager.configuration.singleJumpEdit = YES;
        _manager.configuration.movableCropBox = YES;
        _manager.configuration.movableCropBoxEditSize = YES;
//        _manager.configuration.movableCropBoxCustomRatio = CGPointMake(1, 1);
    }
    return _manager;
}

- (HXDatePhotoToolManager *)toolManager {
    if (!_toolManager) {
        _toolManager = [[HXDatePhotoToolManager alloc] init];
    }
    return _toolManager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initControl];
}
//初始化控件
-(void)initControl{
    
    //上传图片的底层view
    UITapGestureRecognizer * aTapGR1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(upLoadViewAction:)];
    aTapGR1.numberOfTapsRequired = 1;
    self.upLoadView.userInteractionEnabled = YES;
    [self.upLoadView addGestureRecognizer:aTapGR1];
    //女
    UITapGestureRecognizer * aTapGR2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nvAction:)];
    aTapGR2.numberOfTapsRequired = 1;
    self.nvImageView.userInteractionEnabled = YES;
    self.nvImageView.tag = 1001;
    [self.nvImageView addGestureRecognizer:aTapGR2];
    //男
    UITapGestureRecognizer * aTapGR3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nanAction:)];
    aTapGR3.numberOfTapsRequired = 1;
    self.nanImageView.userInteractionEnabled = YES;
    self.nanImageView.tag = 2001;
    [self.nanImageView addGestureRecognizer:aTapGR3];
    
    
    [self.birthdayBtn setTitleColor:COLOR_BBBBBB forState:UIControlStateNormal];
    [self.addressBtn setTitleColor:COLOR_BBBBBB forState:UIControlStateNormal];
    
    self.upLoadView.hidden = NO;
    self.titleImageView.hidden = YES;

    [self.nameTf addTarget:self action:@selector(nameTfChange:) forControlEvents:UIControlEventEditingChanged];
    [self.qianmingTf addTarget:self action:@selector(qianMingTfChange:) forControlEvents:UIControlEventEditingChanged];

}

//上传图片
-(void)upLoadViewAction:(id)tag{
    self.manager.configuration.saveSystemAblum = NO;
     kWeakSelf(self);
     [self hx_presentAlbumListViewControllerWithManager:self.manager done:^(NSArray<HXPhotoModel *> *allList, NSArray<HXPhotoModel *> *photoList, NSArray<HXPhotoModel *> *videoList, BOOL original, HXAlbumListViewController *viewController) {
         if (photoList.count > 0) {
             [weakself.view showLoadingHUDText:@"获取图片中"];
             [weakself.toolManager getSelectedImageList:photoList requestType:0 success:^(NSArray<UIImage *> *imageList) {
                [weakself uploadImageQiNiuYun:imageList];
             } failed:^{
                 [weakself.view handleLoading];
                 [weakself.view showImageHUDText:@"获取失败"];
             }];
             NSSLog(@"%ld张图片",photoList.count);
         }
     } cancel:^(HXAlbumListViewController *viewController) {
         NSSLog(@"取消了");
     }];
}
//姓名
-(void)nameTfChange:(UITextField *)tf{
    if (tf.text.length > 0) {
          self.bool2 = YES;
          [self changeMakeSureBtnStatus];
      }
}
//男
-(void)nanAction:(id)tag{
    //2001代表男未选择，2002代表男选择
    if (self.nanImageView.tag == 2001) {
        self.nanImageView.image = loginnan_sel;
        self.nvImageView.image  = loginnv_unsel;
        self.nanImageView.tag = 2002;
        self.nvImageView.tag  = 1001;
        self.bool3 = YES;
        [self changeMakeSureBtnStatus];
    }
}
//女
-(void)nvAction:(id)tag{
    //1001代表女未选择，1002代表女选择
    if (self.nvImageView.tag == 1001) {
        self.nvImageView.image  = loginnv_sel;
        self.nanImageView.image = loginnan_unsel;
        self.nvImageView.tag = 1002;
        self.nanImageView.tag = 2001;
        self.bool3 = YES;
        [self changeMakeSureBtnStatus];
    }
}
-(void)uploadImageQiNiuYun:(NSArray *)upLoadImageArray{
    kWeakSelf(self);
    [QMUITips showLoadingInView:self.view];
    [QiniuLoad uploadImageToQNFilePath:upLoadImageArray success:^(NSString *reslut) {
        NSMutableArray * qiniuArray = [NSMutableArray arrayWithArray:[reslut split:@";"]];
        weakself.titleImageView.image = upLoadImageArray[0];
        weakself.photo = qiniuArray[0];
        weakself.upLoadView.hidden = YES;
        weakself.titleImageView.hidden = NO;
        [QMUITips hideAllTipsInView:weakself.view];
        weakself.bool1 = YES;
        [weakself changeMakeSureBtnStatus];
    } failure:^(NSString *error) {}];
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)birthdayAction:(id)sender {
    [self.view endEditing:YES];
    kWeakSelf(self);
    NSDate *minDate = [NSDate br_setYear:1990 month:3 day:12];
    NSDate *maxDate = [NSDate date];
    [BRDatePickerView showDatePickerWithTitle:@"出生日期" dateType:BRDatePickerModeYMD defaultSelValue:@"" minDate:minDate maxDate:maxDate isAutoSelect:YES themeColor:nil resultBlock:^(NSString *selectValue) {
        [weakself.birthdayBtn setTitle:selectValue forState:UIControlStateNormal];
        [weakself.birthdayBtn setTitleColor:KBlackColor forState:UIControlStateNormal];
        weakself.bool4 = YES;
        [weakself changeMakeSureBtnStatus];
    } cancelBlock:^{}];
}
- (IBAction)addressAction:(id)sender {
    [self.view endEditing:YES];
    kWeakSelf(self);
    NSArray *dataSource = nil;
    [BRAddressPickerView showAddressPickerWithShowType:BRAddressPickerModeCity dataSource:dataSource defaultSelected:@[] isAutoSelect:YES themeColor:nil resultBlock:^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
        if (province.name && city.name && area.name) {
            NSString * address = [NSString stringWithFormat:@"%@ %@ %@", province.name, city.name, area.name];
            [weakself.addressBtn setTitle:address forState:UIControlStateNormal];
            [weakself.addressBtn setTitleColor:KBlackColor forState:UIControlStateNormal];
            weakself.bool5 = YES;
            [weakself changeMakeSureBtnStatus];
        }
    } cancelBlock:^{
    }];
}
//签名
-(void)qianMingTfChange:(UITextField *)tf{
    if (tf.text.length > 0) {
        self.bool6 = YES;
        [self changeMakeSureBtnStatus];
    }
}
-(void)changeMakeSureBtnStatus{
    if (self.bool1 && self.bool2 && self.bool3 && self.bool4 && self.bool5 && self.bool6) {
        [self.maskSureBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
        self.maskSureBtn.userInteractionEnabled = YES;
        [self.maskSureBtn setBackgroundColor:SEGMENT_COLOR];
    }else{
        [self.maskSureBtn setTitleColor:kRGBA(153, 153, 153, 1) forState:UIControlStateNormal];
        self.maskSureBtn.userInteractionEnabled = NO;
        [self.maskSureBtn setBackgroundColor:kRGBA(245, 245, 245, 1)];
    }
}
- (IBAction)makeSureAction:(id)sender {
        kWeakSelf(self);
        [QMUITips showLoadingInView:self.view];
        NSString * site = self.addressBtn.titleLabel.text ? self.addressBtn.titleLabel.text : @"";
        NSString * photo = [self.photo contains:IMG_URI] ? [self.photo split:IMG_URI][1] : self.photo;
        NSString * birthday = [self.birthdayBtn.titleLabel.text isEqualToString:@"填写您的生日日期"]||self.birthdayBtn.titleLabel.text== nil ? @"":self.birthdayBtn.titleLabel.text;
        NSString * qianming = self.qianmingTf.text ? self.qianmingTf.text : @"";
    
        NSString * gender = self.nanImageView.tag == 2002 && self.nvImageView.tag == 1001 ? @"1" : @"0";
        NSDictionary * dic = @{@"username":self.nameTf.text,
                               @"gender":gender,
                               @"photo":photo,
                               @"birthday":birthday,
                               @"site":site,
                               @"character":qianming
                               };
        [YX_MANAGER requestUpdate_userPOST:dic success:^(id object) {
            [QMUITips hideAllTipsInView:weakself.view];
            NSDictionary * userInfoDic = UserDefaultsGET(KUserInfo);
            NSMutableDictionary * mDic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
            [mDic setValue:object[@"token"] forKey:@"token"];
            [mDic setValue:dic[@"gender"] forKey:@"gender"];
            [mDic setValue:dic[@"photo"] forKey:@"photo"];
            [mDic setValue:dic[@"birthday"] forKey:@"birthday"];
            [mDic setValue:dic[@"site"] forKey:@"site"];
            [mDic setValue:dic[@"character"] forKey:@"character"];
            [mDic setValue:dic[@"username"] forKey:@"username"];
            UserDefaultsSET(mDic, KUserInfo);
            [weakself.navigationController popViewControllerAnimated:YES];
            [weakself wanshanxinxiAction];
        }];
}

- (IBAction)tiaoguoAction:(id)sender {
    [self wanshanxinxiAction];
}
//返回到首页
-(void)wanshanxinxiAction{
    UIViewController *controller = self;
    while(controller.presentingViewController != nil){
        controller = controller.presentingViewController;
    }
    [controller dismissViewControllerAnimated:YES completion:^{}];
    [[AppDelegate shareAppDelegate].mainTabBar setSelectedIndex:0];
    [QMUITips showSucceed:@"登录成功"];
}

@end
