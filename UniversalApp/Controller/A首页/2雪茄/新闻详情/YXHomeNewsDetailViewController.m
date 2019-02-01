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
    self.webView.frame =  CGRectMake(0, 0, KScreenWidth, KScreenHeight-kTopHeight);
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
    NSString *indexContent = [NSString stringWithContentsOfFile: indexPath encoding: NSUTF8StringEncoding error:nil];
    //显示内容
    [self.webView loadHTMLString: indexContent baseURL: baseUrl];
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
