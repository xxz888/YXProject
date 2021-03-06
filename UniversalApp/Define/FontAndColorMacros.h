//
//  FontAndColorMacros.h
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/18.
//  Copyright © 2017年 徐阳. All rights reserved.
//

//字体大小和颜色配置

#ifndef FontAndColorMacros_h
#define FontAndColorMacros_h

#pragma mark -  间距区


//默认间距
#define KNormalSpace 12.0f

#pragma mark -  颜色区
//主题色 导航栏颜色
#define CNavBgColor  [UIColor colorWithHexString:@"00AE68"]
//#define CNavBgColor  [Ulor colorWithHexString:@"ffffff"]
#define CNavBgFontColor  [UIColor colorWithHexString:@"ffffff"]
#define Font(a) [UIFont fontWithName:@"PingFangSC-Regular" size:a]

//默认页面背景色
#define CViewBgColor [UIColor colorWithHexString:@"f2f2f2"]

//分割线颜色
#define CLineColor [UIColor colorWithHexString:@"ededed"]

//次级字色
#define CFontColor1 [UIColor colorWithHexString:@"1f1f1f"]

//再次级字色
#define CFontColor2 [UIColor colorWithHexString:@"5c5c5c"]

#define YXRGBAColor(r,g,b)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define A_COlOR YXRGBAColor(176, 151, 99)
#define C_COLOR YXRGBAColor(242, 242, 242)

#define COLOR_000000 YXRGBAColor(0, 0, 0)
#define COLOR_333333 YXRGBAColor(51, 51, 51)
#define COLOR_BBBBBB kRGBA(187, 187, 187, 1)
#define COLOR_444444 kRGBA(68, 68, 68, 1)
#define COLOR_999999 YXRGBAColor(153, 153, 153)
#define COLOR_EEEEEE YXRGBAColor(238, 238, 238)

#define COLOR_F5F5F5 kRGBA(245, 245, 245, 1)

#define C_COLOR YXRGBAColor(242, 242, 242)

#define SEGMENT_COLOR YXRGBAColor(16, 35, 58)
#define KDarkGaryColor [UIColor darkGrayColor]
#pragma mark -  字体区

#define UIColorTheme1 UIColorMake(239, 83, 98) // Grapefruit
#define UIColorTheme2 UIColorMake(254, 109, 75) // Bittersweet
#define UIColorTheme3 UIColorMake(255, 207, 71) // Sunflower
#define UIColorTheme4 UIColorMake(159, 214, 97) // Grass
#define UIColorTheme5 UIColorMake(63, 208, 173) // Mint
#define UIColorTheme6 UIColorMake(49, 189, 243) // Aqua
#define UIColorTheme7 UIColorMake(90, 154, 239) // Blue Jeans
#define UIColorTheme8 UIColorMake(172, 143, 239) // Lavender
#define UIColorTheme9 UIColorMake(238, 133, 193) // Pink Rose
#define FFont1 [UIFont systemFontOfSize:12.0f]

#endif /* FontAndColorMacros_h */
