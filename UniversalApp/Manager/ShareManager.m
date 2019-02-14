//
//  ShareManager.m
//  MiAiApp
//
//  Created by 徐阳 on 2017/6/1.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import "ShareManager.h"
#import <UShareUI/UShareUI.h>
#import "UIColor+MyColor.h"
#import "MMImageListView.h"
@implementation ShareManager

SINGLETON_FOR_CLASS(ShareManager);

-(void)showShareView{
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self shareWebPageToPlatformType:platformType];
    }];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL =  @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"欢迎使用【友盟+】社会化组件U-Share" descr:@"欢迎使用【友盟+】社会化组件U-Share，SDK包最小，集成成本最低，助力您的产品开发、运营与推广！" thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = @"http://mobile.umeng.com/social";
    
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
        [self alertWithError:error];
    }];
}

- (void)alertWithError:(NSError *)error
{
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"Share succeed"];
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"share"
                                                    message:result
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"sure", @"确定")
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
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    
    
    //NSLog(@"&&&&&&&confromTimespStr = : %@",confromTimespStr);
    
    
    
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
+(void)setGuanZhuStatus:(UIButton *)btn status:(BOOL)statusBool{
    UIColor * color1 = [UIColor darkGrayColor];
     if (statusBool) {
        [btn setTitle:@"关注" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:0];
        [btn setBackgroundColor:KWhiteColor];
        ViewBorderRadius(btn, 5, 1, color1);

    }else{
        [btn setTitle:@"已关注" forState:UIControlStateNormal];
        [btn setTitleColor:KWhiteColor forState:0];
        [btn setBackgroundColor:YXRGBAColor(255, 51, 51)];
        ViewBorderRadius(btn, 5, 0, KClearColor);
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

+(void)inTextViewOutDifColorView:(UITextView *)tfView tag:(NSString *)tag{
    
    //创建 NSMutableAttributedString
    NSMutableAttributedString *attributedStr01 = [[NSMutableAttributedString alloc] initWithString: tfView.text];
    //给所有字符设置字体为Zapfino，字体高度为15像素
    [attributedStr01 addAttribute: NSFontAttributeName
                            value:[UIFont systemFontOfSize:13]
                            range: NSMakeRange(tfView.text.length-tag.length, tag.length)];
    [attributedStr01 addAttribute: NSForegroundColorAttributeName value: YXRGBAColor(10, 96, 254) range: NSMakeRange(tfView.text.length-tag.length,tag.length )];
    
    //赋值给显示控件label01的 attributedText
    tfView.attributedText = attributedStr01;
}
+(void)inTextFieldOutDifColorView:(UILabel *)tfView tag:(NSString *)tag{
    
    //创建 NSMutableAttributedString
    NSMutableAttributedString *attributedStr01 = [[NSMutableAttributedString alloc] initWithString: tfView.text];
    //给所有字符设置字体为Zapfino，字体高度为15像素
    [attributedStr01 addAttribute: NSFontAttributeName
                            value:[UIFont systemFontOfSize:13]
                            range: NSMakeRange(tfView.text.length-tag.length, tag.length)];
    [attributedStr01 addAttribute: NSForegroundColorAttributeName value: YXRGBAColor(10, 96, 254) range: NSMakeRange(tfView.text.length-tag.length,tag.length )];
    
    //赋值给显示控件label01的 attributedText
    tfView.attributedText = attributedStr01;
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
@end
