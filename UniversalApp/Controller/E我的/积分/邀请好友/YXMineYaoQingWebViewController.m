//
//  YXMineYaoQingWebViewController.m
//  
//
//  Created by 小小醉 on 2019/9/19.
//

#import "YXMineYaoQingWebViewController.h"

@interface YXMineYaoQingWebViewController ()<WKNavigationDelegate>
@property (nonatomic,strong) NSString * weburl;
@end

@implementation YXMineYaoQingWebViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     self.navigationController.navigationBar.hidden = YES;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.weburl =  [NSString stringWithFormat:@"http://www.%@yaoqing.html",[API_URL split:@"api"][0]];
    self.url = self.weburl;
    self.webView.navigationDelegate = self;
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    // 拿到网页的实时url
    NSString *requestStr = [[request.URL absoluteString] stringByRemovingPercentEncoding];
    NSString * str = [self.weburl append:@"?type=one"];
    if([requestStr rangeOfString:str].location !=NSNotFound){

        NSLog(@"yes");
        NSArray *arr = [requestStr componentsSeparatedByString:@"="];
  
        return NO;
    }
    return YES;
}
#pragma mark --navigation delegate
//加载完毕
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.title = webView.title;
    [self updateProgress:webView.estimatedProgress];
    [self updateNavigationItems];
    
    NSString * url = [webView.URL absoluteString];
    if([url contains:@"type=one"]){
        [self yaoQingHaoYouAction];
    }
}
#pragma mark ========== 分享 ==========
- (void)yaoQingHaoYouAction{
    NSString * title = @"蓝皮书,品位生活指南@蓝皮书app";
      NSString * desc = @"Ta开启了蓝皮书之旅,快来加入吧";
      [[ShareManager sharedShareManager] pushShareViewAndDic:@{
          @"type":@"4",@"desc":desc,@"title":title,@"thumbImage":@"http://photo.lpszn.com/appiconWechatIMG1store_1024pt.png"}];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
