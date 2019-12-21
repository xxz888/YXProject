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
@property(nonatomic,strong)NSMutableArray * yingyeriArray;
@property(nonatomic,strong)NSMutableArray * yingyeriStartArray;

@end

@implementation YXYingYeTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.time24Btn setBackgroundColor:KWhiteColor];
    [self.time24Btn setImage:IMAGE_NAMED(@"shouhuo_unSel") forState:UIControlStateNormal];
    [self.time24Btn setImage:IMAGE_NAMED(@"shouhuo_sel") forState:UIControlStateSelected];
    _yingyeriArray = [[NSMutableArray alloc]init];
    _yingyeriStartArray = @[self.week1,self.week2,self.week3,self.week4,self.week5,self.week6,self.week7];
}
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
    [_yingyeriArray removeAllObjects];
    for (UIButton * selectBtn in _yingyeriStartArray) {
        if (selectBtn.tag < 1000) {
            [_yingyeriArray addObject:@(selectBtn.tag)];
        }
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
 
    [BRDatePickerView showDatePickerWithTitle:@"营业开始时间" dateType:BRDatePickerModeHM defaultSelValue:@"08:00" minDate:nil maxDate:nil isAutoSelect:YES themeColor:nil resultBlock:^(NSString *selectValue) {
        [weakself.timeBtn setTitle:[@"开始时间:" append:selectValue] forState:UIControlStateNormal];
        [weakself.timeBtn setTitleColor:KBlackColor forState:UIControlStateNormal];
    } cancelBlock:^{}];
}
- (IBAction)timeEndAction:(id)sender {
       [self.view endEditing:YES];
       kWeakSelf(self);
       [BRDatePickerView showDatePickerWithTitle:@"营业结束时间" dateType:BRDatePickerModeHM defaultSelValue:@"20:00" minDate:nil maxDate:nil isAutoSelect:YES themeColor:nil resultBlock:^(NSString *selectValue) {
           [weakself.timeEndBtn setTitle:[@"结束时间:" append:selectValue] forState:UIControlStateNormal];
           [weakself.timeEndBtn setTitleColor:KBlackColor forState:UIControlStateNormal];
       } cancelBlock:^{}];
}
- (IBAction)time24BtnAction:(UIButton *)btn{
    self.time24Btn.selected = !self.time24Btn.selected;
}

- (IBAction)saveAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    if (self.yingyeshijianblock) {
        self.yingyeshijianblock(@{@"week":_yingyeriArray,@"time":@"24小时"});
    }
}
@end
