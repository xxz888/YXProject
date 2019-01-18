//
//  YXGEPPinPaiDetailHeaderView.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/18.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXGEPPinPaiDetailHeaderView.h"

@implementation YXGEPPinPaiDetailHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)segmentCon:(id)sender {
}
- (IBAction)section1GuanZhuAction:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickGuanZhuAction:)]) {
        [self.delegate clickGuanZhuAction:self.section1GuanZhuBtn];
    }
}
@end
