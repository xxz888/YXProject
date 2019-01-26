//
//  YXMineGuanZhuViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/9.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXMineGuanZhuViewController : RootViewController
@property (weak, nonatomic) IBOutlet UITableView *yxTableView;
@property (nonatomic,assign) BOOL whereCome;// NO为自己  YES为其他人
@property (nonatomic,copy) NSString * userId;

@end

NS_ASSUME_NONNULL_END
