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
#import "YXMineQianMingViewController.h"
#import "HXPhotoPicker.h"


@interface YXHomeEditPersonTableViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextViewDelegate,HXPhotoViewDelegate>{
    
    ImagePicker *imagePicker;
    
}
@property (nonatomic,strong) NSString * photo;
@property (strong, nonatomic) HXDatePhotoToolManager *toolManager;
@property (strong, nonatomic) HXPhotoManager *manager;
@end

@implementation YXHomeEditPersonTableViewController
- (IBAction)backAction:(id)sender {
 

}
- (IBAction)saveAction:(id)sender {
       [self upData];
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
    //解决方案
    self.automaticallyAdjustsScrollViewInsets=false;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    imagePicker = [ImagePicker sharedManager];
    self.title = @"编辑个人资料";
    self.tableView.tableFooterView = [[UIView alloc]init];

    
    self.titleImgView.layer.masksToBounds = YES;
    self.titleImgView.layer.cornerRadius = self.titleImgView.frame.size.width / 2.0;
    
    
    kWeakSelf(self);
//         [YX_MANAGER requestGetFind_My_user_Info:@"" success:^(id object) {
    
                 NSDictionary * object = UserDefaultsGET(KUserInfo);

                  NSString * str = [(NSMutableString *)object[@"photo"] replaceAll:@" " target:@"%20"];
                  [weakself.titleImgView sd_setImageWithURL:[NSURL URLWithString:[IMG_URI append:str]] placeholderImage:[UIImage imageNamed:@"zhanweitouxiang"]];
                  weakself.nameTf.text = kGetString(object[@"username"]);
                  [weakself.adressBtn setTitle:object[@"site"] forState:UIControlStateNormal];
                  [weakself.birthBtn setTitle:object[@"birthday"] forState:UIControlStateNormal];
                  [weakself.sexBtn setTitle:[object[@"gender"] integerValue] == 0 ? @"女":@"男" forState:UIControlStateNormal];
                  [weakself.qianMingBtn setTitle:object[@"character"] forState:UIControlStateNormal];
    
                [self changeTfColor:self.nameTf];
    [self changeBtnColor:self.adressBtn];
    [self changeBtnColor:self.birthBtn];
    [self changeBtnColor:self.qianMingBtn];
    [self changeBtnColor:self.sexBtn];

                 
                  weakself.photo = str;
         
//         }];

}
-(void)changeBtnColor:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"请填写"] || [btn.titleLabel.text isEqualToString:@"请选择"]) {
        [btn setTitleColor:COLOR_999999 forState:0];
    }else{
        [btn setTitleColor:COLOR_333333 forState:0];
    }
}
-(void)changeTfColor:(UITextField *)tf{
    if ([tf.text isEqualToString:@"请填写"] || [tf.text isEqualToString:@"请选择"]) {
        tf.textColor = COLOR_999999;
    }else{
        tf.textColor = COLOR_333333;
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [_nameTf resignFirstResponder];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [super tableView:tableView numberOfRowsInSection:section] ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row
         == 0 &&  IS_IPhoneX) {
           return 84;
    }else{
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 2) {
        cell.separatorInset = UIEdgeInsetsMake(0, KScreenWidth, 0, 0);
    }
    return cell;
}
-(void)upData{
    kWeakSelf(self);
    [QMUITips showLoadingInView:self.view];
    NSString * site = self.adressBtn.titleLabel.text ? self.adressBtn.titleLabel.text : @"";
    NSString * photo = [self.photo contains:IMG_URI] ? [self.photo split:IMG_URI][1] : self.photo;
    NSString * birthday = [self.birthBtn.titleLabel.text isEqualToString:@"点击选择生日"]||self.birthBtn.titleLabel.text==nil ?@"":self.birthBtn.titleLabel.text;
    NSString * qianming = self.qianMingBtn.titleLabel.text ? self.qianMingBtn.titleLabel.text : @"";
    NSDictionary * dic = @{@"username":self.nameTf.text,
                           @"gender":[self.sexBtn.titleLabel.text isEqualToString:@"男"] ? @"1" :@"0",
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
    
        
        if (weakself.backvcBlock) {
            weakself.backvcBlock();
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
        self.manager.configuration.saveSystemAblum = NO;
         
         __weak typeof(self) weakSelf = self;
         [self hx_presentAlbumListViewControllerWithManager:self.manager done:^(NSArray<HXPhotoModel *> *allList, NSArray<HXPhotoModel *> *photoList, NSArray<HXPhotoModel *> *videoList, BOOL original, HXAlbumListViewController *viewController) {
             if (photoList.count > 0) {
                 [weakSelf.view showLoadingHUDText:@"获取图片中"];
                 [weakSelf.toolManager getSelectedImageList:photoList requestType:0 success:^(NSArray<UIImage *> *imageList) {
                     kWeakSelf(self);
                       [QiniuLoad uploadImageToQNFilePath:imageList success:^(NSString *reslut) {
                           NSMutableArray * qiniuArray = [NSMutableArray arrayWithArray:[reslut split:@";"]];
                           weakself.titleImgView.image = imageList[0];
                            weakself.photo = qiniuArray[0];
                           [weakSelf.view handleLoading];
                       } failure:^(NSString *error) {}];
                 } failed:^{
                     [weakSelf.view handleLoading];
                     [weakSelf.view showImageHUDText:@"获取失败"];
                 }];
                 NSSLog(@"%ld张图片",photoList.count);
             }
         } cancel:^(HXAlbumListViewController *viewController) {
             NSSLog(@"取消了");
         }];
}
- (IBAction)sexBtnAction:(id)sender {
    [_nameTf resignFirstResponder];

    kWeakSelf(self);
    [BRStringPickerView showStringPickerWithTitle:@"性别" dataSource:@[@"男", @"女"] defaultSelValue:@"" resultBlock:^(id selectValue) {
        [weakself.sexBtn setTitle:selectValue forState:UIControlStateNormal];
        [weakself.sexBtn setTitleColor:COLOR_333333 forState:0];

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
            [weakself.adressBtn setTitleColor:COLOR_333333 forState:0];
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
        [weakself.birthBtn setTitleColor:COLOR_333333 forState:0];

    } cancelBlock:^{
        NSLog(@"点击了背景或取消按钮");
    }];
}

- (IBAction)gexingqianmingAction:(id)sender {
    kWeakSelf(self);
    YXMineQianMingViewController * vc = [[YXMineQianMingViewController alloc]init];
    vc.qianmingblock = ^(NSString * qianming) {
        [weakself.qianMingBtn setTitle:qianming forState:UIControlStateNormal];
        [weakself.qianMingBtn setTitleColor:COLOR_333333 forState:0];

    };
    [self.navigationController pushViewController:vc animated:YES];
}


@end
