//
//  MainTabBarController.h
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/18.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol MCTabBarControllerDelegate<UITabBarControllerDelegate>
//// 重写了选中方法，主要处理中间item选中事件
//- (void)mcTabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
//@end
/**
 底部 TabBar 控制器
 */

#import "AxcAE_TabBar.h"
#import "TestTabBar.h"
@interface MainTabBarController : UITabBarController

@property (nonatomic, strong) AxcAE_TabBar *axcTabBar;

/**
 设置小红点
 
 @param index tabbar下标
 @param isShow 是显示还是隐藏
 */
//-(void)setRedDotWithIndex:(NSInteger)index isShow:(BOOL)isShow;
//@property (nonatomic, weak) id<MCTabBarControllerDelegate> mcDelegate;
@end
