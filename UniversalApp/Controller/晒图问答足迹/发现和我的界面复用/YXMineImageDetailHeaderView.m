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
    self.rightCountLbl.hidden = height == 0 ;
    self.conViewHeight.constant = height;
    _tatolCount = photoArray.count;
    if (!_cycleScrollView3) {
//        _cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, height) delegate:self placeholderImage:[UIImage imageNamed:@""]];
        _cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, height) shouldInfiniteLoop:NO imageNamesGroup:[NSArray arrayWithArray:photoArray]];
        _cycleScrollView3.delegate = self;
        [self.contentView addSubview:_cycleScrollView3];
    }

    _cycleScrollView3.delegate = self;
    _cycleScrollView3.bannerImageViewContentMode = 0;
   _cycleScrollView3.imageURLStringsGroup = [NSArray arrayWithArray:photoArray];
    _cycleScrollView3.currentPageDotColor = A_COlOR;
    _cycleScrollView3.showPageControl = YES;
    _cycleScrollView3.autoScrollTimeInterval = 10000;
    _cycleScrollView3.pageDotColor = YXRGBAColor(239, 239, 239);
    _cycleScrollView3.backgroundColor = KWhiteColor;

}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    self.rightCountLbl.text = [NSString stringWithFormat:@"%ld/%ld",index+1,_tatolCount];
//    if (cycleScrollView.isLeftScroll && index == 1) {
//        self.rightBlock();
//    }
}
- (IBAction)editPersonAction:(id)sender {
}

-(CGFloat)getLblHeight:(NSDictionary *)dic{
    NSString * titleText = [NSString stringWithFormat:@"%@%@",dic[@"content"] ? dic[@"content"]:dic[@"describe"],dic[@"index"]];
    CGFloat height_size = [ShareManager inTextOutHeight:[titleText UnicodeToUtf8]];
    return height_size;
}

@end
