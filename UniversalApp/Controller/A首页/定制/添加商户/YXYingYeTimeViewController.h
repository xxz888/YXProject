//
//  YXYingYeTimeViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/12.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

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

@end

NS_ASSUME_NONNULL_END
