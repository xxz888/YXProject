//
//  YXHomeNewsDetailViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/30.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeNewsDetailViewController.h"

@interface YXHomeNewsDetailViewController ()<WKNavigationDelegate>

@end

@implementation YXHomeNewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _webDic[@"title"];
    self.webView.navigationDelegate = self;
    self.webView.frame =  CGRectMake(5, 0, KScreenWidth-10, KScreenHeight-kTopHeight-34);
    // 去掉webView的滚动条
    for (UIView *subView in [self.webView subviews])
    {
        if ([subView isKindOfClass:[UIScrollView class]])
        {
            // 不显示竖直的滚动条
            [(UIScrollView *)subView setShowsVerticalScrollIndicator:NO];
        }
    }
    //获取bundlePath 路径
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    //获取本地html目录 basePath
    NSString *basePath = [NSString stringWithFormat:@"%@/%@",bundlePath,@"html"];
    //获取本地html目录 baseUrl
    NSURL *baseUrl = [NSURL fileURLWithPath: basePath isDirectory: YES];
        NSLog(@"%@", baseUrl);
    //html 路径
    NSString *indexPath = [NSString stringWithFormat:@"%@/HomeNewsDetail.html",basePath];
    //html 文件中内容
    //NSString *indexContent = [NSString stringWithContentsOfFile: indexPath encoding: NSUTF8StringEncoding error:nil];
    NSString * html = [NSString stringWithFormat:@"<html> \n"
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
                       "</html>",_webDic[@"details"]];
    //显示内容
    [self.webView loadHTMLString:html baseURL: baseUrl];
}
#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSString * vss = [[self dictionaryToJson:_webDic] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    vss = [NSString stringWithFormat:@"callJs('%@')",vss];
    [self.webView evaluateJavaScript:vss completionHandler:nil];
}

#pragma mark 字典转化字符串
-(NSString*)dictionaryToJson:(NSDictionary *)dic{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
@end
