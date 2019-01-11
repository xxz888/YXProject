//
//  Utility.m
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "Utility.h"

@implementation Utility
#pragma mark - ------------------ 动态 ------------------
// 头像视图的宽、高
#define kFaceWidth          40
// 操作按钮的宽度
#define kOperateBtnWidth    30
// 操作视图的高度
#define kOperateHeight      38
// 操作视图的高度
#define kOperateWidth       200
// 名字视图高度
#define kNameLabelH         20
// 时间视图高度
#define kTimeLabelH         15
// 顶部和底部的留白
#define kBlank              15
// 右侧留白
#define kRightMargin        15
// 正文字体
#define kTextFont           [UIFont systemFontOfSize:15.0]
// 内容视图宽度
#define kTextWidth          (k_screen_width-60-25)
// 评论字体
#define kComTextFont        [UIFont systemFontOfSize:14.0]
// 评论高亮字体
#define kComHLTextFont      [UIFont boldSystemFontOfSize:14.0]
// 主色调高亮颜色
#define kHLTextColor        [UIColor colorWithRed:0.28 green:0.35 blue:0.54 alpha:1.0]
// 正文高亮颜色
#define kLinkTextColor      [UIColor colorWithRed:0.09 green:0.49 blue:0.99 alpha:1.0]
// 按住背景颜色
#define kHLBgColor          [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0]
// 图片间距
#define kImagePadding       5
// 图片宽度
#define kImageWidth         75
// 全文/收起按钮高度
#define kMoreLabHeight      20
// 全文/收起按钮宽度
#define kMoreLabWidth       60
// 视图之间的间距
#define kPaddingValue       8
// 评论赞视图气泡的尖尖高度
#define kArrowHeight        5
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
#pragma mark - 时间戳转换
+ (NSString *)getDateFormatByTimestamp:(long long)timestamp
{
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval nowTimestamp = [dat timeIntervalSince1970] ;
    long long int timeDifference = nowTimestamp - timestamp;
    long long int secondTime = timeDifference;
    long long int minuteTime = secondTime/60;
    long long int hoursTime = minuteTime/60;
    long long int dayTime = hoursTime/24;
    long long int monthTime = dayTime/30;
    long long int yearTime = monthTime/12;
    
    if (1 <= yearTime) {
        return [NSString stringWithFormat:@"%lld年前",yearTime];
    }
    else if(1 <= monthTime) {
        return [NSString stringWithFormat:@"%lld月前",monthTime];
    }
    else if(1 <= dayTime) {
        return [NSString stringWithFormat:@"%lld天前",dayTime];
    }
    else if(1 <= hoursTime) {
        return [NSString stringWithFormat:@"%lld小时前",hoursTime];
    }
    else if(1 <= minuteTime) {
        return [NSString stringWithFormat:@"%lld分钟前",minuteTime];
    }
    else if(1 <= secondTime) {
        return [NSString stringWithFormat:@"%lld秒前",secondTime];
    }
    else {
        return @"刚刚";
    }
}

#pragma mark - 获取单张图片的实际size
+ (CGSize)getSingleSize:(CGSize)singleSize
{
    CGFloat max_width = k_screen_width - 150;
    CGFloat max_height = k_screen_width - 130;
    CGFloat image_width = singleSize.width;
    CGFloat image_height = singleSize.height;
    
    CGFloat result_width = 0;
    CGFloat result_height = 0;
    if (image_height/image_width > 3.0) {
        result_height = max_height;
        result_width = result_height/2;
    }  else  {
        result_width = max_width;
        result_height = max_width*image_height/image_width;
        if (result_height > max_height) {
            result_height = max_height;
            result_width = max_height*image_width/image_height;
        }
    }
    return CGSizeMake(result_width, result_height);
}


@end
