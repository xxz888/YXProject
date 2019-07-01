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
#import "Moment.h"
#import <UShareUI/UShareUI.h>
#import "UIColor+MyColor.h"
#import "MMImageListView.h"
#import "SELUpdateAlert.h"
#import "UDPManage.h"
#import "Comment.h"
/**
 分享 相关服务
 */
@interface ShareManager : NSObject

//单例
SINGLETON_FOR_HEADER(ShareManager)


/**
 展示分享页面
 */
-(void)showShareView:(NSString *)obj;
//获取当前时间戳  （以毫秒为单位）
- (void)shareWebPageZhiNanDetailToPlatformType:(UMSocialPlatformType)platformType obj:(id)obj;
+(NSString *)getNowTimeTimestamp3;
#pragma mark - 将某个时间戳转化成 时间
+(NSString *)getNowTimeMiaoShu;
+(NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format;
+ (NSString *)updateTimeForRow:(long)timestamp;
//关注按钮初始化状态
+(void)setGuanZhuStatus:(UIButton *)btn status:(BOOL)statusBool alertView:(BOOL)isAlertView;
+(XHStarRateView *)fiveStarView:(CGFloat)score view:(UIView *)view;
//添加轮播图
+(SDCycleScrollView *)setUpSycleScrollView:(NSMutableArray *)imageArray;
//html
+(NSString *)justFitImage:(NSString *)essay;
//+(CGFloat)inTextOutHeight:(NSString *)string;
+(CGFloat)inTextOutHeight:(NSString *)string lineSpace:(CGFloat)lineSpacing fontSize:(CGFloat)fontSize;
+ (void)setBorderinView:(UIView *)view;
+(CGSize)cellAutoHeight:(NSString *)string;
// 根据图片url获取图片尺寸
+(CGFloat)getImageSizeWithURL:(id)imageURL;
@property (nonatomic,strong) MMImagePreviewView * previewView;
+(UIView *)getMainView;
+(CGFloat)getOldImageSizeWithURL:(id)URL;
+ (void)updateApp;
+(void)upDataPersionIP;
+(Moment *)setTestInfo:(NSDictionary *)dic;
+ (void)returnUpdateVersion;
//HTML适配图片文字
+ (NSString *)adaptWebViewForHtml:(NSString *) htmlStr;
+(void)setLineSpace_Price:(CGFloat)lineSpace withText:(NSString *)text inLabel:(UILabel *)label tag:(NSString *)tag;
+(void)setLineSpace_Price_RedColor:(CGFloat)lineSpace withText:(NSString *)text inLabel:(UILabel *)label tag:(NSString *)tag;
+(CGFloat)inTextZhiNanOutHeight:(NSString *)str lineSpace:(CGFloat)lineSpacing fontSize:(CGFloat)fontSize;
- (void)shareWebPageZhiNanDetailToPlatformType:(UMSocialPlatformType)platformType obj:(id)obj;
- (void)saveImage:(UITableView *)tableView;
+(CGFloat)getImageViewSize:(NSString *)imgUrl;
+(void)setLineSpace:(CGFloat)lineSpace inLabel:(UILabel *)label;
@end
