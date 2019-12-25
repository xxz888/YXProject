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
    self.findTextField.tintColor = SEGMENT_COLOR;
    self.findTextField.textColor = SEGMENT_COLOR;
}
-(CGSize)intrinsicContentSize{
    return CGSizeMake(KScreenWidth-10, 40);
}
- (IBAction)cancleAction:(id)sender{
    
}
@end
