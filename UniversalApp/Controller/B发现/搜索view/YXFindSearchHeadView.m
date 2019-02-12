//
//  YXFindSearchHeadView.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/2/12.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXFindSearchHeadView.h"

@implementation YXFindSearchHeadView
- (void)drawRect:(CGRect)rect {
    ViewBorderRadius(self.findTextField, 2, 1, YXRGBAColor(235, 235, 235));
}
- (CGSize)intrinsicContentSize{
    return UILayoutFittingExpandedSize;
}
- (IBAction)cancleAction:(id)sender{
    
}
@end
