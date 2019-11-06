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
    //拿到searchBar的输入框
//    UITextField *searchTextField = [self.searchBar valueForKey:@"_searchField"];
//    //字体大小
//    searchTextField.font = [UIFont systemFontOfSize:13];
//
//    [self addShadowToView:self withColor:KDarkGaryColor];
    self.findTextField.tintColor = SEGMENT_COLOR;
    self.findTextField.textColor = SEGMENT_COLOR;


}



/// 添加四边阴影效果
- (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor {
    // 阴影颜色
    theView.layer.shadowColor = theColor.CGColor;
    // 阴影偏移，默认(0, -3)
    theView.layer.shadowOffset = CGSizeMake(0,0);
    // 阴影透明度，默认0
    theView.layer.shadowOpacity = 0.2;
    // 阴影半径，默认3
    theView.layer.shadowRadius = 15;
}
/**
 通过覆盖intrinsicContentSize函数修改自定义View的Intrinsic的大小
 @return CGSize
 */
-(CGSize)intrinsicContentSize
{

        return CGSizeMake(KScreenWidth-40, 40);

}
- (IBAction)cancleAction:(id)sender{
    
}
@end
