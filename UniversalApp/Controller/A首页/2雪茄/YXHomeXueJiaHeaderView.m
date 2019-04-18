//
//  YXHomeXueJiaHeaderView.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/3.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaHeaderView.h"
#import "SDCycleScrollView.h"
#import "YXGridView.h"

@interface YXHomeXueJiaHeaderView()<SDCycleScrollViewDelegate>
@property(nonatomic)NSMutableArray * photoArray;
@property(nonatomic,strong)SDCycleScrollView *cycleScrollView3;


@end
@implementation YXHomeXueJiaHeaderView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    //九宫格
    [self createMiddleCollection:_titleArray titleTagArray:_titleTagArray];
    [self setUpSycleScrollView:self.scrollImgArray];
}


- (NSMutableArray *)photoArray{
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}
//添加轮播图
- (void)setUpSycleScrollView:(NSMutableArray *)imageArray{
    [self.underView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    NSMutableArray * photoArray = [NSMutableArray array];
    NSMutableArray * titleArray = [NSMutableArray array];
    for (NSDictionary * dic in imageArray) {
        [photoArray addObject:dic[@"photo"]];
        [titleArray addObject:dic[@"title"]];
    }
    

    if (!_cycleScrollView3) {
            _cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, self.underView.frame.size.height) delegate:self placeholderImage:[UIImage imageNamed:@""]];
    }
    [self.underView addSubview:_cycleScrollView3];


    _cycleScrollView3.bannerImageViewContentMode =  0;
    _cycleScrollView3.showPageControl = YES;
    _cycleScrollView3.autoScrollTimeInterval = 4;
    _cycleScrollView3.titlesGroup = titleArray;
    _cycleScrollView3.imageURLStringsGroup = [NSArray arrayWithArray:photoArray];

    

}   
//九宫格
- (void)createMiddleCollection:(NSArray *)titleArray titleTagArray:(NSArray *)titleTagArray{
    [self.middleView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (!self.gridView) {
        self.gridView = [[QMUIGridView alloc] init];
    }
    [self.middleView addSubview:self.gridView];
    
    self.gridView.frame = CGRectMake(0, 0, self.middleView.frame.size.width, self.middleView.frame.size.height);
    self.gridView.columnCount = 3;
    self.gridView.rowHeight = 75;
    self.gridView.separatorWidth = 10;
    self.gridView.separatorColor = KClearColor;
    self.gridView.separatorDashed = NO;
    
    // 将要布局的 item 以 addSubview: 的方式添加进去即可自动布局
    NSArray<UIColor *> *themeColors = @[UIColorTheme1, UIColorTheme2, UIColorTheme3, UIColorTheme4, UIColorTheme5, UIColorTheme6];
    [self.gridView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (NSInteger i = 0; i < themeColors.count; i++) {
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXGridView" owner:self options:nil];
        YXGridView * view = [nib objectAtIndex:0];
        view.titleLbl.text = titleArray[i];
        view.titleTagLbl.text = titleTagArray[i];
        view.titleLbl.textColor = KBlackColor;
        view.titleLbl.font = [UIFont systemFontOfSize:14];
        view.titleTagLbl.font = [UIFont systemFontOfSize:13];

        view.tag = i;
//        view.backgroundColor = [themeColors[i] colorWithAlphaComponent:.7];
        [self.gridView addSubview:view];
        //view添加点击事件
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [view addGestureRecognizer:tapGesturRecognizer];

    }
}
-(void)tapAction:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIView *views = (UIView*) tap.view;
    NSUInteger tag = views.tag;
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickGridView:)]) {
        [self.delegate clickGridView:tag];
    }
}
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    self.scrollImgBlock(index);
}
@end
