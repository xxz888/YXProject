//
//  YXHomeXueJiaPinPaiViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/6.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^dismissBlock) ();

NS_ASSUME_NONNULL_BEGIN

@interface YXHomeXueJiaPinPaiViewController : RootViewController
//block声明属性
@property (nonatomic, copy) dismissBlock mDismissBlock;
//block声明方法
-(void)toDissmissSelf:(dismissBlock)block;

@property (nonatomic,assign) BOOL whereCome;//yes为足迹进来 no为正常进入  足迹进来需隐藏热门商品
@end

NS_ASSUME_NONNULL_END
