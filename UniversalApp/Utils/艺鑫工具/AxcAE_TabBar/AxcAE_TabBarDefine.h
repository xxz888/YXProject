//
//  AxcAE_TabBarDefine.h
//  Axc_AEUI
//
//  Created by Axc on 2018/6/2.
//  Copyright © 2018年 AxcLogo. All rights reserved.
//

#ifndef AxcAE_TabBarDefine_h
#define AxcAE_TabBarDefine_h

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

// weak
#define WeakSelf __weak typeof(self)weakSelf = self

#define AxcAE_TabBarRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define AxcAE_TabBarRGB(r,g,b) AxcAE_TabBarRGBA(r,g,b,1.0f)

#define AxcAE_TabBarItemSlectBlue AxcAE_TabBarRGB(59,185,222)
#define AxcAE_TabBarItemBadgeRed  AxcAE_TabBarRGB(255,38,0)

//根据宽高: 异性全面屏
#define IS_IPhoneX ((SCREEN_WIDTH == 375.f && SCREEN_HEIGHT == 812.f ? YES : NO) || (SCREEN_WIDTH == 414.f && SCREEN_HEIGHT == 896.f ? YES : NO))

#define SCREEN_Y (IS_IPhoneX ? 88 : 64)   //距离顶部导航高度
#define SCREEN_Top_Y (IS_IPhoneX ? 24 : 0) //距离顶部高度0
#define SCREEN_Bar_H (IS_IPhoneX ? 44 : 20) //状态栏高度
#define SCREEN_Nav_H (IS_IPhoneX ? 88 : 64) //导航高度
#define SCREEN_Nav_Content_H (IS_IPhoneX ? 44 : 44)
#define SCREEN_B_Y (IS_IPhoneX ? -83 : -49) //约束距离底部高度值
#define SCREEN_B_H (IS_IPhoneX ? 83 : 49) //底部高度
#define SCREEN_B_0 (IS_IPhoneX ? 34 : 0) ////距离底部
#define DISCOVER_TOPBAR (IS_IPhoneX ? 114 : 86)   //距离顶部导航高度

#define SCREEN_keyboard_H (IS_IPhoneX ? 334 : 300) //键盘高度
#define PlusSizeX SCREEN_WIDTH/375/2
#endif /* AxcAE_TabBarDefine_h */
