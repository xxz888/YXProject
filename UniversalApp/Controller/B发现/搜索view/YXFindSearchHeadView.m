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
    UIColor *color =  YXRGBAColor(217, 217, 217);
    ViewBorderRadius(self.searchBar, 15, 1, color);
    //拿到searchBar的输入框
    UITextField *searchTextField = [self.searchBar valueForKey:@"_searchField"];
    //字体大小
    searchTextField.font = [UIFont systemFontOfSize:14];
}
/**
 通过覆盖intrinsicContentSize函数修改自定义View的Intrinsic的大小
 @return CGSize
 */
-(CGSize)intrinsicContentSize
{

        return CGSizeMake(KScreenWidth-20, 34);

}
- (IBAction)cancleAction:(id)sender{
    
}
@end
