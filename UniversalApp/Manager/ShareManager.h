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
#import "MMImageListView.h"
#import "SELUpdateAlert.h"
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
- (void)shareAllToPlatformType:(UMSocialPlatformType)platformType obj:(id)obj;
+(NSString *)getNowTimeTimestamp3;
+(NSString*)getCurrentDay;
#pragma mark - 将某个时间戳转化成 时间
+(NSString *)getNowTimeMiaoShu;
+(NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format;
+ (NSString *)updateTimeForRow:(long)timestamp;
//关注按钮初始化状态
+(void)setGuanZhuStatus:(UIButton *)btn status:(BOOL)statusBool alertView:(BOOL)isAlertView;
+(XHStarRateView *)fiveStarView:(CGFloat)score view:(UIView *)view;
+ (NSMutableArray *)getSettleListWithBDArray;
//添加轮播图
+(SDCycleScrollView *)setUpSycleScrollView:(NSMutableArray *)imageArray;
//html
+(NSString *)justFitImage:(NSString *)essay;
//+(CGFloat)inTextOutHeight:(NSString *)string;
+(CGFloat)inTextOutHeight:(NSString *)string lineSpace:(CGFloat)lineSpacing fontSize:(CGFloat)fontSize;
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
- (void)shareAllToPlatformType:(UMSocialPlatformType)platformType obj:(id)obj;
- (void)saveImage:(UITableView *)tableView;
+(CGFloat)getImageViewSize:(NSString *)imgUrl;
+(void)setLineSpace:(CGFloat)lineSpace inLabel:(UILabel *)label size:(CGFloat)size;
+(void)inTextViewOutDifColorView:(UILabel *)tfView tag:(NSString *)tag;
- (void)shareYaoQingHaoYouToPlatformType:(UMSocialPlatformType)platformType;
+(CGFloat)inTextZhiNanOutHeight:(NSString *)str lineSpace:(CGFloat)lineSpacing fontSize:(CGFloat)fontSize width:(CGFloat)width;
- (void)pushShareViewAndDic:(NSDictionary *)shareDic;
- (void)shareAllToPlatformType:(UMSocialPlatformType)platformType obj:(id)obj;
+ (NSDictionary *)stringToDic:(NSString *)jsonString;
+(NSString*)dicToString:(NSDictionary *)dic;
+(NSString *)haomiaoZhuanRIqi:(NSString *)haomiao;
+ (NSString *)getOtherTimeStrWithString:(NSString *)formatTime;
+(NSString *)haomiaoNianYueRi:(NSString *)haomiao;
//所有要接受的消息都走这里，方便管理。此方法已经验证正确
-(void)receiveAllKindsMessage:(NSDictionary *)messNewDic message:(NSMutableArray *)messages userInfoDic:(NSDictionary *)userInfoDic  type:(int)type;
-(BOOL)getOwnDbMessage:(NSString *)own_id aim_id:(NSString *)aim_id other:(NSDictionary *)otherDic;
-(BOOL)getOwnListDbMessage:(NSString *)own_id aim_id:(NSString *)aim_id;
+(CGFloat)inTextBlodOutHeight:(NSString *)string lineSpace:(CGFloat)lineSpacing fontSize:(CGFloat)fontSize;
@end
