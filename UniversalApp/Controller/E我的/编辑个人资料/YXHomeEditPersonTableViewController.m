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
#import "UniversalApp-Swift.h"
#import "YXMineQianMingViewController.h"

@interface YXHomeEditPersonTableViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextViewDelegate,KSMediaPickerControllerDelegate>{
    
    ImagePicker *imagePicker;
    
}
@property (nonatomic,strong) NSString * photo;

@end

@implementation YXHomeEditPersonTableViewController
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //解决方案
    self.automaticallyAdjustsScrollViewInsets=false;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    imagePicker = [ImagePicker sharedManager];
    self.title = @"编辑个人资料";
    self.tableView.tableFooterView = [[UIView alloc]init];

    
    self.titleImgView.layer.masksToBounds = YES;
    self.titleImgView.layer.cornerRadius = self.titleImgView.frame.size.width / 2.0;
    
    
    kWeakSelf(self);
         [YX_MANAGER requestGetFind_My_user_Info:@"" success:^(id object) {
                  NSString * str = [(NSMutableString *)object[@"photo"] replaceAll:@" " target:@"%20"];
                  [weakself.titleImgView sd_setImageWithURL:[NSURL URLWithString:[IMG_URI append:str]] placeholderImage:[UIImage imageNamed:@"zhanweitouxiang"]];
                  weakself.nameTf.text = kGetString(object[@"username"]);
                  [weakself.adressBtn setTitle:object[@"site"] forState:UIControlStateNormal];
                  [weakself.birthBtn setTitle:object[@"birthday"] forState:UIControlStateNormal];
                  [weakself.sexBtn setTitle:[object[@"gender"] integerValue] == 0 ? @"女":@"男" forState:UIControlStateNormal];
                  [weakself.qianMingBtn setTitle:object[@"character"] forState:UIControlStateNormal];
                  weakself.photo = str;
         
         }];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [_nameTf resignFirstResponder];
    
    [self upData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [super tableView:tableView numberOfRowsInSection:section] ;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 1) {
        cell.separatorInset = UIEdgeInsetsMake(0, KScreenWidth, 0, 0);
    }
    return cell;
}
-(void)upData{
    kWeakSelf(self);
//    [QMUITips showLoadingInView:self.view];
    NSString * site = self.adressBtn.titleLabel.text ? self.adressBtn.titleLabel.text : @"";
    NSDictionary * dic = @{@"username":self.nameTf.text,
                           @"gender":[self.sexBtn.titleLabel.text isEqualToString:@"男"] ? @"1" :@"0",
                           @"photo":self.photo,
                           @"birthday":self.birthBtn.titleLabel.text,
                           @"site":site,
                           @"character":self.qianMingBtn.titleLabel.text
                           };
    [YX_MANAGER requestUpdate_userPOST:dic success:^(id object) {
        [QMUITips hideAllTipsInView:weakself.view];
//        [QMUITips showSucceed:@"修改成功"];
        UserInfo *userInfo = curUser;
        [userInfo setToken:object[@"token"]];
        
        
        if (userInfo) {
            YYCache *cache = [[YYCache alloc]initWithName:KUserCacheName];
            NSDictionary *dic = [userInfo modelToJSONObject];
            [cache setObject:dic forKey:KUserModelCache];
        }
        
        
//        [weakself.navigationController popViewControllerAnimated:YES];
        
   
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
    
    KSMediaPickerController *ctl = [KSMediaPickerController.alloc initWithMaxVideoItemCount:0 maxPictureItemCount:1];
    ctl.delegate = self;
    KSNavigationController *nav = [KSNavigationController.alloc initWithRootViewController:ctl];
    nav.modalPresentationStyle = 0;
    [self presentViewController:nav animated:YES completion:nil];
    
    
    
    
    
    
    return;
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


#pragma mark ==========  图片和视频返回的block ==========
- (void)mediaPicker:(KSMediaPickerController *)mediaPicker didFinishSelected:(NSArray<KSMediaPickerOutputModel *> *)outputArray {
    [mediaPicker.navigationController dismissViewControllerAnimated:YES completion:nil];
    KSMediaPickerOutputModel * model =  outputArray[0];
    [self uploadImageQiNiuYun:@[model.image]];
}
-(void)uploadImageQiNiuYun:(NSArray *)upLoadImageArray{
    kWeakSelf(self);
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    [QMUITips showLoadingInView:self.view];
    [QiniuLoad uploadImageToQNFilePath:upLoadImageArray success:^(NSString *reslut) {
        NSMutableArray * qiniuArray = [NSMutableArray arrayWithArray:[reslut split:@";"]];
        weakself.titleImgView.image = upLoadImageArray[0];
         weakself.photo = qiniuArray[0];
        [QMUITips hideAllTipsInView:weakself.view];

        NSLog(@"------------七牛云上传图片耗时: %f秒", CFAbsoluteTimeGetCurrent() - start);
    } failure:^(NSString *error) {}];
}
- (IBAction)sexBtnAction:(id)sender {
    [_nameTf resignFirstResponder];

    kWeakSelf(self);
    [BRStringPickerView showStringPickerWithTitle:@"性别" dataSource:@[@"男", @"女"] defaultSelValue:@"" resultBlock:^(id selectValue) {
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

- (IBAction)gexingqianmingAction:(id)sender {
    kWeakSelf(self);
    YXMineQianMingViewController * vc = [[YXMineQianMingViewController alloc]init];
    vc.qianmingblock = ^(NSString * qianming) {
        [weakself.qianMingBtn setTitle:qianming forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:vc animated:YES];
}


@end
