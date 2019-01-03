//
//  YXHomeXueJiaHeaderView.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/3.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaHeaderView.h"
#import "SDCycleScrollView.h"
@interface YXHomeXueJiaHeaderView()<SDCycleScrollViewDelegate>
@end
@implementation YXHomeXueJiaHeaderView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
  
    //轮播图
    [self setUpSycleScrollView:nil];
    //九宫格
    [self createMiddleCollection];
}



//添加轮播图
- (void)setUpSycleScrollView:(NSMutableArray *)imageArray{
    NSMutableArray * photoArray = [[NSMutableArray alloc]init];
    for (NSDictionary * dic in YX_MANAGER.advertisingArray) {
        [photoArray addObject:dic[@"photo"]];
    }
SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, self.underView.frame.size.height) delegate:self placeholderImage:[UIImage imageNamed:@""]];
cycleScrollView3.bannerImageViewContentMode =  1;
cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
cycleScrollView3.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
cycleScrollView3.autoScrollTimeInterval = 4;
cycleScrollView3.imageURLStringsGroup = [NSArray arrayWithArray:photoArray];
    [cycleScrollView3 setPlaceholderImage:[UIImage imageNamed:@"img_moren"]];
    [self.underView addSubview:cycleScrollView3];
}
//九宫格
- (void)createMiddleCollection{
    if (!self.gridView) {
        self.gridView = [[QMUIGridView alloc] init];
    }
    [self.middleView addSubview:self.gridView];
    
    self.gridView.frame = CGRectMake(0, 0, self.middleView.frame.size.width, self.middleView.frame.size.height);
    self.gridView.columnCount = 3;
    self.gridView.rowHeight = 110;
    self.gridView.separatorWidth = PixelOne;
    self.gridView.separatorColor = UIColorSeparator;
    self.gridView.separatorDashed = NO;
    
    // 将要布局的 item 以 addSubview: 的方式添加进去即可自动布局
    NSArray<UIColor *> *themeColors = @[UIColorTheme1, UIColorTheme2, UIColorTheme3, UIColorTheme4, UIColorTheme5, UIColorTheme6];
    for (NSInteger i = 0; i < themeColors.count; i++) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [themeColors[i] colorWithAlphaComponent:.7];
        [self.gridView addSubview:view];
    }
}
@end
