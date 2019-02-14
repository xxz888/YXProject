//
//  ThirdMacros.h
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/18.
//  Copyright © 2017年 徐阳. All rights reserved.
//

//第三方配置

#ifndef ThirdMacros_h
#define ThirdMacros_h

// 友盟统计
#define UMengKey @"59281b4a5312dd3f5f0005ed"

//微信
#define kAppKey_Wechat          @"wx38ae805374bd9c73"
#define kSecret_Wechat          @"b319a731d49e8c67eec203731d05dd45"

// 腾讯
#define kAppKey_Tencent          @"1106139910"


//网易云信
#define kIMAppKey @"afc7265de3857bbaa7404b4ea92b191e"
#define kIMAppSecret @"c34bd403b29a"
#define kIMPushCerName @""









// 屏幕物理尺寸宽度
#define k_screen_width      [UIScreen mainScreen].bounds.size.width
// 屏幕物理尺寸高度
#define k_screen_height     [UIScreen mainScreen].bounds.size.height
// 状态栏高度
#define k_status_height     [[UIApplication sharedApplication] statusBarFrame].size.height
// 导航栏高度
#define k_nav_height        self.navigationController.navigationBar.height
// 顶部整体高度
#define k_top_height        (k_status_height + k_nav_height)

// 头像视图的宽、高
#define kFaceWidth          50
// 操作按钮的宽度
#define kOperateBtnWidth    30
// 操作视图的高度
#define kOperateHeight      0
// 操作视图的高度
#define kOperateWidth       200
// 名字视图高度
#define kNameLabelH         20
// 时间视图高度
#define kTimeLabelH         0
// 顶部和底部的留白
#define kBlank              15
// 右侧留白
#define kRightMargin        10
// 正文字体
#define kTextFont           [UIFont systemFontOfSize:15.0]
// 内容视图宽度
#define kTextWidth          (k_screen_width-60-25)
// 评论字体
#define kComTextFont        [UIFont systemFontOfSize:14.0]
// 评论高亮字体
#define kComHLTextFont      [UIFont boldSystemFontOfSize:14.0]
// 主色调高亮颜色
#define kHLTextColor        [UIColor darkGrayColor]//[UIColor colorWithRed:0.28 green:0.35 blue:0.54 alpha:1.0]
// 正文高亮颜色
#define kLinkTextColor      [UIColor darkGrayColor]//[UIColor colorWithRed:0.09 green:0.49 blue:0.99 alpha:1.0]
// 按住背景颜色
#define kHLBgColor          [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0]
// 图片间距
#define kImagePadding       5
// 图片宽度
#define kImageWidth         ( k_screen_width - 30 ) / 3
// 全文/收起按钮高度
#define kMoreLabHeight      20
// 全文/收起按钮宽度
#define kMoreLabWidth       60
// 视图之间的间距
#define kPaddingValue       0
// 评论赞视图气泡的尖尖高度
#define kArrowHeight        0
#endif /* ThirdMacros_h */
