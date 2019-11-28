//
//  ShareManager.m
//  MiAiApp
//
//  Created by 徐阳 on 2017/6/1.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import "ShareManager.h"
#import "QiniuLoad.h"
#import "MessageModel.h"
#import "MessageFrameModel.h"
#import "JQFMDB.h"

@implementation ShareManager

SINGLETON_FOR_CLASS(ShareManager);

-(void)showShareView:(NSString *)obj{
    kWeakSelf(self);
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            [weakself shareAllToPlatformType:platformType obj:obj];
    }];
}
- (void)shareAllToPlatformType:(UMSocialPlatformType)platformType obj:(id)obj{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    UIImage * thumbURL = [UIImage imageNamed:@"appicon"];
    
    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:obj[@"title"] descr:obj[@"desc"] thumImage:thumbURL];
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
    /*
    这两分为两种情况，一种是直接分享图片出去，一种是分享实际自己的内容出去，接受方式不一样，所以在这里分别处理
    */
    
    NSString * webpageUrl = @"";
    //如果图片为空，说明是分享的自己的内容
    NSInteger type = [obj[@"type"] integerValue];
    NSString * httpurl = [API_URL split:@"/api"][0];
    NSString * url1 = [NSString stringWithFormat:@"%@/phone/#/",httpurl];
    
    switch (type) {
            case 1:{
                    webpageUrl = [NSString stringWithFormat:@"%@second/%@",url1,obj[@"index"]];
                    shareObject.thumbImage = obj[@"thumbImage"];
                    break;
                }
            case 2:{
                    webpageUrl = [NSString stringWithFormat:@"%@third/%@/%@",url1,obj[@"index1"],obj[@"index"]];
                    shareObject.thumbImage = obj[@"thumbImage"];
                    break;
                }
            case 3:{
                     NSString * resultString = [NSString stringWithFormat:@"%@",obj[@"img"]];
                     resultString = [resultString stringByReplacingOccurrencesOfString:@" " withString:@""];
                     webpageUrl = [NSString stringWithFormat:@"http://www.%@/HomeZhiNanDetail.html?img=%@",httpurl,resultString];
                     shareObject.thumbImage = obj[@"img"];
                 }
            break;
            case 4:{
                     NSDictionary * userInfo = userManager.loadUserAllInfo;
                webpageUrl = @"http://www.lpszn.com/";
//                     webpageUrl = [NSString stringWithFormat:@"%@yaoqingZhuCe.html?%@",[API_URL split:@"api"][0],kGetString(userInfo[@"id"])];
//                webpageUrl = [NSString stringWithFormat:@"http://192.168.101.21:63340/矩形抽奖活动html/yaoqingZhuCe.html?%@",kGetString(userinfo.id)];

                     shareObject.thumbImage = obj[@"thumbImage"];
                     break;
                 }
        default:
            break;
    }
    

    
    shareObject.webpageUrl = webpageUrl;


    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                if (type == 4) {
                    [YXPLUS_MANAGER requestOption_lock_historyPOST:@{} success:^(id object) {
                        [QMUITips showSucceed:@"解锁成功"];
                        KPostNotification(@"jiesuochenggong", nil);

                    }];
                }
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}

-(NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
- (void)alertWithError:(NSError *)error
{
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"分享成功"];
    }
    else{
        NSMutableString *str = [NSMutableString string];
        if (error.userInfo) {
            for (NSString *key in error.userInfo) {
                [str appendFormat:@"%@ = %@\n", key, error.userInfo[key]];
            }
        }
        if (error) {
            result = [NSString stringWithFormat:@"Share fail with error code: %d\n%@",(int)error.code, str];
        }
        else{
            result = [NSString stringWithFormat:@"Share fail"];
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享"
                                                    message:result
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"确定", @"确定")
                                          otherButtonTitles:nil];
    [alert show];
}
//获取当前的时间
+(NSString*)getCurrentTimes1:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"HH:mm"];
    NSString *timeString = [formatter stringFromDate:[NSDate date]];
    NSLog(@"The time is %@", timeString);
    return timeString;
}
+(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}
//获取当前的时间

+(NSString*)getCurrentDay{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}
//获取当前时间戳  （以毫秒为单位）

+(NSString *)getNowTimeTimestamp3{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    
    return timeSp;
    
}
+(NSString *)get2020NowTimeTimestamp{
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    return timeSp;

}
//将某个时间戳转化成 时间

#pragma mark - 将某个时间戳转化成 时间
+(NSString *)timestampSwitchTime1:(NSInteger)timestamp andFormatter:(NSString *)format{
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    
    
    //NSLog(@"&&&&&&&confromTimespStr = : %@",confromTimespStr);
    
    NSCalendar * calendar = [NSCalendar currentCalendar];
    BOOL isday  = [calendar isDateInToday:confromTimesp];
    BOOL isYestarday  = [calendar isDateInYesterday:confromTimesp];
    if (isday) {//如果是今天
        [formatter setDateFormat:@"HH:mm"];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
        [formatter setTimeZone:timeZone];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
        NSString * str = [NSString stringWithFormat:@"%@",confromTimespStr];
        return str;
    }
    if (isYestarday) {//如果是昨天
        [formatter setDateFormat:@"HH:mm"];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
        [formatter setTimeZone:timeZone];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
        NSString * str = [NSString stringWithFormat:@"昨天 %@",confromTimespStr];
        return str;
    }
    
    
    
    return confromTimespStr;
    
}
+(NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format{
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    
    
    //NSLog(@"&&&&&&&confromTimespStr = : %@",confromTimespStr);
    
    NSCalendar * calendar = [NSCalendar currentCalendar];
    BOOL isday  = [calendar isDateInToday:confromTimesp];
    BOOL isYestarday  = [calendar isDateInYesterday:confromTimesp];
    if (isday) {//如果是今天
        [formatter setDateFormat:@"HH:mm"];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
        [formatter setTimeZone:timeZone];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
        NSString * str = [NSString stringWithFormat:@"今天 %@",confromTimespStr];
        return str;
    }
    if (isYestarday) {//如果是昨天
        [formatter setDateFormat:@"HH:mm"];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
        [formatter setTimeZone:timeZone];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
        NSString * str = [NSString stringWithFormat:@"昨天 %@",confromTimespStr];
        return str;
    }
    
    
    
    return confromTimespStr;
    
}
+ (NSString *)getOtherTimeStrWithString:(NSString *)formatTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss.SSS"]; //(@"YYYY-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    //设置时区选择北京时间
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate* date = [formatter dateFromString:formatTime]; //------------将字符串按formatter转成nsdate
    //时间转时间戳的方法:
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue] * 1000;
    return [NSString stringWithFormat:@"%ld",(long)timeSp];
}
+(NSString *)haomiaoZhuanRIqi:(NSString *)haomiao{
     NSTimeInterval interval    =[haomiao doubleValue] / 1000.0;
       
       NSDate *date              = [NSDate dateWithTimeIntervalSince1970:interval];
       
       NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
       
       [formatter setDateFormat:@"HH:mm"];
       
       [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Beijing"]];
       
       NSString *dateString      = [formatter stringFromDate: date];
              
       return dateString;
}
+(NSString *)haomiaoNianYueRi:(NSString *)haomiao{
     NSTimeInterval interval    =[haomiao doubleValue] / 1000.0;
       
       NSDate *date              = [NSDate dateWithTimeIntervalSince1970:interval];
       
       NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
       
       [formatter setDateFormat:@"MM-dd HH:mm"];
       
       [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Beijing"]];
       
       NSString *dateString      = [formatter stringFromDate: date];
              
       return dateString;
}
+(NSString *)getNowTimeMiaoShu{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    return timeSp;
    
}

+ (NSString *)updateTimeForRow:(long)timestamp {
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
+(NSString*)ChatingTime:(NSString *)timestring{
  
    
    int timestamp=  [timestring intValue];
    
    
        // 创建日历对象
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        // 获取当前时间
    NSDate *currentDate = [NSDate date];
        
        // 获取当前时间的年、月、日。利用日历
        NSDateComponents *components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
        NSInteger currentYear = components.year;
        NSInteger currentMonth = components.month;
        NSInteger currentDay = components.day;
    
        
        // 获取消息发送时间的年、月、日
        NSDate *msgDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
        components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:msgDate];
        CGFloat msgYear = components.year;
        CGFloat msgMonth = components.month;
        CGFloat msgDay = components.day;
        CGFloat msghours = components.hour;
        // 进行判断
        NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
        if (currentYear == msgYear && currentMonth == msgMonth && currentDay == msgDay) {
            //今天
            if (msghours<12) {
                dateFmt.dateFormat = @"上午 hh:mm";
            }else{
                dateFmt.dateFormat = @"下午 hh:mm";
            }
           
        }else if (currentYear == msgYear && currentMonth == msgMonth && currentDay-1 == msgDay ){
            //昨天
            dateFmt.dateFormat = @"昨天 HH:mm";
        }else{
            //昨天以前
            dateFmt.dateFormat = @"MM-dd HH:mm";
        }
        // 返回处理后的结果
        return [dateFmt stringFromDate:msgDate];
    
}
+(void)setGuanZhuStatus:(UIButton *)btn status:(BOOL)statusBool alertView:(BOOL)isAlertView{
     if (statusBool) {
         [btn setTitle:@"+关注" forState:UIControlStateNormal];
         [btn setTitleColor:KWhiteColor forState:0];
         [btn setBackgroundColor:SEGMENT_COLOR];
         ViewBorderRadius(btn, 5, 1, KClearColor);
         isAlertView ? [QMUITips showSucceed:@"操作成功"] : nil;
    }else{
        [btn setTitle:@"已关注" forState:UIControlStateNormal];
        [btn setTitleColor:kRGBA(153, 153, 153, 1) forState:0];
        [btn setBackgroundColor:kRGBA(245, 245, 245, 1)];
        ViewBorderRadius(btn, 5, 1, KClearColor);
        isAlertView ?  [QMUITips showSucceed:@"操作成功"] : nil;
    }
}


+(XHStarRateView *)fiveStarView:(CGFloat)score view:(UIView *)view{
    XHStarRateView *starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    starRateView.isAnimation = YES;
    starRateView.rateStyle = WholeStar;
    starRateView.tag = 1;
    starRateView.currentScore = 5;
    [view addSubview:starRateView];
    return starRateView;
}
#pragma mark 字典转化字符串
+(NSString*)dicToString:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
+ (NSDictionary *)stringToDic:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
//添加轮播图
+(SDCycleScrollView *)setUpSycleScrollView:(NSMutableArray *)imageArray{
    
    NSMutableArray * photoArray = [NSMutableArray array];
    NSMutableArray * titleArray = [NSMutableArray array];
    
    SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 180) delegate:nil placeholderImage:[UIImage imageNamed:@"img_moren"]];
    cycleScrollView3.bannerImageViewContentMode =  3;
    cycleScrollView3.showPageControl = NO;
    cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    cycleScrollView3.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    cycleScrollView3.autoScrollTimeInterval = 4;
    cycleScrollView3.titlesGroup = titleArray;
    cycleScrollView3.imageURLStringsGroup = [NSArray arrayWithArray:imageArray];
    return cycleScrollView3;
}

+(NSString *)justFitImage:(NSString *)essay{
    NSString *htmlString = [NSString stringWithFormat:@"<html> \n"
                            "<head> \n"
                            "<style type=\"text/css\"> \n"
                            "body {font-size:15px;}\n"
                            "</style> \n"
                            "</head> \n"
                            "<body>"
                            "<script type='text/javascript'>"
                            "window.onload = function(){\n"
                            "var $img = document.getElementsByTagName('img');\n"
                            "for(var p in  $img){\n"
                            " $img[p].style.width = '100%%';\n"
                            "$img[p].style.height ='auto'\n"
                            "}\n"
                            "}"
                            "</script>%@"
                            "</body>"
                            "</html>",essay];
    return htmlString;
}

+(void)inTextViewOutDifColorView:(UILabel *)tfView tag:(NSString *)tag{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 9.0f;  //设置行间距
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:tfView.text attributes:@{NSFontAttributeName:[UIFont fontWithName:@"苹方-简" size:15],NSParagraphStyleAttributeName:paragraphStyle}];
    NSRange range1 = [[str string] rangeOfString:tag];
    [str addAttribute:NSForegroundColorAttributeName value:YXRGBAColor(10, 96, 254) range:range1];
    tfView.attributedText = str;
}
+(void)setLineSpace:(CGFloat)lineSpace inLabel:(UILabel *)label size:(CGFloat)size{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;  //设置行间距
    paragraphStyle.alignment = label.textAlignment;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:label.text attributes:@{NSFontAttributeName:[UIFont fontWithName:@"苹方-简" size:size],NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:KBlackColor}];

    label.attributedText = attributedString;
}


+(void)setLineSpace_Price:(CGFloat)lineSpace withText:(NSString *)text inLabel:(UILabel *)label tag:(NSString *)tag{
    if (!text || !label) {
        return;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;  //设置行间距
    paragraphStyle.lineBreakMode =NSLineBreakByCharWrapping;
    paragraphStyle.alignment = label.textAlignment;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    NSRange range1 = [text rangeOfString:tag];
    [attributedString addAttribute:NSForegroundColorAttributeName value:YXRGBAColor(10, 96, 254) range:range1];
    label.attributedText = attributedString;
}
+(void)setLineSpace_Price_RedColor:(CGFloat)lineSpace withText:(NSString *)text inLabel:(UILabel *)label tag:(NSString *)tag{
    if (!text || !label) {
        return;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;  //设置行间距
    paragraphStyle.lineBreakMode =NSLineBreakByCharWrapping;
    paragraphStyle.alignment = label.textAlignment;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    NSRange range1 = [text rangeOfString:tag];
    [attributedString addAttribute:NSForegroundColorAttributeName value:YXRGBAColor(255, 51, 51) range:range1];
    label.attributedText = attributedString;
}
+(CGFloat)inTextOutHeight:(NSString *)string lineSpace:(CGFloat)lineSpacing fontSize:(CGFloat)fontSize{
    if (string.length == 0 || [string isEqualToString:@""] ) {
        return 0;
    }
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = lineSpacing + 2;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Light" size:fontSize], NSParagraphStyleAttributeName:paraStyle};
    CGSize size = [string boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width - 20, MAXFLOAT) options:
                   NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return  ceil(size.height) + 10;
}
+(CGFloat)inTextBlodOutHeight:(NSString *)string lineSpace:(CGFloat)lineSpacing fontSize:(CGFloat)fontSize{
    if (string.length == 0 || [string isEqualToString:@""] ) {
        return 0;
    }
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = lineSpacing ;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:fontSize], NSParagraphStyleAttributeName:paraStyle};
    CGSize size = [string boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width - 20, MAXFLOAT) options:
                   NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    
    

    
    
    
    
    
    
    return  ceil(size.height);
}

+(CGFloat)inTextZhiNanOutHeight:(NSString *)str lineSpace:(CGFloat)lineSpacing fontSize:(CGFloat)fontSize{
    if (str.length == 0) {
        return 0;
    }
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing; // 设置行间距
    paragraphStyle.alignment = NSTextAlignmentJustified; //设置两端对齐显示
    NSDictionary *dic = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Light" size:fontSize]};
    
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedStr.length)];
    CGSize size = [str boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width-30, MAXFLOAT) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    
    
    return  size.height;
}
    


#pragma mark - 小图单击
-(void)singleTapSmallViewCallback:(MMImageView *)imageView{
    // 预览视图
    _previewView = [[MMImagePreviewView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    // 解除隐藏
    [window addSubview:_previewView];
    [window bringSubviewToFront:_previewView];
    // 清空
    [_previewView.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 添加子视图
    NSInteger index = imageView.tag-1000;
    NSInteger count = 3;
    CGRect convertRect;
    if (count == 1) {
        [_previewView.pageControl removeFromSuperview];
    }
    for (NSInteger i = 0; i < count; i ++){
        // 转换Frame
        MMImageView *pImageView = imageView;//(MMImageView *)[self viewWithTag:1000+i];
        convertRect = [[pImageView superview] convertRect:pImageView.frame toView:window];
        // 添加
        MMScrollView *scrollView = [[MMScrollView alloc] initWithFrame:CGRectMake(i*_previewView.width, 0, _previewView.width, _previewView.height)];
        scrollView.tag = 100+i;
        scrollView.maximumZoomScale = 2.0;
        scrollView.image = pImageView.image;
        scrollView.contentRect = convertRect;
        // 单击
        [scrollView setTapBigView:^(MMScrollView *scrollView){
            [self singleTapBigViewCallback:scrollView];
        }];

        [_previewView.scrollView addSubview:scrollView];
        if (i == index) {
            [UIView animateWithDuration:0.3 animations:^{
                _previewView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
                _previewView.pageControl.hidden = NO;
                [scrollView updateOriginRect];
            }];
        } else {
            [scrollView updateOriginRect];
        }
    }
    // 更新offset
    CGPoint offset = _previewView.scrollView.contentOffset;
    offset.x = index * k_screen_width;
    _previewView.scrollView.contentOffset = offset;
}

#pragma mark - 大图单击||长按
-(void)singleTapBigViewCallback:(MMScrollView *)scrollView
{
    [UIView animateWithDuration:0.3 animations:^{
        _previewView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        _previewView.pageControl.hidden = YES;
        scrollView.contentRect = scrollView.contentRect;
        scrollView.zoomScale = 1.0;
    } completion:^(BOOL finished) {
        [_previewView removeFromSuperview];
    }];
}

+(CGSize)cellAutoHeight:(NSString *)string {
    //展开后得高度(计算出文本内容的高度+固定控件的高度)
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    NSStringDrawingOptions option = (NSStringDrawingOptions)(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading);
    CGSize size = [string boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width- 20, 100000) options:option attributes:attribute context:nil].size;
    return size;
}
+(CGFloat)getOldImageSizeWithURL:(id)URL{
    UIImage *result;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
    result = [UIImage imageWithData:data];
    return result.size.height;
}
+(CGFloat)getImageSizeWithURL:(id)URL{
    NSURL * url = nil;
    if ([URL isKindOfClass:[NSURL class]]) {
        url = URL;
    }
    if ([URL isKindOfClass:[NSString class]]) {
        url = [NSURL URLWithString:URL];
    }
    if (!URL) {
        return 0;
    }
    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    CGFloat width = 0, height = 0;
    
    if (imageSourceRef) {
        
        // 获取图像属性
        CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, NULL);
        
        //以下是对手机32位、64位的处理
        if (imageProperties != NULL) {
            
            CFNumberRef widthNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
            
#if defined(__LP64__) && __LP64__
            if (widthNumberRef != NULL) {
                CFNumberGetValue(widthNumberRef, kCFNumberFloat64Type, &width);
            }
            
            CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
            
            if (heightNumberRef != NULL) {
                CFNumberGetValue(heightNumberRef, kCFNumberFloat64Type, &height);
            }
#else
            if (widthNumberRef != NULL) {
                CFNumberGetValue(widthNumberRef, kCFNumberFloat32Type, &width);
            }
            
            CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
            
            if (heightNumberRef != NULL) {
                CFNumberGetValue(heightNumberRef, kCFNumberFloat32Type, &height);
            }
#endif
            /***************** 此处解决返回图片宽高相反问题 *****************/
            // 图像旋转的方向属性
            NSInteger orientation = [(__bridge NSNumber *)CFDictionaryGetValue(imageProperties, kCGImagePropertyOrientation) integerValue];
            CGFloat temp = 0;
            switch (orientation) {  // 如果图像的方向不是正的，则宽高互换
                case UIImageOrientationLeft: // 向左逆时针旋转90度
                case UIImageOrientationRight: // 向右顺时针旋转90度
                case UIImageOrientationLeftMirrored: // 在水平翻转之后向左逆时针旋转90度
                case UIImageOrientationRightMirrored: { // 在水平翻转之后向右顺时针旋转90度
                    temp = width;
                    width = height;
                    height = temp;
                }
                    break;
                default:
                    break;
            }
            /***************** 此处解决返回图片宽高相反问题 *****************/
            
            CFRelease(imageProperties);
        }
        CFRelease(imageSourceRef);
    }
    return height;
}
+(UIView *)getMainView{
    UIView * view;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11) {
        view = [[UIApplication sharedApplication].windows firstObject];
    } else {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    return view;
}


+ (void)updateApp{
    kWeakSelf(self);
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", UPDATE_APP_URL, UPDATE_App_ID];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary *appInfoDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            if (error) {
                NSLog(@"%@", error.description);
                return;
            }
            NSArray *resultArray = [appInfoDict objectForKey:@"results"];
            if (![resultArray count]) {
                return;
            }
            NSDictionary *infoDict = [resultArray objectAtIndex:0];
            //获取服务器上应用的最新版本号－－－> connect获得的appstore版本号
            NSString * updateVersion = infoDict[@"version"];
            long updateVersionLong = [[updateVersion stringByReplacingOccurrencesOfString:@"." withString:@""] longLongValue];
            //获取当前设备中应用的版本号  －－－> 工程build的版本号
            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
            NSString * currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
            long currentVersionLong = [[currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""] longLongValue];
            //判断两个版本是否相同
            if (currentVersionLong  < updateVersionLong) {
                [SELUpdateAlert showUpdateAlertWithVersion:updateVersion Description:@"" focTag:NO];
            }
        }
    }];
    [dataTask resume];
}

//+(void)upDataPersionIP{
//    NSDictionary * userInfo = userManager.loadUserAllInfo;
//    NSDictionary * dic = @{@"username":kGetString(userInfo.username),
//                           @"gender":kGetString(userInfo.gender),
//                           @"photo":kGetString(userInfo.photo),
//                           @"birthday":kGetString(userInfo.birthday),
//                           @"site":kGetString(userInfo.site),
//                           };
//    [YX_MANAGER requestUpdate_userPOST:dic success:^(id object) {
//
//    }];
//}

+(Moment *)setTestInfo:(NSDictionary *)dic{
    NSMutableArray *commentList = nil;
    Moment *moment = [[Moment alloc] init];
    moment.praiseNameList = nil;
    moment.userName = dic[@"user_name"];
    moment.text = dic[@"title"];
    moment.detailText = dic[@"question"];
    moment.time = dic[@"publish_date"] ? [dic[@"publish_date"] longLongValue] : [dic[@"publish_time"] longLongValue];
    moment.singleWidth = ([[UIScreen mainScreen] bounds].size.width-30)/3;
    moment.singleHeight = 100;
    moment.location = @"";
    moment.isPraise = NO;
    moment.photo =dic[@"user_photo"];
    moment.startId = dic[@"id"];
    NSMutableArray * imgArr = [NSMutableArray array];
    if ([dic[@"pic1"] length] >= 5) {
        [imgArr addObject:dic[@"pic1"]];
    }
    if ([dic[@"pic2"] length] >= 5) {
        [imgArr addObject:dic[@"pic2"]];
    }
    if ([dic[@"pic3"] length] >= 5) {
        [imgArr addObject:dic[@"pic3"]];
    }
    moment.imageListArray = [NSMutableArray arrayWithArray:imgArr];
    moment.fileCount = imgArr.count;
    
    commentList = [[NSMutableArray alloc] init];
    int num = (int)[dic[@"answer"] count];
    for (int j = 0; j < num; j ++) {
        Comment *comment = [[Comment alloc] init];
        comment.userName = dic[@"answer"][j][@"user_name"];
        comment.text =  dic[@"answer"][j][@"answer"];
        comment.time = 1487649503;
        comment.pk = j;
        [commentList addObject:comment];
    }
    [moment setValue:commentList forKey:@"commentList"];
    return moment;
}
/**  */
+ (void)returnUpdateVersion
{
    NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/app/id%@", UPDATE_App_ID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}


//HTML适配图片文字
+ (NSString *)adaptWebViewForHtml:(NSString *) htmlStr{
    

    NSString * normalize = [[NSBundle mainBundle] pathForResource:@"normalize" ofType:@"css"];
    NSString * normalizeCss = [NSString stringWithFormat:@"<link href=\"%@\" type=\"text/css\" rel=\"stylesheet\">",normalize];
    NSString * style = [[NSBundle mainBundle] pathForResource:@"style" ofType:@"css"];
    NSString * styleCss = [NSString stringWithFormat:@"<link href=\"%@\" type=\"text/css\" rel=\"stylesheet\">",style];
    NSString * js =   [[NSBundle mainBundle] pathForResource:@"jquery" ofType:@"js"];
    NSString * jqjs = [NSString stringWithFormat:@"<script src=\"%@\">",js];
    
    NSMutableString *headHtml = [[NSMutableString alloc] initWithCapacity:0];
    [headHtml appendString : @"<!DOCTYPE html><html>" ];
    [headHtml appendString : @"<head>" ];
    
    [headHtml appendString : @"<meta name=\"viewport\" content=\"user-scalable=no\" />" ];
    [headHtml appendString : @"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />" ];
    [headHtml appendString : normalizeCss];
    [headHtml appendString : styleCss];
    [headHtml appendString : jqjs];
    
    [headHtml appendString : @"</script></head>"];

//
//    [headHtml appendString : @"<meta id=\"viewport\" name=\"viewport\" content=\"width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=false\" />" ];
//
//
//    [headHtml appendString : @"<meta name=\"apple-mobile-web-app-status-bar-style\" content=\"black\" />" ];
//    [headHtml appendString : @"<meta name=\"black\" name=\"apple-mobile-web-app-status-bar-style\" />" ];
//
//


//    //适配图片宽度，让图片宽度等于屏幕宽度
//    [headHtml appendString : @"<style>img{width:100%;}</style>" ];
//    [headHtml appendString : @"<style>img{height:auto;}</style>" ];
//
    //适配图片宽度，让图片宽度最大等于屏幕宽度
    //    [headHtml appendString : @"<style>img{max-width:100%;width:auto;height:auto;}</style>"];
    
    
    //适配图片宽度，如果图片宽度超过手机屏幕宽度，就让图片宽度等于手机屏幕宽度，高度自适应，如果图片宽度小于屏幕宽度，就显示图片大小
//    [headHtml appendString : @"<script type='text/javascript'>"
//     "window.onload = function(){\n"
//     "var maxwidth=document.body.clientWidth;\n" //屏幕宽度
//     "for(i=0;i <document.images.length;i++){\n"
//     "var myimg = document.images[i];\n"
//     "if(myimg.width > maxwidth){\n"
//     "myimg.style.width = '100%';\n"
//     "myimg.style.height = 'auto'\n;"
//     "}\n"
//     "}\n"
//     "}\n"
//     "</script>\n"];
    
//    [headHtml appendString : @"<style>table{width:100%;}</style>" ];
    [headHtml appendString : @"<body>" ];
    
    [headHtml appendString:htmlStr];
    
    NSString * article_editor =   [[NSBundle mainBundle] pathForResource:@"article_editor" ofType:@"js"];
    NSString * article_editorjs = [NSString stringWithFormat:@"<script type=\"text/javascript\" src=\"%@\" />",article_editor];
    [headHtml appendString:article_editorjs];

    [headHtml appendString:@"</body></html>"];
    return headHtml;
    
}

//这一步是分享图片
- (void)saveImage:(UITableView *)tableView{
    UIImage* viewImage = nil;
    UITableView *scrollView = tableView;
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, scrollView.opaque, 0.0);
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        
        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        viewImage = UIGraphicsGetImageFromCurrentImageContext();
        
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    kWeakSelf(self);
    //先上传到七牛云图片  再提交服务器
    [QiniuLoad uploadImageToQNFilePath:@[viewImage] success:^(NSString *reslut) {
        NSDictionary * userInfo = userManager.loadUserAllInfo;
        NSString * title = [NSString stringWithFormat:@"%@发布的内容@蓝皮书app",userInfo[@"username"]];
        NSString * desc = @"这篇内容真的很赞，快点开看!";
        [weakself pushShareViewAndDic:@{@"img":reslut,@"desc":desc,@"title":title,@"type":@"3"}];
    } failure:^(NSString *error) {}];
}




#pragma mark ========== 分享 ==========
- (void)pushShareViewAndDic:(NSDictionary *)shareDic{
    QMUIMoreOperationController *moreOperationController = [[QMUIMoreOperationController alloc] init];
    moreOperationController.cancelButton.hidden = NO;
    moreOperationController.isExtendBottomLayout = YES;
    moreOperationController.items = @[
                                      // 第一行
                                      @[
                                          [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareFriend") title:@"分享给微信好友" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                              [moreOperationController hideToBottom];
                                              [[ShareManager sharedShareManager] shareAllToPlatformType:UMSocialPlatformType_WechatSession obj:shareDic];
                                          }],
                                          [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareMoment") title:@"分享到朋友圈" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                              [moreOperationController hideToBottom];
                                              [[ShareManager sharedShareManager] shareAllToPlatformType:UMSocialPlatformType_WechatTimeLine obj:shareDic];
                                          }],
                                          [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_QQ") title:@"分享给QQ好友" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                              [moreOperationController hideToBottom];
                                              [[ShareManager sharedShareManager] shareAllToPlatformType:UMSocialPlatformType_QQ obj:shareDic];
                                          }],
//                                          [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareQzone") title:@"分享到QQ空间" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
//                                              [moreOperationController hideToBottom];
//                                              [[ShareManager sharedShareManager] shareAllToPlatformType:UMSocialPlatformType_Qzone obj:shareDic];
//                                          }],
                                          ],
                                      ];
    [moreOperationController showFromBottom];
}
+(CGFloat)getImageViewSize:(NSString *)imgUrl{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
    UIImage *showimage = [UIImage imageWithData:data];
    CGFloat scale = showimage.size.height/showimage.size.width;
    return [[UIScreen mainScreen] bounds].size.width * scale;
}


+ (NSMutableArray *)getSettleListWithBDArray2{
    
    
    NSArray *responsData = @[@"1",@"2",@"3"];
    
    NSMutableArray *resultArr = [NSMutableArray array];
    
    NSMutableArray *tmpArr = [NSMutableArray array];
    
    [self combine:0 :2 :responsData :resultArr :tmpArr];
    
    return resultArr;
}



+ (void)combine:(int)index :(NSInteger)k :(NSArray *)arr :(NSMutableArray *)resultArr :(NSMutableArray *)tmpArr{
    
    
    
    if(k == 1){
        for (int i = index; i < arr.count; i++) {
            
            
            [tmpArr addObject:arr[i]];
            
            [resultArr addObject:tmpArr];
            
            [tmpArr removeObject:arr[i]];
        }
    }else if(k > 1){
        
        
        for (int i = index; i <= arr.count - k; i++) {
            
            [tmpArr addObject:arr[i]]; //tmpArr都是临时性存储一下
            
            [self combine:i + 1 :k - 1 :arr :resultArr :tmpArr]; //索引右移，内部循环，自然排除已经选择的元素
            
            [tmpArr removeObject:arr[i]];  //tmpArr因为是临时存储的，上一个组合找出后就该释放空间，存储下一个元素继续拼接组合了
        }
        
        
    }else {
        return;
    }
    
    
    
}

//所有要接受的消息都走这里，方便管理。此方法已经验证正确
-(void)receiveAllKindsMessage:(NSDictionary *)messNewDic message:(NSMutableArray *)messages userInfoDic:(NSDictionary *)userInfoDic type:(int)type{
    if (messNewDic) {
        NSDictionary * dic = @{
                                            @"content":[messNewDic[@"content"] UnicodeToUtf81],
                                            @"date":kGetString(messNewDic[@"date"]),
                                            @"own_id":kGetString(messNewDic[@"own_id"]),
                                            @"aim_id":kGetString(messNewDic[@"aim_id"]),
                                            @"xxzid":kGetString(messNewDic[@"id"]),
                                            @"own_info":messNewDic[@"own_info"],
                                            @"aim_info":messNewDic[@"aim_info"]
                              };
           MessageModel *compareM = (MessageModel *)[[messages lastObject] message];
           //修改模型并且将模型保存数组
           MessageModel * messageModel = [[MessageModel alloc] init];
           messageModel.type = type;
           messageModel.text = dic[@"content"];
           messageModel.time = dic[@"date"];
           messageModel.photo = userInfoDic[@"photo"];
           messageModel.aim_id = dic[@"aim_id"];
           messageModel.own_id = dic[@"own_id"];
           messageModel.xxzid = dic[@"xxzid"];
           NSDictionary * userInfo = userManager.loadUserAllInfo;
           if (messageModel.type ==1) {
               messageModel.aim_info = [[ShareManager dicToString:dic[@"aim_info"]] replaceAll:@"\n" target:@""];
               messageModel.own_info = [[ShareManager dicToString:dic[@"own_info"]] replaceAll:@"\n" target:@""];
           }else{
               NSDictionary * aim_info = @{@"photo":userInfoDic[@"photo"],@"username":userInfoDic[@"username"]};
               messageModel.aim_info = [[ShareManager dicToString:aim_info] replaceAll:@"\n" target:@""];
               
               NSDictionary * own_info = @{@"photo":userInfo[@"photo"],@"username":userInfo[@"username"]};
               messageModel.own_info = [[ShareManager dicToString:own_info] replaceAll:@"\n" target:@""];
           }
             messageModel.hiddenTime = abs([messageModel.time intValue] - [compareM.time intValue] < 60);
             MessageFrameModel *mf = [[MessageFrameModel alloc] init];
             mf.message = messageModel;
             mf.isRead = YES;
             //只插入messagemodel
             JQFMDB *db = [JQFMDB shareDatabase];
             [db jq_inDatabase:^{
                 [YX_MANAGER.socketMessageArray removeAllObjects];
                 [db jq_insertTable:YX_USER_LiaoTian dicOrModel:messageModel];
             }];
            [messages addObject:mf];
    }
}
-(BOOL)getOwnDbMessage:(NSString *)own_id aim_id:(NSString *)aim_id other:(NSDictionary *)otherDic{
   NSDictionary * userInfo = userManager.loadUserAllInfo;
    BOOL messageBool1 = [kGetString(userInfo[@"id"]) integerValue] == [own_id integerValue] && [aim_id integerValue] == [otherDic[@"id"] integerValue];
    BOOL messageBool2 = [kGetString(userInfo[@"id"]) integerValue] == [aim_id integerValue] && [own_id integerValue] == [otherDic[@"id"] integerValue];
    return messageBool1 || messageBool2;
}
-(BOOL)getOwnListDbMessage:(NSString *)own_id aim_id:(NSString *)aim_id{
    NSDictionary * userInfo = userManager.loadUserAllInfo;
    BOOL messageBool1 = [kGetString(userInfo[@"id"]) integerValue] == [own_id integerValue];
    BOOL messageBool2 = [kGetString(userInfo[@"id"]) integerValue] == [aim_id integerValue];
    return messageBool1 || messageBool2;
}
-(void)setYinYing:(UIView *)view{
    // gradient
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.startPoint = CGPointMake(0, 1);//（0，0）表示从左上角开始变化。默认值是(0.5,0.0)表示从x轴为中间，y为顶端的开始变化
    layer.endPoint = CGPointMake(1, 1);//（1，1）表示到右下角变化结束。默认值是(0.5,1.0)  表示从x轴为中间，y为低端的结束变化
    layer.colors = [NSArray arrayWithObjects:(id)kRGBA(216, 200, 156,1).CGColor,(id)kRGBA(190, 168, 119, 1).CGColor,(id)kRGBA(176, 151, 99, 1).CGColor, nil];
    layer.locations = @[@0.0f,@0.6f,@1.0f];//渐变颜色的区间分布，locations的数组长度和color一致，这个值一般不用管它，默认是nil，会平均分布
    layer.frame = view.layer.bounds;
    [view.layer insertSublayer:layer atIndex:0];
}
-(void)qvXiaoYinYing:(UIView *)view{
    // gradient
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.startPoint = CGPointMake(0, 1);//（0，0）表示从左上角开始变化。默认值是(0.5,0.0)表示从x轴为中间，y为顶端的开始变化
    layer.endPoint = CGPointMake(1, 1);//（1，1）表示到右下角变化结束。默认值是(0.5,1.0)  表示从x轴为中间，y为低端的结束变化
    layer.colors = [NSArray arrayWithObjects:(id)kRGBA(64, 75, 84, 1).CGColor,(id)kRGBA(64, 75, 84, 1).CGColor,(id)kRGBA(64, 75, 84, 1).CGColor, nil];
    layer.locations = @[@0.0f,@0.6f,@1.0f];//渐变颜色的区间分布，locations的数组长度和color一致，这个值一般不用管它，默认是nil，会平均分布
    layer.frame = view.layer.bounds;
    [view.layer insertSublayer:layer atIndex:0];
}


+(void)setAllContentAttributed:(CGFloat)lineSpace inLabel:(UILabel *)label font:(UIFont *)font{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;  //设置行间距
    paragraphStyle.alignment = label.textAlignment;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:label.text attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle}];
    label.attributedText = attributedString;
}
+(CGFloat)inAllContentOutHeight:(NSString *)string contentWidth:(CGFloat)contentWidth lineSpace:(CGFloat)lineSpacing font:(UIFont *)font{
    if (string.length == 0 || [string isEqualToString:@""] ) { return 0;}
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = lineSpacing;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle};
    CGSize size = [string boundingRectWithSize:CGSizeMake(contentWidth, MAXFLOAT) options:
                   NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return  ceil(size.height);
}
-(NSString *)addImgURL:(NSString *)string{
    if ([string contains:IMG_URI]) {
        return string;
    }else{
        return [IMG_URI append:string];
    }
}


-(void)inGuanZhuMineStatusBtn:(UIButton *)btn{

    [btn setTitle:@"关注" forState:UIControlStateNormal];
    [btn setTitleColor:KWhiteColor forState:0];
    ViewRadius(btn, 16);
    UIImage *backImage = [self gradientImageWithBounds:btn.frame andColors:@[kRGBA(216, 200, 156, 1), kRGBA(190, 168, 119, 1), kRGBA(176, 151, 99, 1)] andGradientType:GradientDirectionLeftToRight];
    UIColor *bgColor = [UIColor colorWithPatternImage:backImage];
    [btn setBackgroundColor:bgColor];
    
}

/**
 *  @brief  生成渐变色图片
 *
 *  @param  bounds  图片的大小
 *  @param  colors      渐变颜色组
 *  @param  gradientType     渐变方向
 *
 *  @return 图片
 */
- (UIImage*)gradientImageWithBounds:(CGRect)bounds andColors:(NSArray*)colors andGradientType:(GradientDirection)gradientType{
    NSMutableArray *ar = [NSMutableArray array];
    
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(bounds.size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint startPt =  CGPointMake(0.0, 0.0);
    CGPoint endPt =  CGPointMake(0.0, 0.0);
    
    switch (gradientType) {
        case GradientDirectionTopToBottom:
            startPt= CGPointMake(0.0, 0.0);
            endPt= CGPointMake(0.0, bounds.size.height);
            break;
        case GradientDirectionLeftToRight:
            startPt = CGPointMake(0.0, 0.0);
            endPt = CGPointMake(bounds.size.width, 0.0);
            break;
        case GradientDirectionBottomToTop:
            startPt = CGPointMake(0.0, bounds.size.height);
            endPt = CGPointMake(0.0, 0.0);
            break;
        case GradientDirectionRightToLeft:
            startPt = CGPointMake(bounds.size.width, 0.0);
            endPt = CGPointMake(0, 0.0);
            break;
    }
    CGContextDrawLinearGradient(context, gradient, startPt, endPt, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}
-(void)inGuanZhuStatusBtn:(UIButton *)btn{
    [btn setTitle:@"关注" forState:UIControlStateNormal];
    [btn setTitleColor:KWhiteColor forState:0];
    [btn setBackgroundColor:SEGMENT_COLOR];
    ViewRadius(btn, 16);
}
-(void)inYiGuanZhuStatusBtn:(UIButton *)btn{
    [btn setTitle:@"已关注" forState:UIControlStateNormal];
    [btn setTitleColor:kRGBA(153, 153, 153, 1) forState:0];
    [btn setBackgroundColor:kRGBA(245, 245, 245, 1)];
    ViewRadius(btn, 16);
}
-(void)inHuXiangGuanZhuStatusBtn:(UIButton *)btn{
    [btn setTitle:@"互相关注" forState:UIControlStateNormal];
    [btn setTitleColor:SEGMENT_COLOR forState:0];
    [btn setBackgroundColor:kRGBA(245, 245, 245, 1)];
    ViewRadius(btn, 16);
}
@end
