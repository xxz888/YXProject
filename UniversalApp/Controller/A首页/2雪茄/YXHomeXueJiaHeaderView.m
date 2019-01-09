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


- (NSMutableArray *)photoArray{
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}
//添加轮播图
- (void)setUpSycleScrollView:(NSMutableArray *)imageArray{
    [self.photoArray addObject:@"http://www.cigaronline.cn/upload/image/20181225/20181225030921_665.png"];
    [self.photoArray addObject:@"http://www.cigaronline.cn/upload/image/20181222/20181222035425_728.jpg"];
    [self.photoArray addObject:@"http://www.cigaronline.cn/upload/image/20181219/20181219031157_371.png"];
    NSMutableArray * array = [[NSMutableArray alloc]init];
//    
//    for (NSDictionary * dic in YX_MANAGER.advertisingArray) {
//        [self.photoArray addObject:dic[@"photo"]];
//    }
    SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, self.underView.frame.size.height) delegate:self placeholderImage:[UIImage imageNamed:@"img_moren"]];
    cycleScrollView3.bannerImageViewContentMode =  3;
    cycleScrollView3.showPageControl = NO;
    cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"img_moren"];
    cycleScrollView3.pageDotImage = [UIImage imageNamed:@"img_moren"];
    cycleScrollView3.autoScrollTimeInterval = 4;
    cycleScrollView3.titlesGroup = @[@"密歇根州通过雪茄永久税务上限",
                                     @"高希霸珍藏罗布图2014限量版雪茄发售",
                                     @"德鲁庄园宣布LIGA PRIVADA 10 周年纪念版雪茄发货"];
    cycleScrollView3.imageURLStringsGroup = [NSArray arrayWithArray:self.photoArray];
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
    self.gridView.rowHeight = 75;
    self.gridView.separatorWidth = PixelOne;
    self.gridView.separatorColor = UIColorSeparator;
    self.gridView.separatorDashed = NO;
    
    // 将要布局的 item 以 addSubview: 的方式添加进去即可自动布局
    NSArray<UIColor *> *themeColors = @[UIColorTheme1, UIColorTheme2, UIColorTheme3, UIColorTheme4, UIColorTheme5, UIColorTheme6];
    NSArray * titleArray = @[@"雪茄品牌",@"雪茄文化",@"雪茄配件",@"工具",@"问答",@"品鉴足迹"];
    NSArray * titleTagArray = @[@"Cigar Brand",@"Culture",@"Accessories",@"Tools",@"Q&A",@"Journey"];
    for (NSInteger i = 0; i < themeColors.count; i++) {
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXGridView" owner:self options:nil];
        YXGridView * view = [nib objectAtIndex:0];
        view.titleLbl.text = titleArray[i];
        view.titleTagLbl.text = titleTagArray[i];
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
@end
