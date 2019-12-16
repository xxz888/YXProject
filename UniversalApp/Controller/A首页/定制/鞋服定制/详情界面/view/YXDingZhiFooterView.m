//
//  YXDingZhiFooterView.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/16.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXDingZhiFooterView.h"

@implementation YXDingZhiFooterView

- (void)drawRect:(CGRect)rect {
    ViewBorderRadius(self.allBtn, 16, 1,kRGBA(238, 238, 238, 1));
}


- (IBAction)allBtnAction:(id)sender {
    self.allBtnBlock();
}
@end
