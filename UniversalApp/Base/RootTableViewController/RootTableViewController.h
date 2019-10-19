//
//  RootTableViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/2/18.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RootTableViewController : UITableViewController
/**
 *  修改状态栏颜色
 */
@property (nonatomic, assign) UIStatusBarStyle StatusBarStyle;

@property (nonatomic,copy) ListenChangeIndexBlock getIndex;
/**
 *  是否显示返回按钮,默认情况是YES
 */
@property (nonatomic, assign) BOOL isShowLiftBack;

/**
 是否隐藏导航栏
 */
@property (nonatomic, assign) BOOL isHidenNaviBar;

@property (nonatomic,assign) NSInteger requestPage;
- (void)addRefreshView:(UITableView *)yxTableView;
-(void)headerRereshing;
-(void)footerRereshing;
@end

NS_ASSUME_NONNULL_END
