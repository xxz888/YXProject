//
//  YXDingZhiDetailView.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/13.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXDingZhiDetailView.h"

@implementation YXDingZhiDetailView

- (void)drawRect:(CGRect)rect {
    [ShareManager fiveStarView:5 view:self.starView];
}


- (IBAction)pinglunAction:(id)sender {
    self.pingLunBlock();
}
@end
