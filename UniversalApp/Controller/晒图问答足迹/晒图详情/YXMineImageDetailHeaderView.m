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

@end
@implementation YXMineImageDetailHeaderView



- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (IBAction)lastSegmentAction:(id)sender{
    if (self.block) {
        self.block(self.lastSegmentControl.selectedSegmentIndex);
    }
}
- (IBAction)guanzhuAction:(id)sender {
}

//添加轮播图
- (void)setUpSycleScrollView:(NSArray *)photoArray{
 
    if (!_cycleScrollView3) {
        _cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth-10, 400) delegate:self placeholderImage:[UIImage imageNamed:@"img_moren"]];
        [self.contentView addSubview:_cycleScrollView3];
    }
    _cycleScrollView3.bannerImageViewContentMode =  3;
    _cycleScrollView3.showPageControl = NO;
    _cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    _cycleScrollView3.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    _cycleScrollView3.autoScrollTimeInterval = 4;
   _cycleScrollView3.imageURLStringsGroup = [NSArray arrayWithArray:photoArray];
}
-(void)setSycleScrollView:(NSArray *)photoArray{
    _cycleScrollView3.imageURLStringsGroup = [NSArray arrayWithArray:photoArray];
}
-(void)setUpWebView:(NSString *)htmlString{
    if (!self.webView) {
        self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
        [self.contentView addSubview:self.webView];
    }
    [self.webView loadHTMLString:[ShareManager justFitImage:htmlString] baseURL:nil];
}
- (IBAction)editPersonAction:(id)sender {
}
@end
