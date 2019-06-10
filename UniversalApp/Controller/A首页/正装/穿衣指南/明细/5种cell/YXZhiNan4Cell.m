//
//  YXZhiNan4Cell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/27.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXZhiNan4Cell.h"
#import "SDCycleScrollView.h"

@interface YXZhiNan4Cell()<SDCycleScrollViewDelegate>
- (void)setUpSycleScrollView:(NSArray *)photoArray height:(CGFloat)height;
@property(nonatomic)SDCycleScrollView *cycleScrollView3;
@end

@implementation YXZhiNan4Cell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setCellData:(NSDictionary *)dic{
    self.lunboHeight.constant = (KScreenWidth - 30)* [dic[@"ratio"] doubleValue];

    [self setUpSycleScrollView:dic[@"detail_list"] height:(KScreenWidth-30)*[dic[@"ratio"] doubleValue]];
}


//添加轮播图
- (void)setUpSycleScrollView:(NSArray *)photoArray height:(CGFloat)height{
    [_cycleScrollView3 removeFromSuperview];
    _cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0,KScreenWidth-30, self.lunboHeight.constant) shouldInfiniteLoop:NO imageNamesGroup:@[]];
    ViewRadius(_cycleScrollView3, 5);
    _cycleScrollView3.delegate = self;
    [self.lunboView addSubview:_cycleScrollView3];
    _cycleScrollView3.delegate = self;
    _cycleScrollView3.bannerImageViewContentMode = 0;
    _cycleScrollView3.imageURLStringsGroup = [NSArray arrayWithArray:photoArray];
    _cycleScrollView3.currentPageDotColor =  kRGBA(12, 36, 45, 1.0);
    _cycleScrollView3.showPageControl = YES;
    _cycleScrollView3.autoScrollTimeInterval = 10000;
    _cycleScrollView3.pageDotColor = YXRGBAColor(239, 239, 239);
    _cycleScrollView3.backgroundColor = KWhiteColor;
}


@end
