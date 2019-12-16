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
