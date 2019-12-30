//
//  YXPingLunDetailViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/28.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXPingLunDetailViewController : RootViewController
@property (weak, nonatomic) IBOutlet UILabel *pinglunTitle;
@property (weak, nonatomic) IBOutlet UITableView *yxTableView;
- (IBAction)backVcAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property(nonatomic,strong)NSDictionary * startDic;
@property(nonatomic,strong)NSDictionary * startStartDic;

@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)NSMutableArray * lastArray;
- (IBAction)clickPingLunAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *bottomMySelfImv;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
- (IBAction)zanAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
