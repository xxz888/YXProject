//
//  YXJiFenShopDetailViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/10/9.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXJiFenShopDetailViewController : RootViewController
@property (nonatomic,strong) NSMutableDictionary * startDic;
@property (weak, nonatomic) IBOutlet UITableView *yxTableView;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet UILabel *navJifen;
@property (weak, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet UIView *wenziView;

@end

NS_ASSUME_NONNULL_END
