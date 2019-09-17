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
    
    //    self.textView.layer.borderWidth = PixelOne;
    //    self.textView.layer.borderColor = UIColorSeparator.CGColor;
    //    self.textView.layer.cornerRadius = 4;
    [self.detailAdressView addSubview:self.textView];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)selectAdressAction:(id)sender {
    kWeakSelf(self);
    NSArray *dataSource = nil; // dataSource 为空时，就默认使用框架内部提供的数据源（即 BRCity.plist）
    [BRAddressPickerView showAddressPickerWithShowType:BRAddressPickerModeCity dataSource:dataSource defaultSelected:@[] isAutoSelect:YES themeColor:nil resultBlock:^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
        if (province.name && city.name && area.name) {
            NSString * address = [NSString stringWithFormat:@"%@ %@ %@", province.name, city.name, area.name];
            [weakself.selectAdressBtn setTitle:address forState:UIControlStateNormal];
            [weakself.selectAdressBtn setTitleColor:KBlackColor forState:UIControlStateNormal];
        }
        
    } cancelBlock:^{
    }];
}
- (IBAction)backvc:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
