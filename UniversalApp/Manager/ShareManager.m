//
//  ShareManager.m
//  MiAiApp
//
//  Created by 徐阳 on 2017/6/1.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import "ShareManager.h"

@implementation ShareManager

SINGLETON_FOR_CLASS(ShareManager);

-(void)showShareView:(NSString *)obj{
    kWeakSelf(self);
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [weakself shareWebPageToPlatformType:platformType obj:obj];
    }];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType obj:(id)obj
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
//    NSString* thumbURL =  @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
    UIImage * thumbURL = [UIImage imageNamed:@"appicon"];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"The Good Life，分享美好生活方式的平台。" descr:@"【The Good Life APP】您的Ultimate生活方式平台。在这里，收录有如马六甲手杖，巴拿马草帽等小众精致产品的著名品牌安利和介绍，致力提供全面准确的国内外报价，每日精选的生活方式文章，以及西装与鞋子的颜色搭配手册、着装规范（Dress Code）、酒杯指南、雪茄环径测量等等一系列强大的实用工具。" thumImage:thumbURL];
    
    if (obj) {
        NSString * resultString = @"";
        NSString * user_name = [NSString stringWithFormat:@"user_name=%@",kGetString(obj[@"user_name"])];
        NSString * tag = [NSString stringWithFormat:@"tag=%@",obj[@"tag"]];
        
        NSString * photo =@"";
        NSString * photo1 = @"";
        NSString * photo2 = @"";
        NSString * photo3 =@"";
        NSString * describe =@"";
        NSString * question = @"";
        NSString * brand_name = @"";
        NSString * comment1 = @"";
        NSString * comment2 = @"";
        NSString * time = @"";;
        //足迹
        if ([obj[@"obj"] integerValue] == 4) {
            photo = [NSString stringWithFormat:@"photo=%@",kGetString(obj[@"user_photo"])];
            photo1 = [NSString stringWithFormat:@"photo1=%@",kGetString(obj[@"pic1"])];
            photo2 = [NSString stringWithFormat:@"photo2=%@",kGetString(obj[@"pic2"])];
            photo3 = [NSString stringWithFormat:@"photo3=%@",kGetString(obj[@"pic3"])];
            describe = [NSString stringWithFormat:@"describe=%@",[kGetString(obj[@"content"]) UnicodeToUtf8]];
            brand_name = [NSString stringWithFormat:@"brand_name=%@",kGetString(obj[@"cigar_info"][@"brand_name"])];
            if ([obj[@"comment_list"] count] == 0) {
                comment1 = @"";
                comment2 = @"";
            }else if ([obj[@"comment_list"] count] == 1) {
                comment1 = [NSString stringWithFormat:@"comment1=%@:%@",
                            kGetString(obj[@"comment_list"][0][@"user_name"]),
                            [kGetString(obj[@"comment_list"][0][@"comment"]) UnicodeToUtf8]];
                comment2 = @"";
            }else if ([obj[@"comment_list"] count] == 2) {
                comment1 = [NSString stringWithFormat:@"comment1=%@:%@",
                            kGetString(obj[@"comment_list"][0][@"user_name"]),
                            [kGetString(obj[@"comment_list"][0][@"comment"]) UnicodeToUtf8]];
                comment2 = [NSString stringWithFormat:@"comment2=%@:%@",
                            kGetString(obj[@"comment_list"][1][@"user_name"]),
                            [kGetString(obj[@"comment_list"][1][@"comment"]) UnicodeToUtf8]];
            }
            
            NSString * timeCopy =  [ShareManager timestampSwitchTime:[obj[@"publish_time"] integerValue] andFormatter:@""];
            time = [NSString stringWithFormat:@"time=%@",timeCopy];
        }else if ([obj[@"obj"] integerValue] == 3){
            photo = [NSString stringWithFormat:@"photo=%@",kGetString(obj[@"user_photo"])];
            photo1 = [NSString stringWithFormat:@"photo1=%@",kGetString(obj[@"pic1"])];
            photo2 = [NSString stringWithFormat:@"photo2=%@",kGetString(obj[@"pic2"])];
            photo3 = [NSString stringWithFormat:@"photo3=%@",kGetString(obj[@"pic3"])];
            describe = [NSString stringWithFormat:@"describe=%@",[kGetString(obj[@"title"]) UnicodeToUtf8]];
            brand_name = [NSString stringWithFormat:@"brand_name=%@",kGetString(obj[@"cigar_info"][@"brand_name"])];
            question = [NSString stringWithFormat:@"question=%@",[kGetString(obj[@"question"]) UnicodeToUtf8]];
            if ([obj[@"answer"] count] == 0) {
                comment1 = @"";
                comment2 = @"";
            }else if ([obj[@"answer"] count] == 1) {
                comment1 = [NSString stringWithFormat:@"comment1=%@:%@",
                            kGetString(obj[@"answer"][0][@"user_name"]),
                            [kGetString(obj[@"answer"][0][@"answer"]) UnicodeToUtf8]];
                comment2 = @"";
            }else if ([obj[@"answer"] count] == 2) {
                comment1 = [NSString stringWithFormat:@"comment1=%@:%@",
                            kGetString(obj[@"answer"][0][@"user_name"]),
                            [kGetString(obj[@"answer"][0][@"answer"]) UnicodeToUtf8]];
                comment2 = [NSString stringWithFormat:@"comment2=%@:%@",
                            kGetString(obj[@"answer"][1][@"user_name"]),
                            [kGetString(obj[@"answer"][1][@"answer"]) UnicodeToUtf8]];
            }
            
            NSString * timeCopy =  [ShareManager timestampSwitchTime:[obj[@"publish_time"] integerValue] andFormatter:@""];
            time = [NSString stringWithFormat:@"time=%@",timeCopy];
        }else{
            photo = [NSString stringWithFormat:@"photo=%@",kGetString(obj[@"photo"])];
            photo1 = [NSString stringWithFormat:@"photo1=%@",kGetString(obj[@"photo1"])];
            photo2 = [NSString stringWithFormat:@"photo2=%@",kGetString(obj[@"photo2"])];
            photo3 = [NSString stringWithFormat:@"photo3=%@",kGetString(obj[@"photo3"])];
            describe = [NSString stringWithFormat:@"describe=%@",[kGetString(obj[@"describe"]) UnicodeToUtf8]];
            brand_name = [NSString stringWithFormat:@"brand_name=%@",@""];
            comment1 = [NSString stringWithFormat:@"comment1=%@:%@",
                        kGetString(obj[@"user_name"]),
                        [kGetString(obj[@"max_hot_comment"][@"comment"]) UnicodeToUtf8]];
            comment2 = [NSString stringWithFormat:@"comment2=%@:%@",
                        kGetString(obj[@"user_name"]),
                        [kGetString(obj[@"max_hot_comment"][@"comment"]) UnicodeToUtf8]];
            NSString * timeCopy =  [ShareManager timestampSwitchTime:[obj[@"time"] integerValue] andFormatter:@""];
            time = [NSString stringWithFormat:@"time=%@",timeCopy];
        }
        resultString = [NSString stringWithFormat:@"%@&%@&%@&%@&%@&%@&%@&%@&%@&%@&%@&%@",
                        user_name,photo,photo1,photo2,photo3,describe,comment1,comment2,time,brand_name,tag,question];
        resultString = [resultString stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        //设置网页地址
        shareObject.webpageUrl = [@"http://www.thegdlife.com/jumpMarket.html?" append:resultString];
    }else{
        shareObject.webpageUrl = @"http://www.thegdlife.com/jumpMarket.html";

    }
  
    
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
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        //[self alertWithError:error];
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
//获取当前时间戳  （以毫秒为单位）

+(NSString *)getNowTimeTimestamp3{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    
    return timeSp;
    
}

//将某个时间戳转化成 时间

#pragma mark - 将某个时间戳转化成 时间

+(NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format{
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"MM-dd"]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
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
+(void)setGuanZhuStatus:(UIButton *)btn status:(BOOL)statusBool alertView:(BOOL)isAlertView{
     if (statusBool) {
        [btn setTitle:@"关注" forState:UIControlStateNormal];
         isAlertView ? [QMUITips showSucceed:@"取消关注成功"] : nil;
    }else{
        [btn setTitle:@"已关注" forState:UIControlStateNormal];
        isAlertView ?  [QMUITips showSucceed:@"关注成功"] : nil;

    }
    [btn setTitleColor:A_COlOR forState:0];
    [btn setBackgroundColor:KWhiteColor];
    ViewBorderRadius(btn, 5, 1, A_COlOR);
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

//添加轮播图
+(SDCycleScrollView *)setUpSycleScrollView:(NSMutableArray *)imageArray{
    
    NSMutableArray * photoArray = [NSMutableArray array];
    NSMutableArray * titleArray = [NSMutableArray array];
    
    SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 180) delegate:nil placeholderImage:[UIImage imageNamed:@"img_moren"]];
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
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:tfView.text];
    NSRange range1 = [[str string] rangeOfString:tag];
    [str addAttribute:NSForegroundColorAttributeName value:YXRGBAColor(10, 96, 254) range:range1];
    tfView.attributedText = str;
}
+(void)setLineSpace:(CGFloat)lineSpace withText:(NSString *)text inLabel:(UILabel *)label tag:(NSString *)tag{
    if (!text || !label) {
        return;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;  //设置行间距
    paragraphStyle.lineBreakMode = label.lineBreakMode;
    paragraphStyle.alignment = label.textAlignment;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    NSRange range1 = [text rangeOfString:tag];
    [attributedString addAttribute:NSForegroundColorAttributeName value:YXRGBAColor(10, 96, 254) range:range1];
    label.attributedText = attributedString;

    
    
}
+(void)setLineSpace_Price:(CGFloat)lineSpace withText:(NSString *)text inLabel:(UILabel *)label tag:(NSString *)tag{
    if (!text || !label) {
        return;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;  //设置行间距
    paragraphStyle.lineBreakMode = label.lineBreakMode;
    paragraphStyle.alignment = label.textAlignment;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    NSRange range1 = [text rangeOfString:tag];
    [attributedString addAttribute:NSForegroundColorAttributeName value:YXRGBAColor(255, 51, 51) range:range1];
    label.attributedText = attributedString;
    
    
    
}
+(CGFloat)inTextOutHeight:(NSString *)string lineSpace:(CGFloat)lineSpacing fontSize:(CGFloat)fontSize{
    if (string.length == 0) {
        return 0;
    }
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSKernAttributeName:@(9)}];
    paraStyle.lineSpacing = lineSpacing;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paraStyle,NSParagraphStyleAttributeName:attributedString};
    CGSize size = [string boundingRectWithSize:CGSizeMake(KScreenWidth-20, MAXFLOAT) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return  ceil(size.height);
}
+ (void)setBorderinView:(UIView *)view{
    view.layer.borderColor = [[UIColor borderColor] CGColor];
    view.layer.borderWidth = 0.8;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 7;
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
    CGSize size = [string boundingRectWithSize:CGSizeMake(KScreenWidth- 20, 100000) options:option attributes:attribute context:nil].size;
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

+(void)upDataPersionIP{
    UserInfo *userInfo = curUser;
    NSDictionary * dic = @{@"username":kGetString(userInfo.username),
                           @"gender":kGetString(userInfo.gender),
                           @"photo":kGetString(userInfo.photo),
                           @"birthday":kGetString(userInfo.birthday),
                           @"site":kGetString(userInfo.site),
                           };
    [YX_MANAGER requestUpdate_userPOST:dic success:^(id object) {
        
    }];
}

+(Moment *)setTestInfo:(NSDictionary *)dic{
    NSMutableArray *commentList = nil;
    Moment *moment = [[Moment alloc] init];
    moment.praiseNameList = nil;
    moment.userName = dic[@"user_name"];
    moment.text = dic[@"title"];
    moment.detailText = dic[@"question"];
    moment.time = dic[@"publish_date"] ? [dic[@"publish_date"] longLongValue] : [dic[@"publish_time"] longLongValue];
    moment.singleWidth = (KScreenWidth-30)/3;
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
    
    NSMutableString *headHtml = [[NSMutableString alloc] initWithCapacity:0];
    [headHtml appendString : @"<html>" ];
    
    [headHtml appendString : @"<head>" ];
    
    [headHtml appendString : @"<meta charset=\"utf-8\">" ];
    
    [headHtml appendString : @"<meta id=\"viewport\" name=\"viewport\" content=\"width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=false\" />" ];
    
    [headHtml appendString : @"<meta name=\"apple-mobile-web-app-capable\" content=\"yes\" />" ];
    
    [headHtml appendString : @"<meta name=\"apple-mobile-web-app-status-bar-style\" content=\"black\" />" ];
    
    [headHtml appendString : @"<meta name=\"black\" name=\"apple-mobile-web-app-status-bar-style\" />" ];
    
    //适配图片宽度，让图片宽度等于屏幕宽度
    //[headHtml appendString : @"<style>img{width:100%;}</style>" ];
    //[headHtml appendString : @"<style>img{height:auto;}</style>" ];
    
    //适配图片宽度，让图片宽度最大等于屏幕宽度
    //    [headHtml appendString : @"<style>img{max-width:100%;width:auto;height:auto;}</style>"];
    
    
    //适配图片宽度，如果图片宽度超过手机屏幕宽度，就让图片宽度等于手机屏幕宽度，高度自适应，如果图片宽度小于屏幕宽度，就显示图片大小
    [headHtml appendString : @"<script type='text/javascript'>"
     "window.onload = function(){\n"
     "var maxwidth=document.body.clientWidth;\n" //屏幕宽度
     "for(i=0;i <document.images.length;i++){\n"
     "var myimg = document.images[i];\n"
     "if(myimg.width > maxwidth){\n"
     "myimg.style.width = '100%';\n"
     "myimg.style.height = 'auto'\n;"
     "}\n"
     "}\n"
     "}\n"
     "</script>\n"];
    
    [headHtml appendString : @"<style>table{width:100%;}</style>" ];
    [headHtml appendString : @"<title>webview</title>" ];
    NSString *bodyHtml;
    bodyHtml = [NSString stringWithString:headHtml];
    bodyHtml = [bodyHtml stringByAppendingString:htmlStr];
    return bodyHtml;
    
}
@end
