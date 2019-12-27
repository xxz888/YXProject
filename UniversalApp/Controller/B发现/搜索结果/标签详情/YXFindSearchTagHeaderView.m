//
//  YXFindSearchTagHeaderView.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/4/2.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXFindSearchTagHeaderView.h"

@implementation YXFindSearchTagHeaderView


- (void)drawRect:(CGRect)rect {
    //创建毛玻璃效果
    UIBlurEffect * blur = [UIBlurEffect effectWithStyle:2];
    //创建毛玻璃视图
    UIVisualEffectView * visualView = [[UIVisualEffectView alloc] initWithEffect:blur];
    visualView.alpha = 0.8f;
    visualView.frame = self.titleImageView.bounds;
    //添加到imageView上
    [self.titleImageView addSubview:visualView];
    
    
    
    
    if (![userManager loadUserInfo]) {
        self.shoucangView.hidden = YES;
    }else{
        self.shoucangView.hidden= NO;
    }
}

- (IBAction)backVcAction:(id)sender {
    self.backvcblock();
}
- (IBAction)fenxiangAction:(id)sender {
    self.fenxiangblock();
}

- (IBAction)segmentAction:(id)sender {
    self.block(self.segment.selectedSegmentIndex);
}
- (IBAction)shoucangAction:(UIButton *)sender {
    self.shoucangblock(sender.tag);
}
@end
