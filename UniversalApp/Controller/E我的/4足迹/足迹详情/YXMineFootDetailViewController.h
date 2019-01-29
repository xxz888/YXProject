//
//  YXMineFootDetailViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/29.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXMineFootDetailViewController : RootViewController

@property (weak, nonatomic) IBOutlet UITableView *yxTableView;
@property(nonatomic,strong)NSDictionary * startDic;
@property (weak, nonatomic) IBOutlet UIButton *clickPingLunBtn;

@end

NS_ASSUME_NONNULL_END
