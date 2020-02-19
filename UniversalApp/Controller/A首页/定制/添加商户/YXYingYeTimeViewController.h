//
//  YXYingYeTimeViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/12.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^yingyeshijianBlock)(NSDictionary *);
@interface YXYingYeTimeViewController : RootViewController
- (IBAction)backVcAction:(id)sender;
- (IBAction)weekAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *week1;
@property (weak, nonatomic) IBOutlet UIButton *week2;
@property (weak, nonatomic) IBOutlet UIButton *week3;
@property (weak, nonatomic) IBOutlet UIButton *week4;

@property (weak, nonatomic) IBOutlet UIButton *week5;
@property (weak, nonatomic) IBOutlet UIButton *week6;
@property (weak, nonatomic) IBOutlet UIButton *week7;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
- (IBAction)timeAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *timeEndBtn;
- (IBAction)timeEndAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *time24Btn;
- (IBAction)time24BtnAction:(id)sender;
- (IBAction)saveAction:(id)sender;

@property(nonatomic,copy)yingyeshijianBlock yingyeshijianblock;



@property(nonatomic,strong)NSString * business_days;
@property(nonatomic,strong)NSString * business_hours;
@property(nonatomic,strong)NSString * round_the_clock;
@end

NS_ASSUME_NONNULL_END
