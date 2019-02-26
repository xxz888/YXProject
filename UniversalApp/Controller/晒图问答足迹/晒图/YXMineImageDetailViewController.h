//
//  YXMineImageDetailViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/23.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXMineImageDetailViewController : RootViewController
@property (weak, nonatomic) IBOutlet UITableView *yxTableView;
@property(nonatomic,strong)NSDictionary * startDic;
@property (weak, nonatomic) IBOutlet UIButton *clickPingLunBtn;
@property (nonatomic,assign) CGFloat height;
@end

NS_ASSUME_NONNULL_END
