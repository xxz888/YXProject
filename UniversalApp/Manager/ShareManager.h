//
//  ShareManager.h
//  MiAiApp
//
//  Created by 徐阳 on 2017/6/1.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XHStarRateView.h"
#import "SDCycleScrollView.h"
#import "MMImagePreviewView.h"

/**
 分享 相关服务
 */
@interface ShareManager : NSObject

//单例
SINGLETON_FOR_HEADER(ShareManager)


/**
 展示分享页面
 */
-(void)showShareView;
//获取当前时间戳  （以毫秒为单位）

+(NSString *)getNowTimeTimestamp3;
#pragma mark - 将某个时间戳转化成 时间
+(NSString *)getNowTimeMiaoShu;
+(NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format;
+ (NSString *)updateTimeForRow:(long)timestamp;
//关注按钮初始化状态
+(void)setGuanZhuStatus:(UIButton *)btn status:(BOOL)statusBool;

+(XHStarRateView *)fiveStarView:(CGFloat)score view:(UIView *)view;
//添加轮播图
+(SDCycleScrollView *)setUpSycleScrollView:(NSMutableArray *)imageArray;
//html
+(NSString *)justFitImage:(NSString *)essay;
+(void)inTextViewOutDifColorView:(UITextView *)tfView tag:(NSString *)tag;
+(void)inTextFieldOutDifColorView:(UILabel *)tfView tag:(NSString *)tag;
+ (void)setBorderinView:(UIView *)view;
+(CGSize)cellAutoHeight:(NSString *)string;
+(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width;

@property (nonatomic,strong) MMImagePreviewView * previewView;

@end
