//
//  YXHomeEditPersonTableViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/24.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeEditPersonTableViewController.h"
#import "BRStringPickerView.h"
#import "BRAddressPickerView.h"
#import "NSDate+BRPickerView.h"
#import "BRDatePickerView.h"
//导入头文件
#import "ImagePicker.h"
#import "QiniuLoad.h"
#import<QiniuSDK.h>

@interface YXHomeEditPersonTableViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextViewDelegate>{
    
    ImagePicker *imagePicker;
    
}
@property (nonatomic,strong) NSString * photo;

@end

@implementation YXHomeEditPersonTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //解决方案
    self.automaticallyAdjustsScrollViewInsets=false;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    imagePicker = [ImagePicker sharedManager];
    ViewRadius(self.finishBtn, 5);
    self.title = @"编辑个人资料";
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    
    self.titleImgView.layer.masksToBounds = YES;
    self.titleImgView.layer.cornerRadius = self.titleImgView.frame.size.width / 2.0;
    
    if (self.userInfoDic) {
        NSString * str = [(NSMutableString *)self.userInfoDic[@"photo"] replaceAll:@" " target:@"%20"];
        [self.titleImgView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"zhanweitouxiang"]];
        self.nameTf.text = kGetString(self.userInfoDic[@"username"]);
        [self.adressBtn setTitle:self.userInfoDic[@"site"] forState:UIControlStateNormal];
        [self.birthBtn setTitle:self.userInfoDic[@"birthday"] forState:UIControlStateNormal];
        [self.sexBtn setTitle:[self.userInfoDic[@"gender"] integerValue] == 0 ? @"女":@"男" forState:UIControlStateNormal];
        self.photo = self.userInfoDic[@"photo"];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden= NO;

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [super tableView:tableView numberOfRowsInSection:section] ;
}
-(void)upData{
    kWeakSelf(self);
//    [QMUITips showLoadingInView:self.view];
    NSString * site = self.adressBtn.titleLabel.text ? self.adressBtn.titleLabel.text : @"";
    NSDictionary * dic = @{@"username":self.nameTf.text,
                           @"gender":[self.sexBtn.titleLabel.text isEqualToString:@"男"] ? @"1" :@"0",
                           @"photo":self.photo,
                           @"birthday":@"",//self.birthBtn.titleLabel.text,
                           @"site":site,
                           };
    [YX_MANAGER requestUpdate_userPOST:dic success:^(id object) {
//        [self.navigationController popViewControllerAnimated:NO];
//        kWeakSelf(self);
//        [userManager logout:^(BOOL success, NSString *des) {
//
//        }];
//        [QMUITips showSucceed:@"修改成功,请重新登录"];

        [QMUITips hideAllTipsInView:self.view];
        [QMUITips showSucceed:@"修改成功"];
        UserInfo *userInfo = curUser;
        [userInfo setToken:object[@"token"]];
        
        
        if (userInfo) {
            YYCache *cache = [[YYCache alloc]initWithName:KUserCacheName];
            NSDictionary *dic = [userInfo modelToJSONObject];
            [cache setObject:dic forKey:KUserModelCache];
        }
        
        
        [weakself.navigationController popViewControllerAnimated:YES];
        
   
    }];
}
- (IBAction)finishAction:(id)sender {
    [_nameTf resignFirstResponder];

    [self upData];
}
- (IBAction)changeTitleImgAction:(id)sender {
    [_nameTf resignFirstResponder];
    [self.view endEditing:YES];
    kWeakSelf(self);
    [imagePicker dwSetPresentDelegateVC:self SheetShowInView:self.view InfoDictionaryKeys:(long)nil];
    [imagePicker dwGetpickerTypeStr:^(NSString *pickerTypeStr) {
    } pickerImagePic:^(UIImage *pickerImagePic) {
        [QMUITips showLoadingInView:self.view];
        [QiniuLoad uploadImageToQNFilePath:@[pickerImagePic] success:^(NSString *reslut) {
            [weakself.titleImgView setImage:pickerImagePic];

            weakself.photo = [NSMutableArray arrayWithArray:[reslut split:@";"]][0];
            [QMUITips hideAllTipsInView:self.view];
        } failure:^(NSString *error) {
            
        }];
     
    }];
}
- (IBAction)sexBtnAction:(id)sender {
    [_nameTf resignFirstResponder];

    kWeakSelf(self);
    [BRStringPickerView showStringPickerWithTitle:@"性别" dataSource:@[@"男", @"女", @"其他"] defaultSelValue:@"" resultBlock:^(id selectValue) {
        [weakself.sexBtn setTitle:selectValue forState:UIControlStateNormal];
    }];
}

- (IBAction)addressBtnAction:(id)sender {
    [_nameTf resignFirstResponder];
    kWeakSelf(self);
    // NSArray *dataSource = [weakSelf getAddressDataSource];  //从外部传入地区数据源
    NSArray *dataSource = nil; // dataSource 为空时，就默认使用框架内部提供的数据源（即 BRCity.plist）
    [BRAddressPickerView showAddressPickerWithShowType:BRAddressPickerModeCity dataSource:dataSource defaultSelected:@[] isAutoSelect:YES themeColor:nil resultBlock:^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
        if (province.name && city.name && area.name) {
            NSString * address = [NSString stringWithFormat:@"%@ %@ %@", province.name, city.name, area.name];
            [weakself.adressBtn setTitle:address forState:UIControlStateNormal];
        }
     
    } cancelBlock:^{
    }];
}

- (IBAction)birthBtnAction:(id)sender {
    [_nameTf resignFirstResponder];

    kWeakSelf(self);
    NSDate *minDate = [NSDate br_setYear:1990 month:3 day:12];
    NSDate *maxDate = [NSDate date];
    [BRDatePickerView showDatePickerWithTitle:@"出生日期" dateType:BRDatePickerModeYMD defaultSelValue:@"" minDate:minDate maxDate:maxDate isAutoSelect:YES themeColor:nil resultBlock:^(NSString *selectValue) {
        [weakself.birthBtn setTitle:selectValue forState:UIControlStateNormal];
    } cancelBlock:^{
        NSLog(@"点击了背景或取消按钮");
    }];
}
@end
