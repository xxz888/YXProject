//
//  YXMineAddAdressViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/9/16.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXMineAddAdressViewController.h"
#import "BRStringPickerView.h"
#import "BRAddressPickerView.h"
#import "NSDate+BRPickerView.h"
#import "BRDatePickerView.h"
@interface YXMineAddAdressViewController ()<QMUITextViewDelegate>
@property(nonatomic,strong) QMUITextView *textView;
@end

@implementation YXMineAddAdressViewController



- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"新增收货地址";
    [self setUI];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self editCome];
}
-(void)editCome{
    
    if (self.addressDic) {
        self.adPhone.text = self.addressDic[@"phone"];
        self.adName.text = self.addressDic[@"name"];
        self.textView.text = [self.addressDic[@"site"] split:@" "][1];
        [self.selectAdressBtn setTitle:[self.addressDic[@"site"] split:@" "][0] forState:0];
        self.delBtn.hidden = NO;
        [self.selectAdressBtn setTitleColor:kRGBA(59, 59, 59, 1) forState:0];
    }else{
        self.delBtn.hidden = YES;
    }
}
-(void)setUI{
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    self.textView = [[QMUITextView alloc] init];
    self.textView.frame = CGRectMake(0, 0, KScreenWidth, self.detailAdressView.frame.size.height);
    self.textView.delegate = self;
    self.textView.placeholder = @"请输入详细地址";
    self.textView.placeholderColor = UIColorPlaceholder; // 自定义 placeholder 的颜色
    self.textView.textContainerInset = UIEdgeInsetsMake(10, 7, 10, 7);
    self.textView.returnKeyType = UIReturnKeySend;
    self.textView.enablesReturnKeyAutomatically = YES;
    self.textView.typingAttributes = @{NSFontAttributeName: UIFontMake(14),
                                       NSForegroundColorAttributeName: kRGBA(53, 60, 70, 1),
                                       NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:20]};
    // 限制可输入的字符长度
    self.textView.maximumTextLength = 100;
    // 限制输入框自增高的最大高度
    self.textView.maximumHeight = 200;
    [self.detailAdressView addSubview:self.textView];
}

- (IBAction)selectAdressAction:(id)sender {
    kWeakSelf(self);
    NSArray *dataSource = nil; // dataSource 为空时，就默认使用框架内部提供的数据源（即 BRCity.plist）
    [BRAddressPickerView showAddressPickerWithShowType:BRAddressPickerModeCity dataSource:dataSource defaultSelected:@[] isAutoSelect:YES themeColor:nil resultBlock:^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
        if (province.name && city.name && area.name) {
            NSString * address = [NSString stringWithFormat:@"%@%@%@", province.name, city.name, area.name];
            [weakself.selectAdressBtn setTitle:address forState:UIControlStateNormal];
            [weakself.selectAdressBtn setTitleColor:KBlackColor forState:UIControlStateNormal];
        }
        
    } cancelBlock:^{
    }];
}
- (IBAction)backvc:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)saveAction:(id)sender {
    if (![self panduanIsEmpty]) {
        return;
    }
    
    NSDictionary * dic ;
    //如果addressdic有值，说明是编辑进来的
    if (self.addressDic) {
        dic = @{
                @"type":@"3",
                @"name":self.adName.text,
                @"phone":self.adPhone.text,
                @"site":[NSString stringWithFormat:@"%@ %@",self.selectAdressBtn.titleLabel.text,self.textView.text],
                @"default":[NSString stringWithFormat:@"%@",self.addressDic[@"default"]],
                @"address_id":self.addressDic[@"id"]
                };
    }else{
        dic = @{
                @"type":@"1",
                @"name":self.adName.text,
                @"phone":self.adPhone.text,
                @"site":[NSString stringWithFormat:@"%@ %@",self.selectAdressBtn.titleLabel.text,self.textView.text],
                @"default":@"0"
                };
    }
    kWeakSelf(self);
    [YXPLUS_MANAGER requestAddressAddPOST:dic success:^(id object) {
        [QMUITips showSucceed:object[@"message"] inView:[ShareManager getMainView] hideAfterDelay:1];
        [weakself.navigationController popViewControllerAnimated:YES];
    }];
}
-(BOOL)panduanIsEmpty{
    if (self.adName.text.length == 0 || self.adName.text.length > 10) {
        [QMUITips showInfo:@"请输入正确的姓名"];
        return NO;
    }
    if (self.adPhone.text.length != 11) {
        [QMUITips showInfo:@"请输入正确的手机号"];
        return NO;
    }
    if (self.textView.text.length == 0) {
        [QMUITips showInfo:@"请输入正确的地址"];
        return NO;
    }
    if (self.selectAdressBtn.titleLabel.text.length == 0) {
        [QMUITips showInfo:@"请选择省市"];
        return NO;
    }
    return YES;
}
- (IBAction)delAction:(id)sender{
    kWeakSelf(self);
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:NULL];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"删除" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController,QMUIAlertAction *action) {
        NSDictionary * dic = @{
                               @"type":@"2",
                               @"address_id":self.addressDic[@"id"]
                               };
        [YXPLUS_MANAGER requestAddressAddPOST:dic success:^(id object) {
            [QMUITips showSucceed:object[@"message"] inView:[ShareManager getMainView] hideAfterDelay:1];
            [weakself.navigationController popViewControllerAnimated:YES];
        }];
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"确定删除？" message:@"删除后将无法恢复，请慎重考虑" preferredStyle:QMUIAlertControllerStyleAlert];
    
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController showWithAnimated:YES];
    
    
    
    

}
@end
