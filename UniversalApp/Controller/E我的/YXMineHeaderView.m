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
    self.topHeight.constant = IS_IPhoneX ? 44 : 20;
    
    self.backgroundColor = SEGMENT_COLOR;
    UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)];
    click.numberOfTapsRequired = 1;
    self.mineImageView.userInteractionEnabled = YES;
    [self.mineImageView addGestureRecognizer:click];
    
    UITapGestureRecognizer *click1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)];
    click.numberOfTapsRequired = 1;
    self.qianmingLbl.userInteractionEnabled = YES;
    [self.qianmingLbl addGestureRecognizer:click1];
    click.numberOfTapsRequired = 1;
    [self.fasixinBtn setTitleColor:A_COlOR forState:0];
    [self.fasixinBtn setBackgroundColor:KClearColor];
    [self.fasixinView setBackgroundColor:kRGBA(64, 75, 84, 1)];
    ViewBorderRadius(self.fasixinView, 5, 1,KClearColor);
    
    ViewBorderRadius(self.guanzhuBtn, 16, 1,KClearColor);
    ViewBorderRadius(self.qiandaoBtn, 16, 1,KClearColor);
    
  UIImage *backImage = [WP_TOOL_ShareManager gradientImageWithBounds:self.qiandaoBtn.frame andColors:@[kRGBA(216, 200, 156, 1), kRGBA(190, 168, 119, 1), kRGBA(176, 151, 99, 1)] andGradientType:1];
  UIColor *bgColor = [UIColor colorWithPatternImage:backImage];
  [self.qiandaoBtn  setBackgroundColor:bgColor];
}

-(void)clickAction:(id)sender{
    self.mineClickImageblock();
}
-(void)gexingqianmingAction:(id)sender{
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
- (IBAction)qiandaoAction:(id)sender {
    self.editPersionblock();
}
- (IBAction)shangchengAction:(id)sender {
    self.shangchengblock();
}
- (IBAction)dongtaiAction:(id)sender {
    self.dongtaiBtn.font = FONT(@"Helvetica-Bold", 21);
    self.choucangBtn.font = FONT(@"Helvetica-Bold", 15);
    
    [self.dongtaiBtn setTitleColor:KBlackColor forState:0];
    [self.choucangBtn setTitleColor:kRGBA(153, 153, 153, 1) forState:0];
    
    
    
    
    self.shoucangSegmentViewHeight.constant = self.dongtaiAndShouCangSegmentToBottomHeight.constant = 0;
    self.selectSegmentblock(0);
}
- (IBAction)shoucangAction:(id)sender {
    self.dongtaiBtn.font = FONT(@"Helvetica-Bold", 15);
    self.choucangBtn.font = FONT(@"Helvetica-Bold", 21);
    [self.choucangBtn setTitleColor:KBlackColor forState:0];
    [self.dongtaiBtn setTitleColor:kRGBA(153, 153, 153, 1) forState:0];
    self.shoucangSegmentViewHeight.constant = self.dongtaiAndShouCangSegmentToBottomHeight.constant = 60;
    self.selectSegmentblock(1);
}
- (IBAction)shoucangSegmentAction:(UIButton *)sender{
    self.shoucangSegmentblock(sender.tag);
}
- (IBAction)liaoTianAction:(id)sender {
    self.liaoTianblock();
}
@end
