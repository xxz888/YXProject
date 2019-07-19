//
//  YXMineHeaderView.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/29.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineHeaderView.h"

@implementation YXMineHeaderView

- (void)drawRect:(CGRect)rect {
    UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)];
    //点击几次后触发事件响应，默认为：1
    click.numberOfTapsRequired = 1;
    [self.mineImageView addGestureRecognizer:click];
}
-(void)clickAction:(id)sender{
    self.imageScale= [ImageScale new];
    [self.imageScale scaleImageView:self.mineImageView];
}
- (IBAction)editPersonAction:(id)sender{
    self.editPersionblock();
}
- (IBAction)guanzhuAction:(id)sender{
    self.guanzhublock();
}
- (IBAction)fensiAction:(id)sender{
    self.fensiblock();
    
}
- (IBAction)tieshuAction:(id)sender{
    self.tieshublock();
}
-(void)setViewUI{

}
- (IBAction)setAction:(id)sender {
    self.setblock();
}
- (IBAction)guanZhuOtherAction:(id)sender {
    self.guanZhuOtherblock();
}
- (IBAction)backVCAction:(id)sender {
    self.mineBackVCBlock();
}
@end
