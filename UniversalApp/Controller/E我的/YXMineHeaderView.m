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
    
    
    UITapGestureRecognizer * jifenclick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jifenclickAction:)];
    //点击几次后触发事件响应，默认为：1
    click.numberOfTapsRequired = 1;
    [self.jifenView addGestureRecognizer:jifenclick];
    
    ViewBorderRadius(self.jifenView, 15, 1, kRGBA(176, 151, 99, 1));
    ViewBorderRadius(self.sexView, 14, 1, KWhiteColor);
    ViewBorderRadius(self.nvsexview, 14, 1, KWhiteColor);
    [self.fasixinBtn setTitleColor:A_COlOR forState:0];
    [self.fasixinBtn setBackgroundColor:KClearColor];
    ViewBorderRadius(self.fasixinBtn, 5, 1,A_COlOR);
    
    
    [self.fasixinView setBackgroundColor:kRGBA(64, 75, 84, 1)];
    ViewBorderRadius(self.fasixinView, 5, 1,KClearColor);
}
-(void)clickAction:(id)sender{
//    self.imageScale= [ImageScale new];
//    [self.imageScale scaleImageView:self.mineImageView];
    self.mineClickImageblock();
}
-(void)jifenclickAction:(id)sender{
    self.jifenShopblock();
}
- (IBAction)guanzhuAction:(id)sender{
    self.guanzhublock();
}
- (IBAction)fensiAction:(id)sender{
    self.fensiblock();
    
}
- (IBAction)tieshuAction:(id)sender{
    self.editPersionblock();
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
- (IBAction)shezhiAction:(id)sender {
    self.settingBlock();
}
- (IBAction)fasixinAction:(id)sender {
    self.fasixinblock();
}
@end
