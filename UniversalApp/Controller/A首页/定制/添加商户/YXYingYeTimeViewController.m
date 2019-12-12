//
//  YXYingYeTimeViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/12.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXYingYeTimeViewController.h"
#import "NSDate+BRPickerView.h"
#import "BRDatePickerView.h"
@interface YXYingYeTimeViewController ()

@end

@implementation YXYingYeTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backVcAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)weekAction:(UIButton *)btn{
    //1010,1020,大于1000代表未选择，小于1000代表选择
    //101,102
    if (btn.tag > 1000) {
        btn.tag = btn.tag - 1000;
        [self selectBtnStatus:btn];
    }else{
        btn.tag = btn.tag + 1000;
        [self unSelectBtnStatus:btn];
    }
}
-(void)selectBtnStatus:(UIButton *)btn{
    ViewBorderRadius(btn, 4, 1, SEGMENT_COLOR);
    [btn setTitleColor:SEGMENT_COLOR forState:0];
}
-(void)unSelectBtnStatus:(UIButton *)btn{
    ViewBorderRadius(btn, 4, 1, COLOR_BBBBBB);
    [btn setTitleColor:COLOR_BBBBBB forState:0];
    
}
- (IBAction)timeAction:(id)sender {
    [self.view endEditing:YES];
    kWeakSelf(self);
 
    [BRDatePickerView showDatePickerWithTitle:@"营业开始时间" dateType:BRDatePickerModeHM defaultSelValue:@"" minDate:nil maxDate:nil isAutoSelect:YES themeColor:nil resultBlock:^(NSString *selectValue) {
        [weakself.timeBtn setTitle:[@"开始时间:" append:selectValue] forState:UIControlStateNormal];
        [weakself.timeBtn setTitleColor:KBlackColor forState:UIControlStateNormal];
    } cancelBlock:^{}];
}
- (IBAction)timeEndAction:(id)sender {
       [self.view endEditing:YES];
       kWeakSelf(self);
       [BRDatePickerView showDatePickerWithTitle:@"营业结束时间" dateType:BRDatePickerModeHM defaultSelValue:@"" minDate:nil maxDate:nil isAutoSelect:YES themeColor:nil resultBlock:^(NSString *selectValue) {
           [weakself.timeEndBtn setTitle:[@"结束时间:" append:selectValue] forState:UIControlStateNormal];
           [weakself.timeEndBtn setTitleColor:KBlackColor forState:UIControlStateNormal];
       } cancelBlock:^{}];
}
@end
