//
//  YXHomeLastDetailView.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/9.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeLastDetailView.h"
#import "XHStarRateView.h"
#import "QMUIGridView.h"
#import "MMImageListView.h"
#import "MMImagePreviewView.h"
#import "YXHomeLastListTableViewCell.h"

@interface YXHomeLastDetailView ()<UITableViewDataSource,UITableViewDelegate>{
    NSInteger _imageCount;
}
@property(nonatomic)QMUIGridView * gridView;
// 预览视图
@property (nonatomic, strong) MMImagePreviewView *previewView;
@end
@implementation YXHomeLastDetailView

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

    //listview
    [self.listData removeAllObjects];
    if (startDic[@"argument"]) {
        NSString * fenhaoString = kGetString(startDic[@"argument"]);
        NSArray * fenhaoArray = [fenhaoString split:@";"];
        for (NSInteger i = 0 ; i < [fenhaoArray count] ; i++) {
            NSArray * konggeArray = [fenhaoArray[i] split:@","];
            NSString * listKey;
            NSString * listValue;
            if (konggeArray.count > 0) {
                listKey = konggeArray[0];
                listValue = @"";
            }
            if (konggeArray.count > 1) {
                listKey = konggeArray[0];
                listValue = konggeArray[1];
            }
            
            [self.listData addObject:@{listKey:listValue}];

        }
//        NSDictionary * dic = [self dictionaryWithJsonString:kGetString(startDic[@"argument"])];
//        for (NSString * key in dic) {
//            NSString * listKey = [key UnicodeToUtf8];
//            NSString * listValue = [[dic objectForKey:key] UnicodeToUtf8];
//            [self.listData addObject:@{listKey:listValue}];
//        }
    }
    [self.listTableView reloadData];
    self.listViewHeight.constant = self.listData.count * 40 + 40;
    //头图片
    NSString * string =[startDic[@"photo_list_details"] count] > 0 ? startDic[@"photo_list_details"][0][@"photo_url"] : @"";
    NSString * str = [(NSMutableString *)string replaceAll:@" " target:@"%20"];
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (str) {
        [self.lastImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@""]];
    }
    
    
    NSString * string123 = @"暂无售价";
    NSString * str1 = [kGetString(startDic[@"price_single_china"]) isEqualToString:@"0"] ? string123 : kGetString(startDic[@"price_single_china"]) ;
    
    NSString * str2 = [kGetString(startDic[@"price_single_hongkong"]) isEqualToString:@"0"] ? string123 :
    kGetString(startDic[@"price_single_hongkong"]);
    
    NSString * str3 = [kGetString(startDic[@"price_single_overseas"]) isEqualToString:@"0"] ? string123 :
    kGetString(startDic[@"price_single_overseas"]);
    
    
    //头名字
    self.lastTitleLbl.text = kGetString(startDic[@"cigar_name"]);
    //国内售价
    self.lastPrice1Lbl.text = str1;
    //香港PCC
    self.lastPrice2Lbl.text = str2;
    //比站
    self.lastPrice3Lbl.text = str3;
    //品牌
    self.lastPinPaiLbl.text = kGetString(startDic[@"cigar_brand"]);
    //环径
    self.lastHuanJingLbl.text = kGetString(startDic[@"ring_gauge"]);
    //长度
    self.lastChangDuLbl.text = kGetString(startDic[@"length"]);
    //口味
    self.lastXiangWeiLbl.text = kGetString(startDic[@"flavour"]);
    //中文名
    self.zhongwenName.text = kGetString(startDic[@"cigar_name_CN"]);
    //形状
    self.xingzhuangLbl.text = kGetString(startDic[@"shape"]);
    //浓度
    self.nongduLbl.text = kGetString(startDic[@"strength"]);
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


-(void)setSixPhotoView:(NSMutableArray *)imageArray{
    _imageCount = imageArray.count;
    [self sixPhotoviewValue:imageArray];
}
-(void)sixPhotoviewValue:(NSMutableArray *)imageArray{
    [self.lastSixPhotoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (!self.gridView) {
        self.gridView = [[QMUIGridView alloc] init];
    }
    CGFloat height = 0.0;
    if (imageArray.count == 0) {
        height = 0;
        self.searchAllView.hidden = YES;
        self.searchAllRowHeight.constant = 0;
    }
    if (imageArray.count >0 && imageArray.count <=3) {
        height = 100;
        self.searchAllView.hidden = NO;
        self.searchAllRowHeight.constant = 40;
    }
    if (imageArray.count > 4) {
        height = 200;
        self.searchAllView.hidden = NO;
        self.searchAllRowHeight.constant = 40;
    }

    NSInteger count = imageArray.count;
    self.gridView.frame = CGRectMake(0, 0, self.lastSixPhotoView.frame.size.width, height);
    [self.lastSixPhotoView addSubview:self.gridView];
    self.sixViewHeight.constant = height;
    self.gridView.columnCount = 3;
    self.gridView.rowHeight = height;
    self.gridView.separatorWidth = 5;
    self.gridView.separatorColor = KClearColor;
    self.gridView.separatorDashed = NO;
    
    for (NSInteger i = 0; i < count; i++) {
        MMImageView *imageView = [[MMImageView alloc]initWithFrame:CGRectMake(0,0 , self.gridView.frame.size.width, self.gridView.frame.size.height)];
        imageView.tag = 1000 + i;
        [imageView setContentMode:UIViewContentModeScaleToFill];
        NSString * str = [(NSMutableString *)imageArray[i] replaceAll:@" " target:@"%20"];
        [imageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_moren"]];
        [self.gridView addSubview:imageView];
        imageView.tag = i;
        //view添加点击事件
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [imageView addGestureRecognizer:tapGesturRecognizer];
    }
}


-(void)tapAction:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIView *views = (UIView*) tap.view;
    NSUInteger tag = views.tag;
    self.fixBlock(tag);
}
-(void)initAllControl{
    
  
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
@end
