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

@interface YXHomeLastDetailView (){
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
    // 预览视图
    _previewView = [[MMImagePreviewView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
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
    starRateView.userInteractionEnabled = NO;
}
-(void)setSixPhotoView:(NSMutableArray *)imageArray{
    _imageCount = imageArray.count;
    [self sixPhotoviewValue:imageArray];
}
-(void)sixPhotoviewValue:(NSMutableArray *)imageArray{
    [self.lastSixPhotoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    
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
        MMImageView *imageView = [[MMImageView alloc]initWithFrame:CGRectMake(0,0 , self.gridView.frame.size.width, self.gridView.frame.size.height)];
        imageView.tag = 1000 + i;
        [imageView setContentMode:UIViewContentModeScaleToFill];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageArray[i]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
        [self.gridView addSubview:imageView];
        imageView.tag = i;
        //view添加点击事件
//        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapSmallViewCallback:)];
//        [imageView addGestureRecognizer:tapGesturRecognizer];
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
    self.searchAllBlock();
}
- (IBAction)lastSegmentAction:(UISegmentedControl *)sender{
    self.block(sender.selectedSegmentIndex);
}


#pragma mark - 小图单击
- (void)singleTapSmallViewCallback:(id)sender
{
    
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIView *views = (UIView*) tap.view;
    if (_imageCount == 0) {
        return;
    }
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    // 解除隐藏
    [window addSubview:_previewView];
    [window bringSubviewToFront:_previewView];
    // 清空
    [_previewView.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 添加子视图
    NSInteger index = views.tag-1000;
    NSInteger count = _imageCount;
    CGRect convertRect;
    if (count == 1) {
        [_previewView.pageControl removeFromSuperview];
    }
    for (NSInteger i = 0; i < count; i ++)
    {
        // 转换Frame
        MMImageView *pImageView = (MMImageView *)[self viewWithTag:1000+i];
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
- (void)singleTapBigViewCallback:(MMScrollView *)scrollView
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
