//
//  YXHomePeiJianLastView.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/4/14.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomePeiJianLastView.h"
#import "XHStarRateView.h"
#import "QMUIGridView.h"
#import "MMImageListView.h"
#import "MMImagePreviewView.h"
#import "YXHomeLastListTableViewCell.h"

@interface YXHomePeiJianLastView ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>{
    NSInteger _imageCount;
    CGFloat tagHeight;
}
@property(nonatomic)QMUIGridView * gridView;
// 预览视图
@property (nonatomic, strong) MMImagePreviewView *previewView;
@end
@implementation YXHomePeiJianLastView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (void)awakeFromNib{
    [super awakeFromNib];
    //使用一个字典同时设置字体大小和背景色在某种状态下
    _previewView = [[MMImagePreviewView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    ViewBorderRadius(self.scoreView, 3, 1, YXRGBAColor(200, 200, 200));
    ViewBorderRadius(self.self.lastSixPhotoView, 3, 1, YXRGBAColor(200, 200, 200));
    
    
    
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 4.0f);
    self.progress1.transform = transform;//设定宽高
    self.porgress2.transform = transform;//设定宽高
    self.progress3.transform = transform;//设定宽高
    
    /*
     //外观
     [self fiveStarView:5 view:self.lastWaiGuanFiveView];
     //燃烧
     [self fiveStarView:5 view:self.lastRanShaoFiveView];
     //香味
     [self fiveStarView:5 view:self.lastXiangWeiFiveView];
     //口感
     [self fiveStarView:5 view:self.lastKouGanFiveView];
     //总分的五颗星
     [self fiveStarView:5 view:self.lastAllScoreFiveView];
     */
    [self.listTableView registerNib:[UINib nibWithNibName:@"YXHomeLastListTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXHomeLastListTableViewCell"];
    
    self.listData = [NSMutableArray array];
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    
    
    
}
- (void)webViewDidFinishLoad:(UIWebView *)wb{
    tagHeight = [[wb stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXHomeLastListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXHomeLastListTableViewCell" forIndexPath:indexPath];
    NSDictionary * dic = self.listData[indexPath.row];
    cell.nameLbl.text = dic.allKeys[0];
    cell.valueLbl.text = dic[dic.allKeys[0]];
    
    return cell;
}

-(void)againSetDetailView:(NSDictionary *)startDic {
    
    [self setUpSycleScrollView:[NSArray arrayWithArray:startDic[@"photo_list"]]];
    
        self.webViewHeight.constant = 100;
        self.yxWebView.hidden = NO;
        //获取bundlePath 路径
        NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
        //获取本地html目录 basePath
        NSString *basePath = [NSString stringWithFormat:@"%@/%@",bundlePath,@"html"];
        //获取本地html目录 baseUrl
        NSURL *baseUrl = [NSURL fileURLWithPath: basePath isDirectory: YES];
        //显示内容
        if (startDic[@"info"] && [startDic[@"info"] length] > 0) {
            [self.yxWebView loadHTMLString:[self adaptWebViewForHtml:startDic[@"info"]] baseURL: baseUrl];
        }
        //头图片
        NSString * string =[startDic[@"photo_list"] count] > 0 ? startDic[@"photo_list"][0][@"photo"] : @"";
        NSString * str = [(NSMutableString *)string replaceAll:@" " target:@"%20"];
        str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if (str) {
            [self.lastImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@""]];
        }
    
    NSString * string123 = @"暂无售价";
    NSString * str1 = @"";
    NSString * str2 = @"";
    NSString * str3 = @"";
    
        str1 = [kGetString(startDic[@"price_a"]) isEqualToString:@"0"] ? string123 : kGetString(startDic[@"price_a"]) ;
        str2 = [kGetString(startDic[@"price_b"]) isEqualToString:@"0"] ? string123 :
        kGetString(startDic[@"price_b"]);
        str3 = [kGetString(startDic[@"price_c"]) isEqualToString:@"0"] ? string123 :
        kGetString(startDic[@"price_c"]);
        self.store1.text =   kGetString(startDic[@"store_a"]);
        self.store2.text =   kGetString(startDic[@"store_b"]);
        self.store3.text =   kGetString(startDic[@"store_c"]);

    
    
    //头名字
    self.lastTitleLbl.text = kGetString(startDic[@"name"]);
    //国内售价
    self.lastPrice1Lbl.text = str1;
    //香港PCC
    self.lastPrice2Lbl.text = str2;
    //比站
    self.lastPrice3Lbl.text = str3;
}
-(void)fiveStarViewUIAllDataDic_PingJunFen:(NSDictionary *)allDataDic{
    /*
     //总分的五颗星
     [self fiveStarView:nsstringToFloat(allDataDic[@"average_score__avg"]) view:self.lastAllScoreFiveView];
     */
    
    
    NSString * str1 = kGetString(allDataDic[@"is_recommend_number"]);
    NSString * str2 = kGetString(allDataDic[@"neutrality_number"]);
    NSString * str3 = kGetString(allDataDic[@"dont_recommend_number"]);
    NSString * sum = kGetString(allDataDic[@"sum"]);
    
    //推荐指数
    double average_score = [str1 doubleValue] / [sum doubleValue];
    self.tuijianAll.text = [NSString stringWithFormat:@"%.0f%%",average_score*100];
    NSString * replace = @"(nan%)";
    if ([self.tuijianAll.text isEqualToString:@"nan%"]) {
        self.tuijianAll.text = @"0%";
    }
    //推荐
    double average_score1 = [str1 doubleValue] / [sum doubleValue];
  
    self.lbl1score.text = [NSString stringWithFormat:@"(%.0f%%)",average_score1*100];
    if ([self.lbl1score.text isEqualToString:replace]) {
        self.lbl1score.text = @"0%";
    }
    self.lbl1people.text = [NSString stringWithFormat:@"(%@人)",str1];
    self.progress1.progress = average_score1;
    //中立
    double average_score2 = [str2 doubleValue] / [sum doubleValue];
  
        self.lbl2score.text = [NSString stringWithFormat:@"(%.0f%%)",average_score2*100];
    if ([self.lbl2score.text isEqualToString:replace]) {
        self.lbl2score.text = @"0%";
    }
    self.lbl2people.text = [NSString stringWithFormat:@"(%@人)",str2];
    self.porgress2.progress = average_score2;
    
    //不推荐
    double average_score3 = [str3 doubleValue] / [sum doubleValue];

        self.lbl3score.text = [NSString stringWithFormat:@"(%.0f%%)",average_score3*100];
    if ([self.lbl3score.text isEqualToString:replace]) {
        self.lbl3score.text = @"0%";
    }
    self.lbl3people.text = [NSString stringWithFormat:@"(%@人)",str3];
    self.progress3.progress = average_score3;
    
    
}
-(void)fiveStarViewUIAllDataDic_GeRenFen:(NSDictionary *)allDataDic{
    /*
     //外观
     [self fiveStarView:nsstringToFloat(allDataDic[@"out_looking__avg"]) view:self.lastWaiGuanFiveView];
     //燃烧
     [self fiveStarView:nsstringToFloat(allDataDic[@"burn__avg"]) view:self.lastRanShaoFiveView];
     //香味
     [self fiveStarView:nsstringToFloat(allDataDic[@"fragrance__avg"]) view:self.lastXiangWeiFiveView];
     //口感
     [self fiveStarView:nsstringToFloat(allDataDic[@"mouthfeel__avg"]) view:self.lastKouGanFiveView];
     */
}
-(void)fiveStarView:(CGFloat)score view:(UIView *)view{
    XHStarRateView *starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    starRateView.currentScore = score;
    starRateView.isAnimation = YES;
    starRateView.rateStyle = IncompleteStar;
    starRateView.tag = 1;
    [view addSubview:starRateView];
    starRateView.userInteractionEnabled = NO;
}

- (IBAction)lastMyTalkAction:(id)sender {
    if (self.delegate  && [self.delegate respondsToSelector:@selector(clickMyTalkAction)]) {
        [self.delegate clickMyTalkAction];
    }
}
- (IBAction)lastSearchAllAction:(id)sender {
    self.searchAllBlock();
}
- (IBAction)lastSegmentAction:(UISegmentedControl *)sender{
    self.block(sender.selectedSegmentIndex);
}



- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
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
//添加轮播图
- (void)setUpSycleScrollView:(NSArray *)imageArray{
    
    NSMutableArray * photoArray = [NSMutableArray array];
    NSMutableArray * titleArray = [NSMutableArray array];
    
    for (NSDictionary * dic in imageArray) {
        [photoArray addObject:dic[@"photo"]];
    }
    
    SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 180) shouldInfiniteLoop:NO imageNamesGroup:[NSArray arrayWithArray:imageArray]];
    
    
    //    SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KScreenWidth, 180) delegate:self placeholderImage:[UIImage imageNamed:@""]];
    cycleScrollView3.centerX = self.titleView.centerX;
    cycleScrollView3.bannerImageViewContentMode =  1;
    cycleScrollView3.showPageControl = YES;
    cycleScrollView3.autoScrollTimeInterval = 1;
    cycleScrollView3.titlesGroup = titleArray;
    cycleScrollView3.backgroundColor = KWhiteColor;
    cycleScrollView3.imageURLStringsGroup = [NSArray arrayWithArray:photoArray];
    
    
    cycleScrollView3.currentPageDotColor =  kRGBA(12, 36, 45, 1.0);
    cycleScrollView3.showPageControl = YES;
    cycleScrollView3.autoScrollTimeInterval = 10000;
    cycleScrollView3.pageDotColor = YXRGBAColor(239, 239, 239);
    cycleScrollView3.backgroundColor = KWhiteColor;
    cycleScrollView3.pageControlBottomOffset = -40;
    [self.titleView addSubview:cycleScrollView3];
}
@end
