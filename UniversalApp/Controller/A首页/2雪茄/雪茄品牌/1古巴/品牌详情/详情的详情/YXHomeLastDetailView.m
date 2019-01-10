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
@interface YXHomeLastDetailView ()
@property(nonatomic)QMUIGridView * gridView;
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
    
}
-(void)againSetDetailView:(NSDictionary *)startDic  allDataDic:(NSDictionary *)allDataDic{
    //头图片
    [self.lastImageView sd_setImageWithURL:[NSURL URLWithString:startDic[@"photo"]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    //头名字
    self.lastTitleLbl.text = kGetString(startDic[@"cigar_name"]);
    //国内售价
    self.lastPrice1Lbl.text = kGetString(startDic[@"price_box_china"]);
    //香港售价
    self.lastPrice2Lbl.text = kGetString(startDic[@"price_box_hongkong"]);
    //海外售价
    self.lastPrice3Lbl.text = kGetString(startDic[@"price_box_overswas"]);
    //我来点评
    ViewBorderRadius(self.lastMyTalkBtn, 5, 1, [UIColor lightGrayColor]);
    //总分的五颗星
    [self fiveStarView:nsstringToFloat(allDataDic[@"average_score__avg"]) view:self.lastAllScoreFiveView];
    //外观
    [self fiveStarView:nsstringToFloat(allDataDic[@"out_looking__avg"]) view:self.lastWaiGuanFiveView];
    //燃烧
    [self fiveStarView:nsstringToFloat(allDataDic[@"burn__avg"]) view:self.lastRanShaoFiveView];
    //香味
    [self fiveStarView:nsstringToFloat(allDataDic[@"fragrance__avg"]) view:self.lastXiangWeiFiveView];
    //口感
    [self fiveStarView:nsstringToFloat(allDataDic[@"mouthfeel__avg"]) view:self.lastKouGanFiveView];
    //六宫格
//    [self sixPhotoviewValue];
    //品牌
    self.lastPinPaiLbl.text = kGetString(startDic[@"cigar_brand"]);
    //环径
    self.lastHuanJingLbl.text = kGetString(startDic[@"ring_gauge"]);
    //长度
    self.lastChangDuLbl.text = kGetString(startDic[@"length"]);
    //口味
    self.lastXiangWeiLbl.text = kGetString(startDic[@"flavour"]);
}
-(void)fiveStarView:(CGFloat)score view:(UIView *)view{
    XHStarRateView *starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    starRateView.currentScore = score;
    starRateView.isAnimation = YES;
    starRateView.rateStyle = IncompleteStar;
    starRateView.tag = 1;
    [view addSubview:starRateView];
}
-(void)setSixPhotoView:(NSMutableArray *)imageArray{
    [self sixPhotoviewValue:imageArray];
}
-(void)sixPhotoviewValue:(NSMutableArray *)imageArray{
    ViewBorderRadius(self.lastSixPhotoView, 5, 1, [UIColor lightGrayColor]);
    if (!self.gridView) {
        self.gridView = [[QMUIGridView alloc] init];
    }
    float height = self.lastSixPhotoView.frame.size.height;
    NSInteger count = imageArray.count;
    self.gridView.frame = CGRectMake(0, 0, self.lastSixPhotoView.frame.size.width, height/2);
    [self.lastSixPhotoView addSubview:self.gridView];
    
    self.gridView.columnCount = 3;
    self.gridView.rowHeight = height;
    self.gridView.separatorWidth = PixelOne;
    self.gridView.separatorColor = UIColorSeparator;
    self.gridView.separatorDashed = NO;
    
    for (NSInteger i = 0; i < count; i++) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0 , self.gridView.frame.size.width, self.gridView.frame.size.height)];
        [imageView setContentMode:UIViewContentModeScaleToFill];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageArray[i]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
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
    
}
-(void)initAllControl{
    
  
}
- (IBAction)lastMyTalkAction:(id)sender {
    if (self.delegate  && [self.delegate respondsToSelector:@selector(clickMyTalkAction)]) {
        [self.delegate clickMyTalkAction];
    }
}
- (IBAction)lastSearchAllAction:(id)sender {
}
- (IBAction)lastSegmentAction:(id)sender {
}
@end
