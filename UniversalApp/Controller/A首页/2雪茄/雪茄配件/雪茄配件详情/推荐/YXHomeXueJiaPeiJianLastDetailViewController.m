//
//  YXHomeXueJiaPeiJianLastDetailViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/15.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaPeiJianLastDetailViewController.h"
#import "SDCycleScrollView.h"
#import "QMUITextView.h"

@interface YXHomeXueJiaPeiJianLastDetailViewController ()<SDCycleScrollViewDelegate,UIWebViewDelegate>{
    CGFloat tagHeight;
}
@property(nonatomic, strong) QMUITextView * qmuiTextView;
@property(nonatomic, strong) QMUITextView * spxxqmuiTextView;

@end

@implementation YXHomeXueJiaPeiJianLastDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=false;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.title = self.dic[@"name"];
    
    [self setUpSycleScrollView:[NSArray arrayWithArray:self.dic[@"photo_list"]]];
    self.priceLbl.text = kGetString(self.dic[@"price"]);
    self.titleLbl.text = self.dic[@"name"];
    
    
    
    //获取bundlePath 路径
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    //获取本地html目录 basePath
    NSString *basePath = [NSString stringWithFormat:@"%@/%@",bundlePath,@"html"];
    //获取本地html目录 baseUrl
    NSURL *baseUrl = [NSURL fileURLWithPath: basePath isDirectory: YES];
    //显示内容
    if (self.dic[@"info"] && [self.dic[@"info"] length] > 0) {
        [self.webView loadHTMLString:[self adaptWebViewForHtml:self.dic[@"info"]] baseURL: baseUrl];
    }
    
}
- (void)webViewDidFinishLoad:(UIWebView *)wb{
    tagHeight = [[wb stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    [self.tableView reloadData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tagHeight;
}
//HTML适配图片文字
- (NSString *)adaptWebViewForHtml:(NSString *) htmlStr{
    
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
-(void)shangpinxinxi{
    self.shangpinxinxiLbl.numberOfLines = 0;
    self.shangpinxinxiLbl.lineBreakMode = UILineBreakModeWordWrap;
    NSString *str = [self.dic[@"info"] stringByReplacingOccurrencesOfString: @"\\n" withString:@"\n"];
    self.shangpinxinxiLbl.text = str ;
    
    
    
}
//添加轮播图
- (void)setUpSycleScrollView:(NSArray *)imageArray{
    
    NSMutableArray * photoArray = [NSMutableArray array];
    NSMutableArray * titleArray = [NSMutableArray array];
    
    for (NSDictionary * dic in imageArray) {
        [photoArray addObject:dic[@"photo"]];
    }
    SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KScreenWidth, 180) delegate:self placeholderImage:[UIImage imageNamed:@""]];
    cycleScrollView3.centerX = self.titleView.centerX;
    cycleScrollView3.bannerImageViewContentMode =  1;
    cycleScrollView3.showPageControl = NO;
    cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    cycleScrollView3.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    cycleScrollView3.autoScrollTimeInterval = 4;
    cycleScrollView3.titlesGroup = titleArray;
    cycleScrollView3.backgroundColor = KWhiteColor;
    cycleScrollView3.imageURLStringsGroup = [NSArray arrayWithArray:photoArray];
    [self.titleView addSubview:cycleScrollView3];
}
- (IBAction)addCarShopAction:(id)sender {
    //[QMUITips showInfo:SHOW_FUTURE_DEV inView:self.view hideAfterDelay:1];

}
- (IBAction)buyAction:(id)sender {
    //[QMUITips showInfo:SHOW_FUTURE_DEV inView:self.view hideAfterDelay:1];

}

@end
