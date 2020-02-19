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
#define startTime @"00:00"
#define endTime @"24:00"

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
    ViewBorderRadius(self.week1, 4, 1, COLOR_BBBBBB);
    ViewBorderRadius(self.week2, 4, 1, COLOR_BBBBBB);
    ViewBorderRadius(self.week3, 4, 1, COLOR_BBBBBB);
    ViewBorderRadius(self.week4, 4, 1, COLOR_BBBBBB);
    ViewBorderRadius(self.week5, 4, 1, COLOR_BBBBBB);
    ViewBorderRadius(self.week6, 4, 1, COLOR_BBBBBB);
    ViewBorderRadius(self.week7, 4, 1, COLOR_BBBBBB);
    
    self.time24Btn.selected = NO;
    self.week1.selected = self.week2.selected = self.week3.selected = self.week4.selected =self.week5.selected = self.week6.selected = self.week7.selected = NO;
    
    //星期
    if (self.business_days.length && self.business_days.length !=0) {
        if ([self.business_days contains:@"1"]) {
                   self.week1.tag = 1;
                   [self selectBtnStatus:self.week1];
                   [_yingyeriArray addObject:@"1"];
        }
        if ([self.business_days contains:@"2"]) {
                   self.week2.tag = 2;
                   [self selectBtnStatus:self.week2];
                   [_yingyeriArray addObject:@"2"];
        }
        if ([self.business_days contains:@"3"]) {
                   self.week3.tag = 3;
                   [self selectBtnStatus:self.week3];
                   [_yingyeriArray addObject:@"3"];
        }
        if ([self.business_days contains:@"4"]) {
                   self.week4.tag = 4;
                   [self selectBtnStatus:self.week4];
                   [_yingyeriArray addObject:@"4"];
        }
        if ([self.business_days contains:@"5"]) {
                   self.week5.tag = 5;
                   [self selectBtnStatus:self.week5];
                   [_yingyeriArray addObject:@"5"];
        }
        if ([self.business_days contains:@"6"]) {
                   self.week6.tag = 6;
                   [self selectBtnStatus:self.week6];
                   [_yingyeriArray addObject:@"6"];
        }
        if ([self.business_days contains:@"7"]) {
                   self.week7.tag = 7;
                   [self selectBtnStatus:self.week7];
                   [_yingyeriArray addObject:@"7"];
 
        }
    }
    //营业时间
    if ([self.round_the_clock isEqualToString:@"1"]) {
        [self.timeBtn setTitle:[@"开始时间 " append:startTime] forState:UIControlStateNormal];
        [self.timeBtn setTitleColor:KBlackColor forState:UIControlStateNormal];
        
        [self.timeEndBtn setTitle:[@"结束时间 " append:endTime] forState:UIControlStateNormal];
        [self.timeEndBtn setTitleColor:KBlackColor forState:UIControlStateNormal];
        
        self.time24Btn.selected = YES;
    }else{
        if (self.business_hours && self.business_hours.length != 0) {
              [self.timeBtn setTitle:[@"开始时间 " append:[self.business_hours split:@","][0]] forState:UIControlStateNormal];
              [self.timeBtn setTitleColor:KBlackColor forState:UIControlStateNormal];
                  
              [self.timeEndBtn setTitle:[@"结束时间 " append:[self.business_hours split:@","][1]] forState:UIControlStateNormal];
              [self.timeEndBtn setTitleColor:KBlackColor forState:UIControlStateNormal];
        }
        self.time24Btn.selected = NO;
    }

}
- (IBAction)backVcAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)weekAction:(UIButton *)btn{
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
        [weakself.timeBtn setTitle:[@"开始时间 " append:selectValue] forState:UIControlStateNormal];
        [weakself.timeBtn setTitleColor:KBlackColor forState:UIControlStateNormal];
    } cancelBlock:^{}];
}
- (IBAction)timeEndAction:(id)sender {
       [self.view endEditing:YES];
       kWeakSelf(self);
       [BRDatePickerView showDatePickerWithTitle:@"营业结束时间" dateType:BRDatePickerModeHM defaultSelValue:@"20:00" minDate:nil maxDate:nil isAutoSelect:YES themeColor:nil resultBlock:^(NSString *selectValue) {
           [weakself.timeEndBtn setTitle:[@"结束时间 " append:selectValue] forState:UIControlStateNormal];
           [weakself.timeEndBtn setTitleColor:KBlackColor forState:UIControlStateNormal];
       } cancelBlock:^{}];
}
- (IBAction)time24BtnAction:(UIButton *)btn{
         self.time24Btn.selected = !self.time24Btn.selected;
    if (self.time24Btn.selected) {
        [self.timeBtn setTitle:[@"开始时间 " append:startTime] forState:UIControlStateNormal];
        [self.timeBtn setTitleColor:KBlackColor forState:UIControlStateNormal];
        
        [self.timeEndBtn setTitle:[@"结束时间 " append:endTime] forState:UIControlStateNormal];
        [self.timeEndBtn setTitleColor:KBlackColor forState:UIControlStateNormal];
    }
    

         
}

- (IBAction)saveAction:(id)sender {
    if (self.yingyeriArray.count == 0) {
        [QMUITips showError:@"请选择营业日"];
        return;
    }
    
    //如果选择24小时营业的话，开始时间和结束时间可不选择
    NSString * allTime = @"";
    if (self.time24Btn.selected) {
        allTime = @"00:00,24:00";
    }else{
        if ([self.timeBtn.titleLabel.text isEqualToString:@"请选择营业开始时间"]) {
            [QMUITips showError:@"请选择营业开始时间"];
            return;
        }
        if ([self.timeEndBtn.titleLabel.text isEqualToString:@"请选择营业结束时间"]) {
              [QMUITips showError:@"请选择营业结束时间"];
              return;
        }
        NSString * startTime1 = [self.timeBtn.titleLabel.text split:@" "][1];
        NSString * endTime1 =   [self.timeEndBtn.titleLabel.text split:@" "][1];
        allTime = [NSString stringWithFormat:@"%@,%@",startTime1,endTime1];
    }

    //营业日数组
    NSString * business_days = [_yingyeriArray componentsJoinedByString:@","];
    [self.navigationController popViewControllerAnimated:YES];
    if (self.yingyeshijianblock) {
            self.yingyeshijianblock(@{
            @"business_days":business_days,
            @"business_hours":allTime,
            @"round_the_clock":self.time24Btn.selected ? @"1" : @"0"
        });
    }
}
@end
