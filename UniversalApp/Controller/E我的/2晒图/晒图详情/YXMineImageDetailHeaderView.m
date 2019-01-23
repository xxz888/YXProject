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

@end
@implementation YXMineImageDetailHeaderView



- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (IBAction)lastSegmentAction:(id)sender{
    self.block(self.lastSegmentControl.selectedSegmentIndex);
}
- (IBAction)guanzhuAction:(id)sender {
}


-(void)setContentViewValue:(NSArray *)photoArray{
    [self setUpSycleScrollView:photoArray];
}
//添加轮播图
- (void)setUpSycleScrollView:(NSArray *)photoArray{
 
    if (!_cycleScrollView3) {
        _cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth-10, self.contentView.frame.size.height) delegate:self placeholderImage:[UIImage imageNamed:@"img_moren"]];
        [self.contentView addSubview:_cycleScrollView3];
    }
    _cycleScrollView3.bannerImageViewContentMode =  3;
    _cycleScrollView3.showPageControl = NO;
    _cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    _cycleScrollView3.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    _cycleScrollView3.autoScrollTimeInterval = 4;
    _cycleScrollView3.imageURLStringsGroup = [NSArray arrayWithArray:photoArray];
}
@end
