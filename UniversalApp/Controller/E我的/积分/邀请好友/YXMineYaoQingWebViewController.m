//
//  YXMineYaoQingWebViewController.m
//  
//
//  Created by 小小醉 on 2019/9/19.
//

#import "YXMineYaoQingWebViewController.h"

@interface YXMineYaoQingWebViewController ()<WKNavigationDelegate>

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
    self.url = @"http://192.168.101.21:63340/%E7%9F%A9%E5%BD%A2%E6%8A%BD%E5%A5%96%E6%B4%BB%E5%8A%A8html/yaoqing.html";
    self.webView.navigationDelegate = self;
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    // 拿到网页的实时url
    NSString *requestStr = [[request.URL absoluteString] stringByRemovingPercentEncoding];
    if([requestStr rangeOfString:@"http://192.168.101.21:63340/%E7%9F%A9%E5%BD%A2%E6%8A%BD%E5%A5%96%E6%B4%BB%E5%8A%A8html/yaoqing.html?type=one"].location !=NSNotFound){
        
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
    QMUIMoreOperationController *moreOperationController = [[QMUIMoreOperationController alloc] init];
    moreOperationController.items = @[
                                      // 第一行
                                      @[
                                          [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareFriend") title:@"分享给微信好友" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                              [moreOperationController hideToBottom];
                                              [[ShareManager sharedShareManager] shareYaoQingHaoYouToPlatformType:UMSocialPlatformType_WechatSession];
                                          }],
                                          [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareMoment") title:@"分享到朋友圈" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                              [moreOperationController hideToBottom];
                                              [[ShareManager sharedShareManager] shareYaoQingHaoYouToPlatformType:UMSocialPlatformType_WechatTimeLine];
                                          }],
                                          [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_QQ") title:@"分享给QQ好友" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                              [moreOperationController hideToBottom];
                                              [[ShareManager sharedShareManager] shareYaoQingHaoYouToPlatformType:UMSocialPlatformType_QQ];
                                          }],
                                          [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareQzone") title:@"分享到QQ空间" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                              [moreOperationController hideToBottom];
                                              [[ShareManager sharedShareManager] shareYaoQingHaoYouToPlatformType:UMSocialPlatformType_Qzone];
                                          }],
                                          ],
                                      ];
    [moreOperationController showFromBottom];
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
