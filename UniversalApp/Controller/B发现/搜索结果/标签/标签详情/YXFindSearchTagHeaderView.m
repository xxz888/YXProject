//
//  YXFindSearchTagHeaderView.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/4/2.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXFindSearchTagHeaderView.h"

@implementation YXFindSearchTagHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)segmentAction:(id)sender {
    self.block(self.segment.selectedSegmentIndex);
}
@end
