//
//  YXMineImageDetailHeaderView.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/23.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineImageDetailHeaderView.h"
#import "SDCycleScrollView.h"
@interface YXMineImageDetailHeaderView()<SDCycleScrollViewDelegate>
@property(nonatomic)SDCycleScrollView *cycleScrollView3;
@property (nonatomic,strong) UIWebView * webView;
@property (nonatomic)NSInteger tatolCount;


@end
@implementation YXMineImageDetailHeaderView



- (void)drawRect:(CGRect)rect {
    self.rightCountLbl.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5f];
    self.rightCountLbl.textColor = KWhiteColor;
    ViewRadius(self.rightCountLbl, 10);
}

- (IBAction)lastSegmentAction:(id)sender{
    if (self.block) {
        self.block(self.lastSegmentControl.selectedSegmentIndex);
    }
}
- (IBAction)guanzhuAction:(id)sender {
}

//添加轮播图
- (void)setUpSycleScrollView:(NSArray *)photoArray height:(CGFloat)height{
    self.conViewHeight.constant = height;
    _tatolCount = photoArray.count;
    if (!_cycleScrollView3) {
        _cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, height) delegate:self placeholderImage:[UIImage imageNamed:@""]];
        [self.contentView addSubview:_cycleScrollView3];
    }
    _cycleScrollView3.delegate = self;
    _cycleScrollView3.bannerImageViewContentMode = 0;
   _cycleScrollView3.imageURLStringsGroup = [NSArray arrayWithArray:photoArray];
    _cycleScrollView3.showPageControl = YES;
    _cycleScrollView3.autoScrollTimeInterval = 10000;
    _cycleScrollView3.currentPageDotColor = KRedColor;
    _cycleScrollView3.pageDotColor = YXRGBAColor(239, 239, 239);

}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    self.rightCountLbl.text = [NSString stringWithFormat:@"%ld/%ld",index+1,_tatolCount];
}
- (IBAction)editPersonAction:(id)sender {
}
@end
