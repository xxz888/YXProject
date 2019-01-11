//
//  YXHomeXueJiaFootTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/11.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaFootTableViewCell.h"
#import "XHStarRateView.h"
@interface YXHomeXueJiaFootTableViewCell () <XHStarRateViewDelegate>

@end
@implementation YXHomeXueJiaFootTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self fiveStarView:4 view:self.footStarView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)fiveStarView:(CGFloat)score view:(UIView *)view{
    XHStarRateView *starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    starRateView.isAnimation = YES;
    starRateView.rateStyle = WholeStar;
    starRateView.tag = 1;
    starRateView.currentScore = 5;
    starRateView.delegate =self;
    [view addSubview:starRateView];
    
}
@end
