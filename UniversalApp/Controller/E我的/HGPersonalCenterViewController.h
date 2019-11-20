//
//  HGPersonalCenterViewController.h
//  HGPersonalCenter
//
//  Created by Arch on 2017/6/16.
//  Copyright © 2017年 mint_bin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGBaseViewController.h"
@interface HGPersonalCenterViewController : RootViewController
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, assign) BOOL isEnlarge;

@property (nonatomic,assign) BOOL whereCome;// NO为自己  YES为其他人
@property (nonatomic,copy) NSString * userId;
@property (nonatomic, assign) BOOL isNeedRefresh;
@property (weak, nonatomic) IBOutlet UITableView *yxTableView;
@property (weak, nonatomic) IBOutlet UIView *controllerHeaderView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *controllerHeaderViewBackBtnWidth;
@property (weak, nonatomic) IBOutlet UIImageView *controllerHeaderViewTitleImv;
@property (weak, nonatomic) IBOutlet UILabel *controllerHeaderViewTitleLbl;
@property (weak, nonatomic) IBOutlet UIButton *controllerHeaderViewGauzhu;
- (IBAction)controllerHeaderViewGuanzhuAction:(id)sender;
- (IBAction)liaotianAction:(id)sender;
- (IBAction)moreAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *controllerHeaderViewOtherView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *controllerHeaderViewHeight;
@property (nonatomic, strong) UILabel * nodataImg;

@end
