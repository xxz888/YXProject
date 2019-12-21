//
//  YXDingZhi4TableViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/12.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootTableViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface YXDingZhi4TableViewController : RootTableViewController
- (IBAction)backVcAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *mentouView;
@property (weak, nonatomic) IBOutlet UITextField *mentouName;
@property (weak, nonatomic) IBOutlet UITextField *fendianName;
@property (weak, nonatomic) IBOutlet UIButton *xiefuBtn;
@property (weak, nonatomic) IBOutlet UIButton *caifengBtn;
@property (weak, nonatomic) IBOutlet UIButton *huliBtn;
- (IBAction)shanghuTypeAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *chengshiBtn;
- (IBAction)chengshiAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *dizhiTf;
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UIButton *yingyeshijianBtn;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
- (IBAction)finishAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
